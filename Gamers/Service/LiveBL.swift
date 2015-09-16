//
//  LiveBL.swift
//  Gamers
//
//  Created by 虚空之翼 on 15/8/12.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

import Foundation
import Alamofire
import Bolts
import SwiftyJSON

class LiveBL: NSObject {
    // 单例模式
    static let sharedSingleton = LiveBL()
    
    // 直播列表
    func getLive(#page: Int, limit: Int) -> BFTask {
        var fetchTask = BFTask(result: nil)
        
        fetchTask = fetchTask.continueWithBlock({ (task) -> AnyObject! in
            return LiveDao.getLive(page: page, limit: limit)
        })
        
        fetchTask = fetchTask.continueWithSuccessBlock({ (task) -> AnyObject! in
            if let games = task.result as? [Live] {
                return BFTask(result: games)
            }
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
    
    // 获取twitch直播地址
    func getTwitchStreamsURL(#channelId: String) -> BFTask {
        var fetchTask = BFTask(result: nil)
        
        fetchTask = fetchTask.continueWithBlock({ (task) -> AnyObject! in
            return LiveDao.getStreamsToken(channelId: channelId)
        })
        
        fetchTask = fetchTask.continueWithSuccessBlock({ (task) -> AnyObject! in
            if let token = task.result as? TwitchToken {
                var customAllowedSet =  NSCharacterSet(charactersInString:"\",:[]{}").invertedSet
                var escapedString = token.token.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)
                var streamsURLString = "http://usher.twitch.tv/api/channel/hls/\(channelId).m3u8?player=twitchweb&token=\(escapedString!)&sig=\(token.sig)"
                
                //println(streamsURLString)
                return BFTask(result: streamsURLString)
            }
            
            return task
        })
        
        fetchTask = fetchTask.continueWithBlock({ (task) -> AnyObject! in
            
            return task
        })
        
        return fetchTask
    }
    
    
    
}
