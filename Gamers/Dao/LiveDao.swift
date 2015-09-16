//
//  LiveDao.swift
//  Gamers
//
//  Created by 虚空之翼 on 15/8/12.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

import Foundation
import Alamofire
import Bolts
import SwiftyJSON
import RealmSwift

struct LiveDao {}

extension LiveDao {
    /**
    获取在线直播列表
    
    :param: page  页码
    :param: limit 每页总数
    
    :returns: 直播列表
    */
    static func getLive(#page: Int, limit: Int) -> BFTask {
        var URLRequest = Router.LiveVideo(page: page, limit: limit)
        
        return fetchLive(URLRequest: URLRequest)
    }
    
    /**
    获取Twitch直播令牌

    :param: channelId 玩家频道
    :returns: 返回令牌
    */
    static func getStreamsToken(#channelId: String) -> BFTask {
        var URLRequest = TwitchRouter.StreamsToken(channelId: channelId)
        
        return fetchTwitchTokenResponse(URLRequest: URLRequest)
    }
    
    
    // MARK: - 解析
    
    //解析twitchtoken数据
    private static func fetchTwitchTokenResponse(#URLRequest: URLRequestConvertible) -> BFTask {
        var source = BFTaskCompletionSource()
        
        Alamofire.request(URLRequest).responseJSON { (_, _, JSONDictionary, error) in
            if error == nil {
                if let JSONDictionary: AnyObject = JSONDictionary {
                    let token = TwitchToken.collection(json: JSON(JSONDictionary))
                    source.setResult(token)
                }
            } else {
                source.setError(error)
            }
        }
        
        return source.task
    }
    
    //解析游戏视频列表的JSON数据
    private static func fetchLive(#URLRequest: URLRequestConvertible) -> BFTask {
        var source = BFTaskCompletionSource()
        
        Alamofire.request(URLRequest).responseJSON { (_, _, JSONDictionary, error) in
            if error == nil {
                if let JSONDictionary: AnyObject = JSONDictionary {
                    if JSON(JSONDictionary)["errCode"] == nil {
                        let lives = Live.collection(json: JSON(JSONDictionary))
                        source.setResult(lives)
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


}