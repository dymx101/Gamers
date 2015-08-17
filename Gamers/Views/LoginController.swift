//
//  LoginController.swift
//  Gamers
//
//  Created by 虚空之翼 on 15/8/6.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

import UIKit
import Bolts
import MBProgressHUD
import QuartzCore

class LoginController: UIViewController {

    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var userImage: UIImageView!

    let userInfo = NSUserDefaults.standardUserDefaults()    //用户全局登入信息
    let userBL = UserBL()

    var googleUserId: String!
    var googleName: String!
    var googleEmail: String!
    var googleIdToken: String!
    
    
    // 本地登入
    @IBAction func clickLogin(sender: AnyObject) {

        var userName = userNameField.text
        var password = passwordField.text
        
        userBL.UserLogin(userName: "freedom", password: "123456").continueWithSuccessBlock({ [weak self] (task: BFTask!) -> BFTask! in
            let userInfo = (task.result as? User)!
            
            return nil
        })
        
        //self.navigationController?.popToRootViewControllerAnimated(true)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 输入表单样式
        userNameField.borderStyle = UITextBorderStyle.RoundedRect
        userNameField.layer.borderColor = UIColor.blackColor().CGColor

        passwordField.borderStyle = UITextBorderStyle.RoundedRect
        
        userNameField.leftView = UIImageView(image: UIImage(named: "Icon-task"))
        userNameField.leftViewMode = UITextFieldViewMode.Always
        
        
        
        // Google登入的代理协议
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
       
        
//        GIDSignIn.sharedInstance().signOut()
//        GIDSignIn.sharedInstance().disconnect()
        
//        if (GIDSignIn.sharedInstance().hasAuthInKeychain()){
        
        //设置圆角
        userImage.clipsToBounds = true
        userImage.layer.cornerRadius = 50
        //边框
        userImage.layer.borderWidth = 1
        userImage.layer.borderColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.7).CGColor
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

}

extension LoginController: GIDSignInDelegate, GIDSignInUIDelegate {
    // 第三方Google登入
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!, withError error: NSError!) {
        if (error == nil) {
            println(user.userID)
            googleUserId = user.userID
            googleName = user.profile.name
            googleEmail = user.profile.email
            googleIdToken = user.authentication.idToken
            
            userInfo.setObject(googleUserId, forKey: "googleUserId")
            userInfo.setObject(googleName, forKey: "googleName")
            userInfo.setObject(googleEmail, forKey: "googleEmail")
            userInfo.setObject(googleIdToken, forKey: "googleIdToken")
            
            userBL.GoogleLogin(userId: googleUserId, userName: googleName, email: googleEmail, idToken: googleIdToken).continueWithSuccessBlock({ [weak self] (task: BFTask!) -> BFTask! in
                let userInfo = (task.result as? User)!
                
                self?.userInfo.setObject(true, forKey: "isLogin")
                
                return nil
            })

        } else {
            println("\(error.localizedDescription)")
        }
    }
    
    // 用户连接
    func signIn(signIn: GIDSignIn!, didDisconnectWithUser user:GIDGoogleUser!, withError error: NSError!) {

    }
}

