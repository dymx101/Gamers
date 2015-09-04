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

    static func getLive(#page: Int, limit: Int) -> BFTask {
        var URLRequest = Router.LiveVideo(page: page, limit: limit)
        
        return fetchLive(URLRequest: URLRequest)
    }
    
    static func getStreamsToken(#channelId: String) -> BFTask {
        var URLRequest = TwitchRouter.StreamsToken(channelId: channelId)
        
        return fetchTwitchTokenResponse(URLRequest: URLRequest)
    }
    
    /**
    解析twitchtoken数据
    */
    private static func fetchTwitchTokenResponse(#URLRequest: URLRequestConvertible) -> BFTask {
        var source = BFTaskCompletionSource()
        
        Alamofire.request(URLRequest).responseJSON { (_, _, JSONDictionary, error) in
            if error == nil {
                var token = TwitchToken()

                if let JSONDictionary: AnyObject = JSONDictionary {
                    token = TwitchToken.collection(json: JSON(JSONDictionary))

                }
                
                source.setResult(token)
            } else {
                source.setError(error)
            }
        }
        
        return source.task
    }
    
    /**
    解析游戏视频列表的JSON数据
    */
    private static func fetchLive(#URLRequest: URLRequestConvertible) -> BFTask {
        var source = BFTaskCompletionSource()
        
        Alamofire.request(URLRequest).responseJSON { (_, _, JSONDictionary, error) in
            if error == nil {
                var lives = [Live]()

                if let JSONDictionary: AnyObject = JSONDictionary {
                    lives = Live.collection(json: JSON(JSONDictionary))
                }

                source.setResult(lives)
            } else {
                source.setError(error)
            }
        }
        
        return source.task
    }


}