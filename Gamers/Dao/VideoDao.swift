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
    static func getVideoComment(#videoId: String, offset: Int?, count: Int?) -> BFTask {
        var URLRequest = Router.VideoComment(videoId: videoId, offset: offset, count: count)

        return fetchComment(URLRequest: URLRequest)
    }
    
    /**
    获取直播视频列表
    
    :param: offset 偏移量
    :param: count  总数
    
    :returns: 直播视频列表
    */
    static func getLiveVideo(#offset: Int?, count: Int?) -> BFTask {
        var URLRequest = Router.LiveVideo(offset: offset, count: count)
        
        return fetchVideo(URLRequest: URLRequest)
    }
    
    /**
    搜索视频
    
    :param: keyword 搜索关键字
    :param: offset  分页偏移量
    :param: count   分页总数
    :param: order   排序
    
    :returns: 视频列表
    */
    static func getSearchVideo(#keyword: String?, offset: Int?, count: Int?, order: String?) -> BFTask {
        var URLRequest = Router.SearchVideo(keyword: keyword, offset: offset, count: count, order: order)
        
        return fetchVideo(URLRequest: URLRequest)
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
                var comments = [Comment]()
                
                if let JSONDictionary: AnyObject = JSONDictionary {
                    let json = JSON(JSONDictionary)
                    comments = Comment.collection(json: json)
                }
                
                //TODO: 返回该对象集合,view直接读取
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