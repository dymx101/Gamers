//
//  UserDao.swift
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

struct UserDao {}

extension UserDao {

    
    /**
    用户登入
    
    :param: userName 用户名
    :param: password 密码
    
    :returns: 用户数据
    */
    static func userLogin(#userName: String?, password: String?) -> BFTask {
        var URLRequest = Router.UserLogin(userName: userName, password: password)
        
        return fetchUser(URLRequest: URLRequest)
    }

    /**
    解析游戏视频列表的JSON数据
    */
    private static func fetchUser(#URLRequest: URLRequestConvertible) -> BFTask {
        var source = BFTaskCompletionSource()
        
        Alamofire.request(URLRequest).responseJSON { (_, _, JSONDictionary, error) in
            if error == nil {
                // 保存数据到本地
                var result: [String: AnyObject]!
                var user: User!
                
                if let JSONDictionary: AnyObject = JSONDictionary {
                    let json = JSON(JSONDictionary)
                    user = User.collection(json: json)
                }
                
                //TODO: 返回该对象集合,view直接读取
                source.setResult(user)
                
            } else {
                source.setError(error)
            }
        }
        
        return source.task
    }

    
    
    
    
}