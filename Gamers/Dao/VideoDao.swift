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
    
    :returns: 评论列表
    */
    static func getVideoComment(#videoId: String, offset: Int?, count: Int?) -> BFTask {
        var URLRequest = Router.VideoComment(videoId: videoId, offset: offset, count: count)
        
        return fetchComment(URLRequest: URLRequest)
    }
    
    
    
    
    
    
    /**
    解析视频评论列表的JSON数据
    */
    private static func fetchComment(#URLRequest: URLRequestConvertible) -> BFTask {
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
                
                //TODO: 返回该对象集合,view直接读取
                source.setResult(videos)
                
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
                
                //TODO: 返回该对象集合,view直接读取
                source.setResult(videos)
                
            } else {
                source.setError(error)
            }
        }
        
        return source.task
    }
}