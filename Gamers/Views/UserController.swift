//
//  UserController.swift
//  Gamers
//
//  Created by 虚空之翼 on 15/7/20.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

import UIKit

class UserController: UITableViewController, UITableViewDataSource, UITableViewDelegate {
    
    let user = NSUserDefaults.standardUserDefaults()    //用户全局登入信息
    
    
    override func viewDidLoad() {
        super.viewDidLoad()


        
        
        
        
        
        
        user.setObject("Freedom", forKey: "user")
        
        println(user.objectForKey("user"))
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // 点击触发
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        if indexPath.section == 0 {
            
            if user.objectForKey("user") != nil {
                let loginView = self.storyboard!.instantiateViewControllerWithIdentifier("LoginVC") as? LoginController
                
                self.navigationController?.pushViewController(loginView!, animated: true)
            } else {
                let userInfoView = self.storyboard!.instantiateViewControllerWithIdentifier("UserInfoVC") as? UserInfoController
                
                self.navigationController?.pushViewController(userInfoView!, animated: true)
            }
        }
    }
    
    
    
}
