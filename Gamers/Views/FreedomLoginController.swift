//
//  FreedomLoginController.swift
//  Gamers
//
//  Created by 虚空之翼 on 15/8/25.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

import UIKit
import SwiftyJSON

class FreedomLoginController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var freedomLoginView: UIWebView!
    
    let userDefaults = NSUserDefaults.standardUserDefaults()    //用户全局登入信息
    let userBL = UserBL()
    
    var isLoginRequest = false  //是否登入授权请求

    override func viewDidLoad() {
        super.viewDidLoad()

        let urlString = "http://api.accounts.freedom.tm/auth?service=gamers&redirect_uri=http%3A%2F%2Fbeta.gamers.tm%3A3000%2Fcallback&response_type=code&roles=profile%2Cemail%2Cpartner&state=api"
        
        freedomLoginView.loadRequest(NSURLRequest(URL: NSURL(string: urlString)!))

        
    }
    

    // 获取请求链接
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        //
        var backURLString = request.URL?.absoluteString

        if backURLString!.hasPrefix("http://beta.gamers.tm:3000/callback") {
            var range: NSRange = NSMakeRange(49, 36)
            var accessToken = NSString(string: backURLString!).substringWithRange(range)
            //println(backURLString)
            isLoginRequest = true
        }

        return true
    }
    
    // 登入请求后返回的数据解析
    func webViewDidFinishLoad(webView: UIWebView) {
        if isLoginRequest {
            var html = "document.documentElement.innerText";
            var content = webView.stringByEvaluatingJavaScriptFromString(html)
            
            if let dataFromString = content!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
                let jsonData = JSON(data: dataFromString)
                // 解析数据
                var userData: User = User.collection(json: jsonData["user"])
                if let userToke = jsonData["token"].string { userData.userToke = userToke }
                if let expires = jsonData["expires"].int { userData.expires = expires }
                
                // 保存在本地
                userDefaults.setObject(userData.userId, forKey: "userId")
                userDefaults.setObject(userData.userName, forKey: "userName")
                userDefaults.setObject(userData.userToken, forKey: "userToken")
                userDefaults.setObject(userData.expires, forKey: "expires")
                
                userBL.saveUser(userData)
                
                // 登录成功跳转回用户页面
                userDefaults.setBool(true, forKey: "isLogin")
                self.navigationController?.popToRootViewControllerAnimated(true)
                
            }
            
            isLoginRequest = false  //重置请求变量
            
            // 清理数据
            self.freedomLoginView.removeFromSuperview()
            NSURLCache.sharedURLCache().removeAllCachedResponses()
            // 销毁所有cookie
            for cookie in NSHTTPCookieStorage.sharedHTTPCookieStorage().cookies! {
                NSHTTPCookieStorage.sharedHTTPCookieStorage().deleteCookie(cookie as! NSHTTPCookie)
            }
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
}

