//
//  GoogleLoginController.swift
//  Gamers
//
//  Created by 虚空之翼 on 15/9/1.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

import UIKit
import SwiftyJSON

class GoogleLoginController: UIViewController {
    
    @IBOutlet weak var googleLoginView: UIWebView!

    let userDefaults = NSUserDefaults.standardUserDefaults()    //用户全局登入信息
    
    var isLoginRequest = false  //是否登入授权请求
    var googleCode = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let urlString = "https://accounts.google.com/o/oauth2/auth?redirect_uri=http://beta.gamers.tm:3000/back&response_type=code&client_id=921894916096-i9cuji72d09ut6qo7phcsbpkqsfcmn1a.apps.googleusercontent.com&scope=https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fyoutube+https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fyoutube.force-ssl+https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fyoutube.readonly+https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fyoutube.upload+https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fyoutubepartner+https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fyoutubepartner-channel-audit&approval_prompt=force&access_type=offline"
        
        googleLoginView.loadRequest(NSURLRequest(URL: NSURL(string: urlString)!))
        
//        print(NSUserDefaults.standardUserDefaults().stringForKey("googleAccessToken"))
        
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "navigation-bar1.png"),forBarMetrics: UIBarMetrics.CompactPrompt)
        self.navigationController?.navigationBar.shadowImage = UIImage(named: "navigation-bar1.png")
        self.navigationController?.navigationBar.translucent = false
    }
    
    
    // 获取请求链接
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        var backURLString = request.URL?.absoluteString
        if backURLString!.hasPrefix("http://beta.gamers.tm:3000/back?code=") {
            var range: NSRange = NSMakeRange(37, 46)
            googleCode = NSString(string: backURLString!).substringWithRange(range)
            isLoginRequest = true
        }
        
        return true
    }
    
//    override func viewWillAppear(animated: Bool) {
//        super.viewWillAppear(animated)
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(),forBarMetrics: UIBarMetrics.Default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.navigationBar.translucent = true
//    }
    
    
    
    // 登入请求后返回的数据解析
    func webViewDidFinishLoad(webView: UIWebView) {
        if isLoginRequest {
            //self.navigationController?.popToRootViewControllerAnimated(true)
            self.navigationController?.popViewControllerAnimated(true)
                
            UserBL.sharedSingleton.googleLogin(googleCode)
            isLoginRequest = false  //重置请求变量

            // 清理数据
            self.googleLoginView.removeFromSuperview()
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
