//
//  VideoBL.swift
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

class VideoBL: NSObject {
    // 单例模式
    static let sharedSingleton = VideoBL()
    
    // 视频的相关视频列表
    func getVideoRelate(videoId: String, offset: Int?, count: Int?) -> BFTask {
        var fetchTask = BFTask(result: nil)
        
        fetchTask = fetchTask.continueWithBlock({ (task) -> AnyObject! in
            return VideoDao.getVideoRelate(videoId: videoId)
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
    
    // 视频的相关评论
    func getVideoComment(videoId: String, nextPageToken: String, count: Int) -> BFTask {
        var fetchTask = BFTask(result: nil)
        
        fetchTask = fetchTask.continueWithBlock({ (task) -> AnyObject! in
            return VideoDao.getVideoComment(videoId: videoId, nextPageToken: nextPageToken, count: count)
        })
        
        fetchTask = fetchTask.continueWithSuccessBlock({ (task) -> AnyObject! in
            if let comments = task.result as? [Comment] {
                if comments.count != 0 {
                    return BFTask(result: comments)
                }
            }
            
            return task
        })
        
        fetchTask = fetchTask.continueWithBlock({ (task) -> AnyObject! in
            
            return task
        })
        
        return fetchTask
    }
    
    // 提交视频的评论
    func insertComment(#videoId: String, channelId: String, commentText: String, accessToken: String) -> BFTask {
        var fetchTask = BFTask(result: nil)
        
        fetchTask = fetchTask.continueWithBlock({ (task) -> AnyObject! in
            return VideoDao.insertComment(videoId: videoId, channelId: channelId, commentText: commentText, accessToken: accessToken)
        })
        
        fetchTask = fetchTask.continueWithSuccessBlock({ (task) -> AnyObject! in
            if let response = task.result as? Response {
                println(response)
            }
            
            return task
        })
        
        fetchTask = fetchTask.continueWithBlock({ (task) -> AnyObject! in
            println(task.error)
            return task
        })
        
        return fetchTask
    }
    
    
    // 直播视频
    func getLiveVideo(#page: Int, limit: Int) -> BFTask {
        var fetchTask = BFTask(result: nil)
        
        fetchTask = fetchTask.continueWithBlock({ (task) -> AnyObject! in
            return LiveDao.getLive(page: page, limit: limit)
        })
        
        fetchTask = fetchTask.continueWithSuccessBlock({ (task) -> AnyObject! in
            if let liveVideos = task.result as? [Video] {
                return BFTask(result: liveVideos)
            }
            
            return task
        })
        
        fetchTask = fetchTask.continueWithBlock({ (task) -> AnyObject! in
            
            return task
        })
        
        return fetchTask
    }
    

    // 搜索视频
    func getSearchVideo(#keyword: String, offset: Int, count: Int, order: String) -> BFTask {
        var fetchTask = BFTask(result: nil)
        
        fetchTask = fetchTask.continueWithBlock({ (task) -> AnyObject! in
            return VideoDao.getSearchVideo(keyword: keyword, offset: offset, count: count, order: order)
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
    
    // 保存播放视频
    func setPlayHistory(videoData: Video) {
        let realm = Realm()
        // 添加或更新最新观看的视频
        realm.write {
            videoData.playDate = NSDate()
            realm.add(videoData, update: true)
        }
        // 如果超出50，删除后面
        if realm.objects(Video).count > 50 {
            realm.write {
                let last = realm.objects(Video).sorted("playDate", ascending: false).last
                realm.delete(last!)
            }
        }
    }

}

// 直接调用Youtube Data API
extension VideoBL {
    // 获取评论
    func getYoutubeComment(#videoId: String, pageToken: String, maxResults: Int) -> BFTask {
        var fetchTask = BFTask(result: nil)
        
        fetchTask = fetchTask.continueWithBlock({ (task) -> AnyObject! in
            return VideoDao.getYoutubeComment(videoId: videoId, pageToken: pageToken, maxResults: maxResults)
        })
        
        fetchTask = fetchTask.continueWithSuccessBlock({ (task) -> AnyObject! in
            if let comments = task.result as? [YTVComment] {
                return BFTask(result: comments)
            }
            
            return task
        })
        
        fetchTask = fetchTask.continueWithBlock({ (task) -> AnyObject! in
            
            return task
        })
        
        return fetchTask
    }
    // 插入youtube视频评论
    func InsertVideoComment(#videoId: String, textOriginal: String) -> BFTask {
        var fetchTask = BFTask(result: nil)
        
        fetchTask = fetchTask.continueWithBlock({ (task) -> AnyObject! in
            return VideoDao.InsertYTVComment(videoId: videoId, textOriginal: textOriginal)
        })
        
        fetchTask = fetchTask.continueWithSuccessBlock({ (task) -> AnyObject! in
            if let comment = task.result as? YTVComment {
                return BFTask(result: comment)
            }
            
            return task
        })
        
        fetchTask = fetchTask.continueWithBlock({ (task) -> AnyObject! in
            
            return task
        })
        
        return fetchTask
    }
    
    // 直接获取Youtube频道视频
    func getChannelVideos(#channelId: String, pageToken: String, maxResults: Int, order: String, videoDefinition: String?) -> BFTask {
        var fetchTask = BFTask(result: nil)
        
        fetchTask = fetchTask.continueWithBlock({ (task) -> AnyObject! in
            return VideoDao.getChannelVideos(channelId: channelId, pageToken: pageToken, maxResults: maxResults, order: order, videoDefinition: videoDefinition)
        })
        
        fetchTask = fetchTask.continueWithSuccessBlock({ (task) -> AnyObject! in
            if let videos = task.result as? [YTVideo] {
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