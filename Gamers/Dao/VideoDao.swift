//
//  VideoDao.swift
//  Gamers
//
//  Created by 虚空之翼 on 15/7/24.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

import UIKit
import Alamofire
import Bolts
import SwiftyJSON
import RealmSwift

struct VideoDao {}

extension VideoDao {
    /**
    获取某个视频的相关视频
    
    :returns: 视频数据
    */
    static func getVideoRelate(#videoId: String) -> BFTask {
        var URLRequest = Router.VideoRelate(videoId: videoId)
        
        return fetchVideo(URLRequest: URLRequest)
    }
    
    
    /**
    视频的评论内容
    
    :param: videoId 视频ID
    :param: offset  偏移量
    :param: count   总数
    
    :returns: 视频列表
    */
    static func getVideoComment(#videoId: String, nextPageToken: String, count: Int) -> BFTask {
        var URLRequest = CommentRouter.VideoComment(videoId: videoId, nextPageToken: nextPageToken, count: count)

        return fetchComment(URLRequest: URLRequest)
    }
    
    static func insertComment(#videoId: String, channelId: String, commentText: String, accessToken: String) -> BFTask {
        var URLRequest = CommentRouter.InsertComment(videoId: videoId, channelId: channelId, commentText: commentText, accessToken: accessToken)
        
        return fetchComment(URLRequest: URLRequest)
    }
    
    
    /**
    搜索视频
    
    :param: keyword 搜索关键字
    :param: offset  分页偏移量
    :param: count   分页总数
    :param: order   排序
    
    :returns: 视频列表
    */
    static func getSearchVideo(#keyword: String, offset: Int, count: Int, order: String) -> BFTask {
        var URLRequest = Router.SearchVideo(keyword: keyword, offset: offset, count: count, order: order)
        
        return fetchVideo(URLRequest: URLRequest)
    }
    

    
    private static func fetchResponse(#URLRequest: URLRequestConvertible) -> BFTask {
        var source = BFTaskCompletionSource()
        
        Alamofire.request(URLRequest).responseJSON { (_, _, JSONDictionary, error) in
            if error == nil {
                var comment = Response()
                
                if let JSONDictionary: AnyObject = JSONDictionary {
                    comment = Response.collection(json: JSON(JSONDictionary))
                    println(comment)
                }
                
                source.setResult(comment)
                
            } else {
                source.setError(error)
            }
        }
        
        return source.task
    }
    
    /**
    解析视频评论列表的JSON数据
    */
    private static func fetchComment(#URLRequest: URLRequestConvertible) -> BFTask {
        var source = BFTaskCompletionSource()
        
        Alamofire.request(URLRequest).responseJSON { (_, _, JSONDictionary, error) in
            if error == nil {
                var comments = [Comment]()
                
                if let JSONDictionary: AnyObject = JSONDictionary {
                    comments = Comment.collection(json: JSON(JSONDictionary))
                }
                
                source.setResult(comments)
                
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
    
}

extension VideoDao {
    static func getYoutubeComment(#videoId: String, pageToken: String, maxResults: Int) -> BFTask {
        var URLRequest = YouTubeGetRouter.VideoComment(videoId: videoId, pageToken: pageToken, maxResults: maxResults)
        
        return fetchYoutubeComment(URLRequest: URLRequest)
    }
    
    static func InsertVideoComment(#videoId: String, textOriginal: String) -> BFTask {
        var URLRequest = YouTubePostRouter.InsertVideoComment(videoId: videoId, textOriginal: textOriginal)
        
        return fetchYoutubeReComment(URLRequest: URLRequest)
    }
    

    
    
    private static func fetchYoutubeReComment(#URLRequest: URLRequestConvertible) -> BFTask {
        var source = BFTaskCompletionSource()
        
        Alamofire.request(URLRequest).responseJSON { (_, _, JSONDictionary, error) in
            if error == nil {
                var comment = YTVComment()
                println(JSONDictionary)
                if let JSONDictionary: AnyObject = JSONDictionary {
                    comment = YTVComment.collectionOne(json: JSON(JSONDictionary))
                }
                
                source.setResult(comment)
                
            } else {
                source.setError(error)
            }
        }
        
        return source.task
    }
    
    private static func fetchYoutubeComment(#URLRequest: URLRequestConvertible) -> BFTask {
        var source = BFTaskCompletionSource()
        
        Alamofire.request(URLRequest).responseJSON { (_, _, JSONDictionary, error) in
            if error == nil {
                var comments = [YTVComment]()

                if let JSONDictionary: AnyObject = JSONDictionary {
                    comments = YTVComment.collection(json: JSON(JSONDictionary))
                }
                
                source.setResult(comments)
                
            } else {
                source.setError(error)
            }
        }
        
        return source.task
    }
    
    
    

}
