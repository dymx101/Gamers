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
    
    :returns: 游戏列表
    */
    static func getAllGame(#page: Int, limit: Int) -> BFTask {
        var URLRequest = Router.AllGame(page: page, limit: limit)
        
        return fetchGame(URLRequest: URLRequest)
    }
    
    /**
    按游戏名称查询相关的游戏视频
    
    :param: name   游戏名称
    :param: offset 查询的偏移量，用于分页，默认0
    :param: count  每次返回的数量，默认20
    
    :returns: 视频列表
    */
    static func getGameVideo(#gameId: String, page: Int, limit: Int) -> BFTask {
        var URLRequest = Router.GameVideo(gameId: gameId, page: page, limit: limit)
        
        return fetchGameVideo(URLRequest: URLRequest)
    }
    
    /**
    按关键字查询相关游戏
    
    :param: gameName 游戏关键字
    :param: page     分页
    :param: limit    每页总数
    
    :returns: 游戏列表
    */
    static func getSearchGame(#gameName: String, page: Int, limit: Int) -> BFTask {
        var URLRequest = Router.SearchGame(gameName: gameName, page: page, limit: limit)
        
        return fetchGame(URLRequest: URLRequest)
    }
    
    // MARK: - 解析
    
    // 解析游戏列表的JSON数据
    private static func fetchGame(#URLRequest: URLRequestConvertible) -> BFTask {
        var source = BFTaskCompletionSource()
        
        Alamofire.request(URLRequest).responseJSON { (_, _, JSONDictionary, error) in
            if error == nil {
                if let JSONDictionary: AnyObject = JSONDictionary {
                    if JSON(JSONDictionary)["errCode"] == nil {
                        let games = Game.collection(json: JSON(JSONDictionary))
                        source.setResult(games)
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
    
    // 解析游戏视频列表的JSON数据
    private static func fetchGameVideo(#URLRequest: URLRequestConvertible) -> BFTask {
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
}