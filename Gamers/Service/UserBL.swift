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
    func UserLogin(#userName: String?, password: String?) -> BFTask {
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
    func getSubscriptions(#userId: String?, userToken: String?) -> BFTask {
        var fetchTask = BFTask(result: nil)
        
        fetchTask = fetchTask.continueWithBlock({ (task) -> AnyObject! in
            return UserDao.Subscriptions(userId: userId, userToken: userToken)
        })
        
        fetchTask = fetchTask.continueWithSuccessBlock({ (task) -> AnyObject! in
            println(task.result)
            if let videos = task.result as? [Video] {
                
                return BFTask(result: videos)
            }
            
            return task
        })
        
        fetchTask = fetchTask.continueWithBlock({ (task) -> AnyObject! in
            
            return task
        })
        
        return fetchTask
    }
    
    
    // 用户订阅频道
    func setSubscribe(#userId: String?, channelId: String?) -> BFTask {
        var fetchTask = BFTask(result: nil)
        
        fetchTask = fetchTask.continueWithBlock({ (task) -> AnyObject! in
            return UserDao.Subscribe(userId: userId, channelId: channelId)
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
    
    
}