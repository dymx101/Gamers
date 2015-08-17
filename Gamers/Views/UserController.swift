//
//  UserController.swift
//  Gamers
//
//  Created by 虚空之翼 on 15/7/20.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

import UIKit

class UserController: UITableViewController, UITableViewDataSource, UITableViewDelegate {
    
    let userInfo = NSUserDefaults.standardUserDefaults()    //用户全局登入信息
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()


        // 初始化用户资料
        if userInfo.objectForKey("userName") != nil {
            userName.text = String(stringInterpolationSegment: userInfo.objectForKey("userName")!)
            
            
            //let imageUrl = self.videoListData[indexPath.row].imageSource.stringByReplacingOccurrencesOfString(" ", withString: "%20", options: NSStringCompareOptions.LiteralSearch, range: nil)
            //userImage.kf_setImageWithURL(NSURL(string: imageUrl)!)
            userImage.image = UIImage(named: "user.png")
        }
        
        //设置圆角
        userImage.clipsToBounds = true
        userImage.layer.cornerRadius = 32
        //边框
        userImage.layer.borderWidth = 1
        userImage.layer.borderColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.7).CGColor
        

        userInfo.setObject(true, forKey: "isLogin")
        userInfo.setObject("aion", forKey: "nickName")
        
        println(userInfo.objectForKey("googleUserId"))
        
        var isLogin = userInfo.boolForKey("isLogin")
        println(isLogin)
        
        // 退出的监听事件
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "userLogout:", name: "UserLogoutNotification", object: nil)
 
        

    }
    
    // 退出清理数据
    func userLogout(notification : NSNotification) {
        println("监听退出")
        userName.text = ""
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // 点击触发
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var isLogin = userInfo.boolForKey("isLogin")

        // 个人信息和关注跳转
        switch indexPath.section {
        case 0 where isLogin:
            let userInfoView = self.storyboard!.instantiateViewControllerWithIdentifier("UserInfoVC") as? UserInfoController
            
            self.navigationController?.pushViewController(userInfoView!, animated: true)
        case 0 where !isLogin:
            let userInfoView = self.storyboard!.instantiateViewControllerWithIdentifier("LoginVC") as? LoginController
            
            self.navigationController?.pushViewController(userInfoView!, animated: true)
        case 1 where indexPath.row == 0 && isLogin:
            let userInfoView = self.storyboard!.instantiateViewControllerWithIdentifier("UserFollowVC") as? UserFollowController
            
            self.navigationController?.pushViewController(userInfoView!, animated: true)
        case 1 where indexPath.row == 0 && !isLogin:
            let userInfoView = self.storyboard!.instantiateViewControllerWithIdentifier("LoginVC") as? LoginController
            
            self.navigationController?.pushViewController(userInfoView!, animated: true)
        default:
            println("")
            
        }
    }
    
    
    
}
