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

    
    let user = NSUserDefaults.standardUserDefaults()    //用户全局登入信息
    let userBL = UserBL()

    // 本地登入
    @IBAction func clickLogin(sender: AnyObject) {
        
        var userName = userNameField.text
        var password = passwordField.text
        
        userBL.UserLogin("freedom", password: "123456").continueWithSuccessBlock({ [weak self] (task: BFTask!) -> BFTask! in
            let userInfo = (task.result as? User)!
            
            return nil
        })
        
        //userNameField.frame.size.height = 160

        println("本地登入--帐号：\(userName)，密码：\(password)")
    }

    // 第三方Google登入
    @IBAction func googleLogin(sender: AnyObject) {
        println("Google登入")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        var rect: CGRect = userNameField.frame;
//        rect.size.height = 150;
//        userNameField.frame = rect;
        
        userNameField.borderStyle = UITextBorderStyle.RoundedRect
        userNameField.layer.borderColor = UIColor.blackColor().CGColor

        
        passwordField.borderStyle = UITextBorderStyle.RoundedRect
        
        
        userNameField.leftView = UIImageView(image: UIImage(named: "Icon-task"))
        userNameField.leftViewMode = UITextFieldViewMode.Always
        
        
        //userNameField.layer.cornerRadius = 5.0

        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

}
