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
    
//    static func getRecommendGame() -> BFTask {
//        var URLRequest = Router.RecommendGame()
//        
//        return fetchGame(URLRequest: URLRequest)
//    }
//    
//    private static func RecommendGame(#URLRequest: URLRequestConvertible) -> BFTask {
//        var source = BFTaskCompletionSource()
//        
//        Alamofire.request(URLRequest).responseJSON { (_, _, JSONDictionary, error) in
//            if error == nil {
//                
//                // 保存数据到本地
//                var result: [String: AnyObject]!
//                var channels = [Game]()
//                
//                if let JSONDictionary: AnyObject = JSONDictionary {
//                    let json = JSON(JSONDictionary)
//                    channels = Channel.collection(json: json)
//                }
//                
//                result = ["channels": channels]
//                //TODO: 返回该对象集合,view直接读取
//                source.setResult(JSONDictionary)
//                
//            } else {
//                source.setError(error)
//            }
//        }
//        
//        return source.task
//    }
    
}