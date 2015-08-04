//
//  ChannelDao.swift
//  Gamers
//
//  Created by 虚空之翼 on 15/7/16.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

import UIKit
import Alamofire
import Bolts
import SwiftyJSON

struct ChannelDao {}

extension ChannelDao {
    /**
    获取推荐的频道列表
    
    :param: channelType 频道类型：新手、大咖
    
    :returns: return 频道列表
    */
    static func getChannels(#channelType: String?) -> BFTask {
        var URLRequest = Router.RecommendChannel(channelType: channelType)
        
        return fetchChannel(URLRequest: URLRequest)
    }
    
    /**
    获取频道信息
    */
    static func getChannelInfo(#channelId: String) -> BFTask {
        var URLRequest = Router.ChannelInfo(channelId: channelId)
        
        return fetchChannel(URLRequest: URLRequest)
        
    }
    
//    static func getLiveChannel(offset: Int?, count: Int?) -> BFTask {
//        var URLRequest = Router.LiveChannel(offset: offset, count: count)
//        
//        return fetchChannel(URLRequest: URLRequest)
//    }
    
    
    
    /**
    解析频道列表的JSON数据
    */
    private static func fetchChannel(#URLRequest: URLRequestConvertible) -> BFTask {
        var source = BFTaskCompletionSource()
        
        Alamofire.request(URLRequest).responseJSON { (_, _, JSONDictionary, error) in
            if error == nil {
                
                // 保存数据到本地
                var result: [String: AnyObject]!
                var channels = [Channel]()
                
                if let JSONDictionary: AnyObject = JSONDictionary {
                    let json = JSON(JSONDictionary)
                    channels = Channel.collection(json: json)
                }
                
                //TODO: 返回该对象集合,view直接读取
                source.setResult(channels)
                
            } else {
                source.setError(error)
            }
        }
        
        return source.task
    }
    
}
