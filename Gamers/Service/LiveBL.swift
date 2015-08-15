//
//  LiveBL.swift
//  Gamers
//
//  Created by 虚空之翼 on 15/8/12.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

import Foundation
import Alamofire
import Bolts
import SwiftyJSON

private let _SingletonSharedInstanceLiveBL = LiveBL()

class LiveBL: NSObject {
    
    // 单例模式
    class var sharedInstance : LiveBL {
        return _SingletonSharedInstanceLiveBL
    }
    
    // 首页推荐游戏
    func getLive(#offset: Int?, count: Int?) -> BFTask {
        var fetchTask = BFTask(result: nil)
        
        fetchTask = fetchTask.continueWithBlock({ (task) -> AnyObject! in
            return LiveDao.getLive(offset: offset, count: count)
        })
        
        fetchTask = fetchTask.continueWithSuccessBlock({ (task) -> AnyObject! in
            if let games = task.result as? [Live] {
                return BFTask(result: games)
            }
            
            return task
        })
        
        fetchTask = fetchTask.continueWithBlock({ (task) -> AnyObject! in
            
            return task
        })
        
        return fetchTask
    }
    
    
}

