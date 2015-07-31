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
        
        return fetchRecommendGame(URLRequest: URLRequest)
    }
    
    /**
    获取所有游戏列表，用于游戏栏目
    // TODO: 如果数量太多，则分页上拉刷新更多
    
    :returns: 游戏列表
    */
    static func getAllGame() -> BFTask {
        var URLRequest = Router.AllGame()
        
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
    解析推荐游戏功能的JSON数据
    */
    private static func fetchRecommendGame(#URLRequest: URLRequestConvertible) -> BFTask {
        var source = BFTaskCompletionSource()
        
        Alamofire.request(URLRequest).responseJSON { (_, _, JSONDictionary, error) in
            if error == nil {
                
                // 保存数据到本地
                var result: [String: AnyObject]!
                var games = [Game]()
                var videos = [Video]()
                
                let realm = Realm()
                
                if let JSONDictionary: AnyObject = JSONDictionary {
                    for (_, gameValue) in JSON(JSONDictionary) {
                        var game = Game()
                        // TODO: JSON直接转换为Game，Video对象
                        game.id = gameValue["id"].string!
                        game.name = gameValue["name"].string!
                        game.nameZh = gameValue["nameZh"].string!
                        game.details = gameValue["details"].string!
                        game.type = gameValue["type"].int!
                        //game.videos = value["videos"].string!
                        // 暂时作为字符串，后期存储到数据库，把id字段提取出来
                        for (_, videoValue) in gameValue["videos"] {
                            game.videos += videoValue["id"].string! + ","

                            var video = Video()
                            video.id = videoValue["id"].string!
                            video.videoTitle = videoValue["video_title"].string!
                            video.playListId = videoValue["playlist_id"].string!
                            video.videoId = videoValue["video_id"].string!
                            video.userID = videoValue["user_id"].string!
                            video.imageSource = videoValue["image_source"].string!
                            video.owner = videoValue["owner"].string!
                            video.ownerId = videoValue["owner_id"].string!
                            video.views = videoValue["views"].int!
                            video.comments = videoValue["comments"].int!
                            video.likes = videoValue["likes"].int!
                            video.featured = videoValue["featured"].bool!
                            
                            realm.beginWrite()
                            realm.add(video, update: true)
                            realm.commitWrite()
                            videos.append(video)
                        }
                        
                        games.append(game)
                    }
                    // Query using a predicate string
                    //var tanDogs = realm.objects(Video).filter("id in %@", ["UUgPX17M3qr7YbzannFV675NblwvWQ77Lg","UUG9KGv7zGTMi50VbcnNtvOhYaPubmZZkS"])
                    //println(tanDogs)
                    //println(games)
                }

                // TODO: 返回该对象集合,view直接读取
                //result = ["games": games, "videos": videos]
                source.setResult(games)
                
            } else {
                source.setError(error)
            }
        }
        
        return source.task
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