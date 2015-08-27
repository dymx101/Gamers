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
    static func UserLogin(#userName: String?, password: String?) -> BFTask {
        var URLRequest = Router.UserLogin(userName: userName, password: password)
        
        return fetchUser(URLRequest: URLRequest)
    }
    
    /**
    Google帐号登入，同步到后台数据库
    
    :param: userId   Google，用户ID
    :param: userName Google，用户名称
    :param: email    Google，EMail
    :param: idToken  Google，token
    
    :returns: 用户数据
    */
    static func GoogleLogin(#userId: String, userName: String?, email: String?, idToken: String?) -> BFTask {
        var URLRequest = Router.GoogleLogin(userId: userId, userName: userName, email: email, idToken: idToken)
        
        return fetchUser(URLRequest: URLRequest)
    }
    
    /**
    获取订阅频道的视频
    
    :param: userId    用户ID
    :param: userToken 用户登入令牌
    
    :returns: 视频列表
    */
    static func Subscriptions(#userId: String?, userToken: String?) -> BFTask {
        var URLRequest = Router.Subscriptions(userId: userId, userToken: userToken)
        
        return fetchVideo(URLRequest: URLRequest)
    }
    
    /**
    用户订阅频道
    
    :param: userId    用户userToken
    :param: channelId 频道ID
    
    :returns: 返回结果
    */
    static func Subscribe(#userToken: String?, channelId: String?) -> BFTask {
        var URLRequest = Router.Subscribe(userToken: userToken, channelId: channelId)
        
        return fetchResponse(URLRequest: URLRequest)
    }
    
    
    /**
    解析返回结果JSON数据结构
    */
    private static func fetchResponse(#URLRequest: URLRequestConvertible) -> BFTask {
        var source = BFTaskCompletionSource()
        
        Alamofire.request(URLRequest).responseJSON { (_, _, JSONDictionary, error) in
            if error == nil {
                var result: [String: AnyObject]!
                var response: Response!
                println("订阅返回信息：\(JSONDictionary)")
                if let JSONDictionary: AnyObject = JSONDictionary {
                    let json = JSON(JSONDictionary)
                    response = Response.collection(json: json)
                }

                source.setResult(response)
            } else {
                source.setError(error)
            }
        }
        
        return source.task
    }
    
    /**
    解析游戏视频列表的JSON数据
    */
    private static func fetchVideo(#URLRequest: URLRequestConvertible) -> BFTask {
        var source = BFTaskCompletionSource()
        
        Alamofire.request(URLRequest).responseJSON { (_, _, JSONDictionary, error) in
            if error == nil {
                
                // 保存数据到本地
                var result: [String: AnyObject]!
                var videos = [Video]()
                
                if let JSONDictionary: AnyObject = JSONDictionary {
                    let json = JSON(JSONDictionary)
                    videos = Video.collection(json: json)
                }

                source.setResult(videos)
            } else {
                source.setError(error)
            }
        }
        
        return source.task
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

                source.setResult(user)
            } else {
                source.setError(error)
            }
        }
        
        return source.task
    }

    
    
    
    
}