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

struct UserDao { }

extension UserDao {

    /**
    用户登入
    
    :param: userName 用户名
    :param: password 密码
    
    :returns: 用户数据
    */
    static func UserLogin(#userName: String, password: String) -> BFTask {
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
    获取订阅频道
    
    :param: userId    用户ID
    :param: userToken 用户登入令牌
    
    :returns: 用户频道列表
    */
    static func Subscriptions(#userToken: String?) -> BFTask {
        var URLRequest = Router.Subscriptions(userToken: userToken)
        
        return fetchUsers(URLRequest: URLRequest)
    }
    
    /**
    用户订阅频道
    
    :param: userId    用户userToken
    :param: channelId 频道ID
    
    :returns: 返回结果
    */
    static func Subscribe(#channelId: String) -> BFTask {
        var URLRequest = Router.Subscribe(channelId: channelId)
        
        return fetchResponse(URLRequest: URLRequest)
    }
    

    // MARK: - 解析
    
    //解析返回结果JSON数据结构
    private static func fetchResponse(#URLRequest: URLRequestConvertible) -> BFTask {
        var source = BFTaskCompletionSource()
        
        Alamofire.request(URLRequest).responseJSON { (_, _, JSONDictionary, error) in
            if error == nil {
                var response: Response!
                if let JSONDictionary: AnyObject = JSONDictionary {
                    response = Response.collection(json: JSON(JSONDictionary))
                }

                source.setResult(response)
            } else {
                source.setError(error)
            }
        }
        
        return source.task
    }
    

//    //解析视频列表的JSON数据
//    private static func fetchVideo(#URLRequest: URLRequestConvertible) -> BFTask {
//        var source = BFTaskCompletionSource()
//        
//        Alamofire.request(URLRequest).responseJSON { (_, _, JSONDictionary, error) in
//            if error == nil {
//                if let JSONDictionary: AnyObject = JSONDictionary {
//                    if JSON(JSONDictionary)["errCode"] == nil {
//                        let videos = Video.collection(json: JSON(JSONDictionary))
//                        source.setResult(videos)
//                    } else {
//                        let response = Response.collection(json: JSON(JSONDictionary))
//                        source.setResult(response)
//                    }
//                } else {
//                    source.setResult(Response())
//                }
//            } else {
//                source.setError(error)
//            }
//        }
//        
//        return source.task
//    }

    // 解析用户信息的JSON数据
    private static func fetchUser(#URLRequest: URLRequestConvertible) -> BFTask {
        var source = BFTaskCompletionSource()
        
        Alamofire.request(URLRequest).responseJSON { (_, _, JSONDictionary, error) in
            if error == nil {
                if let JSONDictionary: AnyObject = JSONDictionary {
                    if JSON(JSONDictionary)["errCode"] == nil {
                        let user = User.collection(json: JSON(JSONDictionary))
                        source.setResult(user)
                    } else {
                        let response = Response.collection(json: JSON(JSONDictionary))
                        source.setResult(response)
                    }
                } else {
                    source.setResult(Response())
                }
            } else {
                source.setError(error)
            }
        }
        
        return source.task
    }

    // 解析订阅频道列表JSON数据
    private static func fetchUsers(#URLRequest: URLRequestConvertible) -> BFTask {
        var source = BFTaskCompletionSource()
        
        Alamofire.request(URLRequest).responseJSON { (_, _, JSONDictionary, error) in
            if error == nil {
                if let JSONDictionary: AnyObject = JSONDictionary {
                    if JSON(JSONDictionary)["errCode"] == nil {
                        let users = User.collections(json: JSON(JSONDictionary))
                        source.setResult(users)
                    } else {
                        let response = Response.collection(json: JSON(JSONDictionary))
                        source.setResult(response)
                    }
                } else {
                    source.setResult(Response())
                }
            } else {
                source.setError(error)
            }
        }
        
        return source.task
    }

    
    
    // MARK: - Youtube Data API
    
    // 刷新Google的令牌，延长有效期
    static func googleRefreshToken() -> BFTask {
        var source = BFTaskCompletionSource()
        
        var parameters: [String: AnyObject] = [
            "client_id": "921894916096-i9cuji72d09ut6qo7phcsbpkqsfcmn1a.apps.googleusercontent.com",
            "client_secret": "282qMxcJSHOZ3DdJM5tVZxyk",
            "refresh_token": NSUserDefaults.standardUserDefaults().stringForKey("googleRefreshToken")!,
            "grant_type": "refresh_token",
        ]
        
        Alamofire.request(.POST, "https://www.googleapis.com/oauth2/v3/token", parameters: parameters).responseJSON { (_, _, JSONDictionary, error) in
            if error == nil {
                if let JSONData: AnyObject = JSONDictionary {
                    let googleData  = JSON(JSONDictionary!)
                    NSUserDefaults.standardUserDefaults().setObject(googleData["access_token"].string, forKey: "googleAccessToken")
                    NSUserDefaults.standardUserDefaults().setObject(googleData["expires_in"].string, forKey: "googleExpiresIn")
                    NSUserDefaults.standardUserDefaults().setObject(NSDate().dateByAddingTimeInterval(0).timeIntervalSince1970, forKey: "googleTokenBeginTime")
                    
                    source.setResult(JSONDictionary)
                }
            } else {
                source.setError(error)
            }
        }
        
        return source.task
    }

    // 临时方法,订阅youtube频道
    static func Subscriptions(#channelId: String) -> BFTask {
        var source = BFTaskCompletionSource()
        
        let parameters: [String: AnyObject] = [
            "snippet": [
                "resourceId": [
                    "kind": "youtube#channel",
                    "channelId": channelId
                ]
            ]
        ]
        let headers = [ "Authorization": "OAuth " + NSUserDefaults.standardUserDefaults().stringForKey("googleAccessToken")! ]
        let URLRequest = "https://www.googleapis.com/youtube/v3/subscriptions?part=snippet"
        
        Alamofire.request(.POST, URLRequest, parameters: parameters, headers: headers, encoding: .JSON).responseJSON { (_, _, JSONDictionary, error) in
            if error == nil {
                if let JSONDictionary: AnyObject = JSONDictionary {
                    let json = JSON(JSONDictionary)
                    if json["error"]["message"] != nil {
                        let error = YTError.collection(json: JSON(JSONDictionary))
                        source.setResult(error)
                    } else {
                        let comment = YTChannel.collection(json: JSON(JSONDictionary))
                        source.setResult(comment)
                    }
                } else {
                    source.setResult(Response())
                }
            } else {
                source.setError(error)
            }
        }
        
        return source.task
    }

    
}



