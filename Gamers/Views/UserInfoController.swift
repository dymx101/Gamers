//
//  UserInfoController.swift
//  Gamers
//
//  Created by 虚空之翼 on 15/8/6.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

import UIKit
import RealmSwift

class UserInfoController: UITableViewController {

    let userDefaults = NSUserDefaults.standardUserDefaults()    //用户全局登入信息
    var userData: User!
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var sexLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var mobileLabel: UILabel!
    @IBOutlet weak var integralLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:1];
        //设置圆角
        userImage.clipsToBounds = true
        userImage.layer.cornerRadius = 32
        //边框
        userImage.layer.borderWidth = 1
        userImage.layer.borderColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.7).CGColor
        
        println(userDefaults.stringForKey("userId")!)
        
        let realm = Realm()
        let predicate = NSPredicate(format: "userId = %@", userDefaults.stringForKey("userId")!)
        userData = realm.objects(User).filter(predicate).first! as User

        if !userData.firstName.isEmpty { nickNameLabel.text = userData.firstName + " " + userData.lastName }
        if !userData.gender.isEmpty {
            sexLabel.text = userData.gender == "M" ? "男" : "女"
        }
        if !userData.email.isEmpty { emailLabel.text = userData.email }
        if !userData.mobilePhone.isEmpty { integralLabel.text = userData.mobilePhone }
        
        var range: NSRange = NSMakeRange(NSString(string: userData.avatar).length-3, 3)
        var imageFormat = NSString(string: userData.avatar).substringWithRange(range)
        if imageFormat != "svg" {
            let imageUrl = "http://beta.gamers.tm/" + userData.avatar
            userImage.hnk_setImageFromURL(NSURL(string: imageUrl)!)
        }
        
        self.tableView.reloadData()
        
        println(userDefaults.boolForKey("isLogin"))

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
            //GIDSignIn.sharedInstance().signOut()

            userDefaults.removeObjectForKey("isLogin")
            
            // 刷新用户界面数据
            NSNotificationCenter.defaultCenter().postNotificationName("UserLogoutNotification", object: nil, userInfo: nil)

            // 提示
            var alertController: UIAlertController = UIAlertController(title: "", message: "成功退出", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.Cancel) { (alertAction) -> Void in
                // 返回到用户首页
                self.navigationController?.popToRootViewControllerAnimated(true)
            })
            
            self.presentViewController(alertController, animated: true, completion: nil)
            
        }
    }
    // 设定单元格样式
    override func viewDidLayoutSubviews() {       
        var nickNameCell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 1))
        if  !userData.userName.isEmpty {
            nickNameCell?.accessoryType = UITableViewCellAccessoryType.None
        }
        
        var genderCell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 1))
        if  !userData.gender.isEmpty {
            genderCell?.accessoryType = UITableViewCellAccessoryType.None
        }
        
        var emailCell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 2, inSection: 1))
        if  !userData.email.isEmpty {
            emailCell?.accessoryType = UITableViewCellAccessoryType.None
        }
        
        var mobilePhoneCell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 3, inSection: 1))
        if  !userData.mobilePhone.isEmpty {
            mobilePhoneCell?.accessoryType = UITableViewCellAccessoryType.None
        }
        
    }
    
//    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        //
//    }

}
