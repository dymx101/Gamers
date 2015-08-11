//
//  GameDao.swift
//  Gamers
//
//  Created by 虚空之翼 on 15/7/17.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

import UIKit
import Alamofire
import Bolts
import SwiftyJSON
import RealmSwift

struct GameDao {}

extension GameDao {
    /**
    获取推荐游戏，用于首页的4个热门和3个新手
    
    :returns: 游戏及相关视频列表
    */
    static func getRecommendGame() -> BFTask {
        var URLRequest = Router.RecommendGame()
        
        return fetchGame(URLRequest: URLRequest)
    }
    
    /**
    获取所有游戏列表，用于游戏栏目
    // TODO: 如果数量太多，则分页上拉刷新更多
    
    :returns: 游戏列表
    */
    static func getAllGame(#offset: Int?, count: Int?) -> BFTask {
        var URLRequest = Router.AllGame(offset: offset, count: count)
        
        return fetchGame(URLRequest: URLRequest)
    }
    
    /**
    按游戏名称查询相关的游戏视频
    
    :param: name   游戏名称
    :param: offset 查询的偏移量，用于分页，默认0
    :param: count  每次返回的数量，默认20
    
    :returns: 视频列表
    */
    static func getGameVideo(#name: String, offset: Int?, count: Int?) -> BFTask {
        var URLRequest = Router.GameVideo(name: name, offset: offset, count: count)
        
        return fetchGameVideo(URLRequest: URLRequest)
    }
    
    
    /**
    解析游戏列表的JSON数据
    */
    private static func fetchGame(#URLRequest: URLRequestConvertible) -> BFTask {
        var source = BFTaskCompletionSource()
        
        Alamofire.request(URLRequest).responseJSON { (_, _, JSONDictionary, error) in
            if error == nil {
                
                // 保存数据到本地
                var result: [String: AnyObject]!
                var games = [Game]()
                
                if let JSONDictionary: AnyObject = JSONDictionary {
                    let json = JSON(JSONDictionary)
                    games = Game.collection(json: json)
                }
                
                //TODO: 返回该对象集合,view直接读取
                source.setResult(games)
                
            } else {
                source.setError(error)
            }
        }
        
        return source.task
    }
    
    /**
    解析游戏视频列表的JSON数据
    */
    private static func fetchGameVideo(#URLRequest: URLRequestConvertible) -> BFTask {
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