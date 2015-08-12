//
//  LiveDao.swift
//  Gamers
//
//  Created by 虚空之翼 on 15/8/12.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

import Foundation
import Alamofire
import Bolts
import SwiftyJSON
import RealmSwift

struct LiveDao {}

extension LiveDao {


    static func getLive(#offset: Int?, count: Int?) -> BFTask {
        var URLRequest = Router.LiveVideo(offset: offset, count: count)
        
        return fetchLive(URLRequest: URLRequest)
    }
    
    /**
    解析游戏视频列表的JSON数据
    */
    private static func fetchLive(#URLRequest: URLRequestConvertible) -> BFTask {
        var source = BFTaskCompletionSource()
        
        Alamofire.request(URLRequest).responseJSON { (_, _, JSONDictionary, error) in
            if error == nil {
                // 保存数据到本地
                var result: [String: AnyObject]!
                var lives = [Live]()

                if let JSONDictionary: AnyObject = JSONDictionary {
                    let json = JSON(JSONDictionary)
                    lives = Live.collection(json: json)
                }
                
                //TODO: 返回该对象集合,view直接读取
                source.setResult(lives)
            } else {
                source.setError(error)
            }
        }
        
        return source.task
    }


}