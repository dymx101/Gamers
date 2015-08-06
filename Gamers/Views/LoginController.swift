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
            
            println(userInfo)
            
            return nil
        })
        
        var alertController: UIAlertController = UIAlertController(title: "123", message: "name", preferredStyle: UIAlertControllerStyle.ActionSheet)
        alertController.addAction(UIAlertAction(title: "no", style: UIAlertActionStyle.Cancel, handler: { (alertAction) -> Void in
            //
            NSLog("no")
        }))
        alertController.addAction(UIAlertAction(title: "yes", style: UIAlertActionStyle.Default, handler: { (alertAction) -> Void in
            //
            NSLog("yes")
        }))
        self.presentViewController(alertController, animated: true, completion: nil)
        
        
        println("本地登入--帐号：\(userName)，密码：\(password)")
    }

    // 第三方Google登入
    @IBAction func googleLogin(sender: AnyObject) {
        println("Google登入")
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
