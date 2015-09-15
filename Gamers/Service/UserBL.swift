//
//  UserBL.swift
//  Gamers
//
//  Created by 虚空之翼 on 15/7/24.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

import Foundation
import Alamofire
import Bolts
import SwiftyJSON
import RealmSwift

class UserBL: NSObject {
    // 单例模式
    static let sharedSingleton = UserBL()

    // 用户登入
    func UserLogin(#userName: String, password: String) -> BFTask {
        var fetchTask = BFTask(result: nil)
        
        fetchTask = fetchTask.continueWithBlock({ (task) -> AnyObject! in
            return UserDao.UserLogin(userName: userName, password: password)
        })
        
        fetchTask = fetchTask.continueWithSuccessBlock({ (task) -> AnyObject! in
            if let user = task.result as? User {
                return BFTask(result: user)
            }
            
            return task
        })
        
        fetchTask = fetchTask.continueWithBlock({ (task) -> AnyObject! in
            
            return task
        })
        
        return fetchTask
    }

    
    // Google用户登入
    func GoogleLogin(#userId: String, userName: String?, email: String?, idToken: String?) -> BFTask {
        var fetchTask = BFTask(result: nil)
        
        fetchTask = fetchTask.continueWithBlock({ (task) -> AnyObject! in
            return UserDao.GoogleLogin(userId: userId, userName: userName, email: email, idToken: idToken)
        })
        
        fetchTask = fetchTask.continueWithSuccessBlock({ (task) -> AnyObject! in
            if let user = task.result as? User {
                return BFTask(result: user)
            }
            
            return task
        })
        
        fetchTask = fetchTask.continueWithBlock({ (task) -> AnyObject! in
            
            return task
        })
        
        return fetchTask
    }

    
    // 获取用户订阅频道的视频列表
    func getSubscriptions(#userToken: String?) -> BFTask {
        var fetchTask = BFTask(result: nil)
        
        fetchTask = fetchTask.continueWithBlock({ (task) -> AnyObject! in
            return UserDao.Subscriptions(userToken: userToken)
        })
        
        fetchTask = fetchTask.continueWithSuccessBlock({ (task) -> AnyObject! in
            if let users = task.result as? [User] {
                
                return BFTask(result: users)
            }
            
            return task
        })
        
        fetchTask = fetchTask.continueWithBlock({ (task) -> AnyObject! in
            
            return task
        })
        
        return fetchTask
    }
    
    
    // 用户订阅频道
    func setSubscribe(#channelId: String) -> BFTask {
        var fetchTask = BFTask(result: nil)
        
        fetchTask = fetchTask.continueWithBlock({ (task) -> AnyObject! in
            return UserDao.Subscribe(channelId: channelId)
        })
        
        fetchTask = fetchTask.continueWithSuccessBlock({ (task) -> AnyObject! in
            if let response = task.result as? Response {
                return BFTask(result: response)
            }
            
            return task
        })
        
        fetchTask = fetchTask.continueWithBlock({ (task) -> AnyObject! in
            
            return task
        })
        
        return fetchTask
    }
    
    func saveUser(user: User) {
        let realm = Realm()
        
        realm.write {
            realm.add(user, update: true)
        }
        
    }
    
    // 追隨 todo：统一使用Router
    func setFollow(#channelId: String) {
        let userDefaults = NSUserDefaults.standardUserDefaults()    //用户全局登入信息
        let isLogin = userDefaults.boolForKey("isLogin")
        
        let headers = [ "Auth-token": userDefaults.stringForKey("userToken")! ]
        
        if isLogin {
            Alamofire.request(.POST, "http://beta.gamers.tm:3000/mobile_api/subscribe?userId=\(channelId)", headers: headers).responseJSON { _, _, JSONData, _ in
                let response = Response.collection(json: JSON(JSONData!))

                if response.code == "0" {
                    let alertView: UIAlertView = UIAlertView(title: "", message: "订阅成功", delegate: nil, cancelButtonTitle: "确定")
                    alertView.show()
                } else {
                    let alertView: UIAlertView = UIAlertView(title: "", message: "订阅失败", delegate: nil, cancelButtonTitle: "确定")
                    alertView.show()
                }
            }
        } else {
            var alertView: UIAlertView = UIAlertView(title: "", message: "请先登入", delegate: nil, cancelButtonTitle: "确定")
            alertView.show()
        }
    }
    
    // 取消追隨 todo：统一使用Router
    func setUnFollow(#channelId: String) {
        let userDefaults = NSUserDefaults.standardUserDefaults()    //用户全局登入信息
        let isLogin = userDefaults.boolForKey("isLogin")
        
        let headers = [ "Auth-token": userDefaults.stringForKey("userToken")! ]
        
        if isLogin {
            Alamofire.request(.POST, "http://beta.gamers.tm:3000/mobile_api/unsubscribe?userId=\(channelId)", headers: headers).responseJSON { _, _, JSONData, _ in
                let response = Response.collection(json: JSON(JSONData!))
//                if response.code == "0" {
//                    let alertView: UIAlertView = UIAlertView(title: "", message: "取消成功", delegate: nil, cancelButtonTitle: "确定")
//                    alertView.show()
//                } else {
//                    let alertView: UIAlertView = UIAlertView(title: "", message: "取消失败", delegate: nil, cancelButtonTitle: "确定")
//                    alertView.show()
//                }
            }
        } else {
            var alertView: UIAlertView = UIAlertView(title: "", message: "请先登入", delegate: nil, cancelButtonTitle: "确定")
            alertView.show()
        }
    }
    
    // Google 登入
    func googleLogin(code: String) {
        var parameters: [String: AnyObject] = [
            "code": code,
            "client_id": "921894916096-i9cuji72d09ut6qo7phcsbpkqsfcmn1a.apps.googleusercontent.com",
            "client_secret": "282qMxcJSHOZ3DdJM5tVZxyk",
            "redirect_uri": "http://beta.gamers.tm:3000/back",
            "grant_type": "authorization_code",
        ]

        Alamofire.request(.POST, "https://www.googleapis.com/oauth2/v3/token", parameters: parameters).responseJSON { _, _, JSONData, _ in
            if let JSONData: AnyObject = JSONData {
                let googleData  = JSON(JSONData)
                NSUserDefaults.standardUserDefaults().setObject(googleData["access_token"].string, forKey: "googleAccessToken")
                NSUserDefaults.standardUserDefaults().setObject(googleData["refresh_token"].string, forKey: "googleRefreshToken")
                NSUserDefaults.standardUserDefaults().setObject(googleData["expires_in"].string, forKey: "googleExpiresIn")
                NSUserDefaults.standardUserDefaults().setObject(NSDate().dateByAddingTimeInterval(0).timeIntervalSince1970, forKey: "googleTokenBeginTime")
            }
        }
    }
    // 刷新Google的access_token
    func googleRefreshToken() {
        var parameters: [String: AnyObject] = [
            "client_id": "921894916096-i9cuji72d09ut6qo7phcsbpkqsfcmn1a.apps.googleusercontent.com",
            "client_secret": "282qMxcJSHOZ3DdJM5tVZxyk",
            //"refresh_token": NSUserDefaults.standardUserDefaults().stringForKey("googleRefreshToken")!,
            "grant_type": "refresh_token",
        ]
        
        Alamofire.request(.POST, "https://www.googleapis.com/oauth2/v3/token", parameters: parameters).responseJSON { _, _, JSONData, _ in
            if let JSONData: AnyObject = JSONData {
                let googleData  = JSON(JSONData)
                println(googleData)
                NSUserDefaults.standardUserDefaults().setObject(googleData["access_token"].string, forKey: "googleAccessToken")
                NSUserDefaults.standardUserDefaults().setObject(googleData["expires_in"].string, forKey: "googleExpiresIn")
                NSUserDefaults.standardUserDefaults().setObject(NSDate().dateByAddingTimeInterval(0).timeIntervalSince1970, forKey: "googleTokenBeginTime")
            }
        }
    }
    

}

// 直接调用Youtube Data API
extension UserBL {
    func googleRefreshToken2() -> BFTask {
        var fetchTask = BFTask(result: nil)
        
        fetchTask = fetchTask.continueWithBlock({ (task) -> AnyObject! in
            return UserDao.googleRefreshToken()
        })
        
        fetchTask = fetchTask.continueWithSuccessBlock({ (task) -> AnyObject! in
            if let response = task.result as? YTError {
                return BFTask(result: response)
            }
            
            return task
        })
        
        fetchTask = fetchTask.continueWithBlock({ (task) -> AnyObject! in
            
            return task
        })
        
        return fetchTask
    }
    
    // 订阅Youtube频道
    func Subscriptions(#channelId: String) -> BFTask {
        var fetchTask = BFTask(result: nil)
        
        fetchTask = fetchTask.continueWithBlock({ (task) -> AnyObject! in
            return UserDao.Subscriptions(channelId: channelId)
        })
        
        fetchTask = fetchTask.continueWithSuccessBlock({ (task) -> AnyObject! in
            if let response = task.result as? YTError {
                return BFTask(result: response)
            }
            
            return task
        })
        
        fetchTask = fetchTask.continueWithBlock({ (task) -> AnyObject! in
            
            return task
        })
        
        return fetchTask
    }
    
}



