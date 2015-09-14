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
    获取推荐的频道列表，暂时采用getRecommendChannel，获取新手频道的视频为主
    
    :param: channelType 频道类型：新手、大咖
    :returns: return 频道列表
    */
    static func getChannels(#channelType: String, offset: Int, count: Int, order: String) -> BFTask {
        var URLRequest = Router.RecommendChannel(channelType: channelType, offset: offset, count: count, order: order)
        
        return fetchChannel(URLRequest: URLRequest)
    }
    
    /**
    获取频道信息
    
    :param: channelId 频道ID
    :returns: 频道信息
    */
    static func getChannelInfo(#channelId: String) -> BFTask {
        var URLRequest = Router.ChannelInfo(channelId: channelId)
        
        return fetchChannelInfo(URLRequest: URLRequest)
    }
    
    /**
    获取频道下的视频列表
    
    :param: channelId 频道ID
    :param: offset    分页偏移量
    :param: count     每次总数
    
    :returns: 视频列表
    */
    static func getChannelVideo(#channelId: String, offset: Int, count: Int, channels: String?) -> BFTask {
        var URLRequest = Router.ChannelVideo(channelId: channelId, offset: offset, count: count, channels: channels)
        
        return fetchVideo(URLRequest: URLRequest)
    }
    
    /**
    首页推荐频道视频,一人一个
    
    :param: channelType 推荐类型
    :param: offset      分页偏移
    :param: count       分页总数
    :param: order       排序
    
    :returns: 视频列表
    */
    static func getRecommendChannel(#channelType: String, offset: Int, count: Int, order: String) -> BFTask {
        var URLRequest = Router.RecommendChannel(channelType: channelType, offset: offset, count: count, order: order)
        
        return fetchVideo(URLRequest: URLRequest)
    }
    
    /**
    搜索频道
    
    :param: keyword 搜索关键字
    :param: offset  分页偏移量
    :param: count   分页总数
    :param: order   排序
    
    :returns: 频道列表
    */
    static func getSearchChannel(#keyword: String, offset: Int, count: Int, order: String) -> BFTask {
        var URLRequest = Router.SearchChannel(keyword: keyword, offset: offset, count: count, order: order)
        
        return fetchChannel(URLRequest: URLRequest)
    }
    
    
    
    /**
    解析游戏视频列表的JSON数据
    */
    private static func fetchChannelInfo(#URLRequest: URLRequestConvertible) -> BFTask {
        var source = BFTaskCompletionSource()
        
        Alamofire.request(URLRequest).responseJSON { (_, _, JSONDictionary, error) in
            if error == nil {
                var user: Channel!
                
                if let JSONDictionary: AnyObject = JSONDictionary {
                    user = Channel.Info(json: JSON(JSONDictionary))
                }

                source.setResult(user)
                
            } else {
                source.setError(error)
            }
        }
        
        return source.task
    }
    
    /**
    解析频道列表的JSON数据
    */
    private static func fetchChannel(#URLRequest: URLRequestConvertible) -> BFTask {
        var source = BFTaskCompletionSource()
        
        Alamofire.request(URLRequest).responseJSON { (_, _, JSONDictionary, error) in
            if error == nil {
                var channels = [Channel]()
                
                if let JSONDictionary: AnyObject = JSONDictionary {
                    channels = Channel.collection(json: JSON(JSONDictionary))
                }

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
                var videos = [Video]()
                
                if let JSONDictionary: AnyObject = JSONDictionary {
                    videos = Video.collection(json: JSON(JSONDictionary))
                }
                
                source.setResult(videos)
                
            } else {
                source.setError(error)
            }
        }
        
        return source.task
    }
    
    // 首页游戏大咖
    static func getFollowers(#limit: Int, videoCount: Int) -> BFTask {
        var URLRequest = Router.Followers(limit: limit, videoCount: videoCount)
        
        return fetchFollowers(URLRequest: URLRequest)
    }
    private static func fetchFollowers(#URLRequest: URLRequestConvertible) -> BFTask {
        var source = BFTaskCompletionSource()
        
        Alamofire.request(URLRequest).responseJSON { (_, _, JSONDictionary, error) in
            if error == nil {
                var videos = [Video]()
                
                if let JSONDictionary: AnyObject = JSONDictionary {
                    videos = Video.collectionFollow(json: JSON(JSONDictionary))
                }
                
                source.setResult(videos)
                
            } else {
                source.setError(error)
            }
        }
        
        return source.task
    }
    
}
