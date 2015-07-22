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

struct GameDao {}

extension GameDao {
    
    static func getRecommendGame() -> BFTask {
        var URLRequest = Router.RecommendGame()
        
        return fetchGame(URLRequest: URLRequest)
    }
    
    static func getAllGame() -> BFTask {
        var URLRequest = Router.AllGame()
        
        return fetchGame(URLRequest: URLRequest)
    }
    
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
    
}