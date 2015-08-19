//
//  GameBL.swift
//  Gamers
//
//  Created by 虚空之翼 on 15/7/17.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

import Foundation
import Alamofire
import Bolts
import SwiftyJSON

private let _SingletonSharedInstanceGameBL = GameBL()

class GameBL: NSObject {
    
    // 单例模式
    class var sharedInstance : GameBL {
        return _SingletonSharedInstanceGameBL
    }
    
    // 首页推荐游戏
    func getRecommendGame() -> BFTask {
        var fetchTask = BFTask(result: nil)
        
        fetchTask = fetchTask.continueWithBlock({ (task) -> AnyObject! in
            return GameDao.getRecommendGame()
        })
        
        fetchTask = fetchTask.continueWithSuccessBlock({ (task) -> AnyObject! in
            if let games = task.result as? [Game] {
                return BFTask(result: games)
            }

            return task
        })
        
        fetchTask = fetchTask.continueWithBlock({ (task) -> AnyObject! in
            
            return task
        })
        
        return fetchTask
    }
    
    // 所有游戏列表
    func getAllGame(#offset: Int?, count: Int?) -> BFTask {
        var fetchTask = BFTask(result: nil)
        
        fetchTask = fetchTask.continueWithBlock({ (task) -> AnyObject! in
            return GameDao.getAllGame(offset: offset, count: count)
        })
        
        fetchTask = fetchTask.continueWithSuccessBlock({ (task) -> AnyObject! in
            if let games = task.result as? [Game] {
                return BFTask(result: games)
            }
            
            return task
        })
        
        fetchTask = fetchTask.continueWithBlock({ (task) -> AnyObject! in
            
            return task
        })
        
        return fetchTask
    }
    
    // 游戏的视频列表
    func getGameVideo(name: String, offset: Int?, count: Int?) -> BFTask {
        var fetchTask = BFTask(result: nil)
        
        fetchTask = fetchTask.continueWithBlock({ (task) -> AnyObject! in
            return GameDao.getGameVideo(name: name, offset: offset, count: count)
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