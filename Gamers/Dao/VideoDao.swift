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
    
    // 视频评论内容（自己API接口，接口功能不完善废弃）
    static func getVideoComment(#videoId: String, nextPageToken: String, count: Int) -> BFTask {
        var URLRequest = CommentRouter.VideoComment(videoId: videoId, nextPageToken: nextPageToken, count: count)

        return fetchComment(URLRequest: URLRequest)
    }
    // 提交视频评论（自己API接口，接口功能不完善废弃）
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
    
    // MARK: - 解析
    
    // 解析视频评论列表的JSON数据（自己API接口，接口功能不完善废弃）
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

    // 解析相关视频列表的JSON数据
    private static func fetchVideo(#URLRequest: URLRequestConvertible) -> BFTask {
        var source = BFTaskCompletionSource()
        
        Alamofire.request(URLRequest).responseJSON { (_, _, JSONDictionary, error) in
            if error == nil {
                if let JSONDictionary: AnyObject = JSONDictionary {
                    if JSON(JSONDictionary)["errCode"] == nil {
                        let videos = Video.collection(json: JSON(JSONDictionary))
                        source.setResult(videos)
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
    
    
    
    
    // MARK: - Youtube API
    
    /**
    获取视频的评论（暂时废弃，具体查看InsertYTVComment()）
    
    :param: videoId    视频ID
    :param: pageToken  评论分页令牌
    :param: maxResults 每次获取总数
    
    :returns: 评论列表
    */
    static func getYoutubeComment(#videoId: String, pageToken: String, maxResults: Int) -> BFTask {
        var URLRequest = YouTubeGetRouter.VideoComment(videoId: videoId, pageToken: pageToken, maxResults: maxResults)
        
        return fetchYoutubeComment(URLRequest: URLRequest)
    }
    
    /**
    提交评论
    
    :param: videoId      视频ID
    :param: textOriginal 评论内容
    
    :returns: 成功返回该评论信息，错误返回错误信息
    */
    static func InsertVideoComment(#videoId: String, textOriginal: String) -> BFTask {
        var URLRequest = YouTubePostRouter.InsertVideoComment(videoId: videoId, textOriginal: textOriginal)
        
        return fetchYoutubeReComment(URLRequest: URLRequest)
    }
    
    /**
    获取Youtube视频
    
    :param: channelId       频道ID
    :param: pageToken       分页令牌
    :param: maxResults      每次总数
    :param: order           排序
    :param: videoDefinition 视频定义结构
    
    :returns: 成功返回视频列表，错误返回错误信息
    */
    static func getChannelVideos(#channelId: String, pageToken: String, maxResults: Int, order: String, videoDefinition: String?) -> BFTask {
        var URLRequest = YouTubeGetRouter.ChannelVideos(channelId: channelId, pageToken: pageToken, maxResults: maxResults, order: order, videoDefinition: videoDefinition)
        
        return fetchChannelVideos(URLRequest: URLRequest)
    }
    
    // 插入评论（暂时取代InsertVideoComment，原因/youtube/v3/commentThreads?part=snippet带问号转码未解决）
    static func InsertYTVComment(#videoId: String, textOriginal: String) -> BFTask {
        var source = BFTaskCompletionSource()
        
        let parameters: [String: AnyObject] = [
            "snippet": [
                "topLevelComment": ["snippet": ["textOriginal": textOriginal]],
                "videoId": videoId
            ]
        ]
        let headers = [ "Authorization": "OAuth " + NSUserDefaults.standardUserDefaults().stringForKey("googleAccessToken")! ]
        let URLRequest = "https://www.googleapis.com/youtube/v3/commentThreads?part=snippet"
        
        Alamofire.request(.POST, URLRequest, parameters: parameters, headers: headers, encoding: .JSON).responseJSON { (_, _, JSONDictionary, error) in
            if error == nil {
                if let JSONDictionary: AnyObject = JSONDictionary {
                    if JSON(JSONDictionary)["error"]["message"] == nil {
                        let comment = YTVComment.collectionOne(json: JSON(JSONDictionary))
                        source.setResult(comment)
                    } else {
                        let errorData = YTError.collection(json: JSON(JSONDictionary))
                        source.setResult(errorData)
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
    
    // 解析Youtube视频评论信息
    private static func fetchYoutubeReComment(#URLRequest: URLRequestConvertible) -> BFTask {
        var source = BFTaskCompletionSource()
        
        Alamofire.request(URLRequest).responseJSON { (_, _, JSONDictionary, error) in
            if error == nil {
                if let JSONDictionary: AnyObject = JSONDictionary {
                    if JSON(JSONDictionary)["error"]["message"] == nil {
                        let comment = YTVComment.collectionOne(json: JSON(JSONDictionary))
                        source.setResult(comment)
                    } else {
                        let errorData = YTError.collection(json: JSON(JSONDictionary))
                        source.setResult(errorData)
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

    // 解析Youtube视频评论列表
    private static func fetchYoutubeComment(#URLRequest: URLRequestConvertible) -> BFTask {
        var source = BFTaskCompletionSource()
        
        Alamofire.request(URLRequest).responseJSON { (_, _, JSONDictionary, error) in
            if error == nil {
                if let JSONDictionary: AnyObject = JSONDictionary {
                    if JSON(JSONDictionary)["error"]["message"] == nil {
                        let comments = YTVComment.collection(json: JSON(JSONDictionary))
                        source.setResult(comments)
                    } else {
                        let errorData = YTError.collection(json: JSON(JSONDictionary))
                        source.setResult(errorData)
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
    
    // 解析频道视频
    private static func fetchChannelVideos(#URLRequest: URLRequestConvertible) -> BFTask {
        var source = BFTaskCompletionSource()
        
        Alamofire.request(URLRequest).responseJSON { (_, _, JSONDictionary, error) in
            if error == nil {
                if let JSONDictionary: AnyObject = JSONDictionary {
                    if JSON(JSONDictionary)["error"]["message"] == nil {
                        let videos = YTVideo.collection(json: JSON(JSONDictionary))
                        source.setResult(videos)
                    } else {
                        let errorData = YTError.collection(json: JSON(JSONDictionary))
                        source.setResult(errorData)
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
