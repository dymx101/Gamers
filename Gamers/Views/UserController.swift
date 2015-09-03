//
//  UserController.swift
//  Gamers
//
//  Created by 虚空之翼 on 15/7/20.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

import UIKit

class UserController: UITableViewController, UITableViewDataSource, UITableViewDelegate {
    
    let userDefaults = NSUserDefaults.standardUserDefaults()    //用户全局登入信息
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        println(userDefaults.objectForKey("isLogin"))
        
        println(userDefaults.stringForKey("userName")!)
        
        // 初始化用户资料
        if userDefaults.boolForKey("isLogin")  {
            userName.text = userDefaults.stringForKey("userName")!
            
            
//            let imageUrl = self.videoListData[indexPath.row].imageSource.stringByReplacingOccurrencesOfString(" ", withString: "%20", options: NSStringCompareOptions.LiteralSearch, range: nil)
//            userImage.kf_setImageWithURL(NSURL(string: imageUrl)!)
//            userImage.image = UIImage(named: "user.png")
            
        }
        
        //设置圆角
        userImage.clipsToBounds = true
        userImage.layer.cornerRadius = 32
        //边框
        userImage.layer.borderWidth = 1
        userImage.layer.borderColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.7).CGColor
        
        // 退出的监听事件
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "userLogout:", name: "UserLogoutNotification", object: nil)
        // 登入的监听事件
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "userLogin:", name: "UserLoginNotification", object: nil)
        
        

    }
    
    // 登入刷新界面数据
    func userLogin(notification : NSNotification) {
        userName.text = userDefaults.stringForKey("userName")!
    }
    // 退出清理数据
    func userLogout(notification : NSNotification) {
        userName.text = ""
        userImage.image = UIImage(named: "user.png")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // 点击触发
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var isLogin = userDefaults.boolForKey("isLogin")
        // 个人信息和关注跳转
        switch indexPath.section {
        case 0 where isLogin:
            let userInfoView = self.storyboard!.instantiateViewControllerWithIdentifier("UserInfoVC") as? UserInfoController
            
            self.navigationController?.pushViewController(userInfoView!, animated: true)
        case 0 where !isLogin:
            let userInfoView = self.storyboard!.instantiateViewControllerWithIdentifier("FreedomLoginVC") as? FreedomLoginController
            
            self.navigationController?.pushViewController(userInfoView!, animated: true)
        case 1 where indexPath.row == 0 && isLogin:
            let userInfoView = self.storyboard!.instantiateViewControllerWithIdentifier("UserFollowVC") as? UserFollowController
            
            self.navigationController?.pushViewController(userInfoView!, animated: true)
        case 1 where indexPath.row == 0 && !isLogin:
            let userInfoView = self.storyboard!.instantiateViewControllerWithIdentifier("FreedomLoginVC") as? FreedomLoginController
            
            self.navigationController?.pushViewController(userInfoView!, animated: true)
        default:
            println("")
            
        }
    }
    
    
    
}
