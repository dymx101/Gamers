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
    
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var sexLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var mobileLabel: UILabel!
    @IBOutlet weak var integralLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        
//        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:1]; 
        

        //设置圆角
        userImage.clipsToBounds = true
        userImage.layer.cornerRadius = 32
        //边框
        userImage.layer.borderWidth = 1
        userImage.layer.borderColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.7).CGColor
        
        
        self.tableView.reloadData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}

extension UserInfoController: UITableViewDelegate, UITableViewDataSource {
    
    // 点击
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 3 {
            // 退出操作
            GIDSignIn.sharedInstance().signOut()

            userInfo.removeObjectForKey("isLogin")
            
            // 清空用用户数据
            
            NSNotificationCenter.defaultCenter().postNotificationName("UserLogoutNotification", object: nil, userInfo: nil)
            

            // 提示
            var alertController: UIAlertController = UIAlertController(title: "", message: "退出成功", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.Cancel) { (alertAction) -> Void in
                // 返回到用户首页
                self.navigationController?.popToRootViewControllerAnimated(true)
            })
            
            self.presentViewController(alertController, animated: true, completion: nil)
            
        }
    }
    // 设定单元格样式
    override func viewDidLayoutSubviews() {
        var nickNameIndexPath: NSIndexPath = NSIndexPath(forRow: 0, inSection: 1)
        var nickNameCell = self.tableView.cellForRowAtIndexPath(nickNameIndexPath)
        if userInfo.objectForKey("nickName") != nil {
            nickNameCell?.accessoryType = UITableViewCellAccessoryType.None
        }
        
    }

}
