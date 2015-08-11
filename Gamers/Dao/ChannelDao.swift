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
    
    :param: channelId 频道ID
    :returns: 频道信息
    */
    static func getChannelInfo(#channelId: String) -> BFTask {
        var URLRequest = Router.ChannelInfo(channelId: channelId)
        return fetchChannel(URLRequest: URLRequest)
    }
    
    /**
    获取频道下的视频列表
    
    :param: channelId 频道ID
    :param: offset    分页偏移量
    :param: count     每次总数
    
    :returns: 视频列表
    */
    static func getChannelVideo(#channelId: String, offset: Int?, count: Int?) -> BFTask {
        var URLRequest = Router.ChannelVideo(channelId: channelId, offset: offset, count: count)
        return fetchVideo(URLRequest: URLRequest)
    }
    
    /**
    首页推荐频道视频
    
    :param: channelType 推荐类型
    :returns: 视频列表
    */
    static func getRecommendChannel(#channelType: String?) -> BFTask {
        var URLRequest = Router.RecommendChannel(channelType: channelType)
        return fetchVideo(URLRequest: URLRequest)
    }
    
    
    
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
    
}
