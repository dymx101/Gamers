//
//  ChannelBL.swift
//  Gamers
//
//  Created by 虚空之翼 on 15/7/16.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

import Foundation
import Alamofire
import Bolts
import SwiftyJSON

class ChannelBL: NSObject {

    /**
    获取频道列表
    
    :param: channelType 频道类型
    :returns: 频道列表
    */
    func getChannel(channelType : String) -> BFTask {
        var fetchTask = BFTask(result: nil)
        
        fetchTask = fetchTask.continueWithBlock({ (task) -> AnyObject! in
            return ChannelDao.getChannels(channelType: channelType)
        })
        
        fetchTask = fetchTask.continueWithSuccessBlock({ (task) -> AnyObject! in
            if let channels = task.result as? [Channel] {
                return BFTask(result: channels)
            }

            return task
        })
        
        fetchTask = fetchTask.continueWithBlock({ (task) -> AnyObject! in
            
            return task
        })
        
        return fetchTask
    }
    
    /**
    获取频道的视频
    
    :param: channelId 频道ID
    :param: offset    分页偏移量
    :param: count     分页总数
    
    :returns: 视频列表
    */
    func getChannelVideo(channelId: String, offset: Int?, count: Int?) -> BFTask {
        var fetchTask = BFTask(result: nil)
        
        fetchTask = fetchTask.continueWithBlock({ (task) -> AnyObject! in
            return ChannelDao.getChannelVideo(channelId: channelId, offset: offset, count: count)
        })
        
        fetchTask = fetchTask.continueWithSuccessBlock({ (task) -> AnyObject! in
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
    
    /**
    首页推荐频道视频
    
    :param: channelType 推荐类型
    :returns: 视频列表
    */
    func getRecommendChannel(channelType : String) -> BFTask {
        var fetchTask = BFTask(result: nil)
        
        fetchTask = fetchTask.continueWithBlock({ (task) -> AnyObject! in
            return ChannelDao.getRecommendChannel(channelType : channelType)
        })
        
        fetchTask = fetchTask.continueWithSuccessBlock({ (task) -> AnyObject! in
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

}