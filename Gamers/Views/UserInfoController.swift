//
//  UserInfoController.swift
//  Gamers
//
//  Created by 虚空之翼 on 15/8/6.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

import UIKit

class UserInfoController: UITableViewController {

    let userInfo = NSUserDefaults.standardUserDefaults()    //用户全局登入信息
    let userBL = UserBL()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        
        
        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}

extension UserInfoController: UITableViewDelegate, UITableViewDataSource {
    

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 3 {
            
            GIDSignIn.sharedInstance().signOut()
            
            userInfo.removeObjectForKey("googleUserId")

            
        }

    }
}
