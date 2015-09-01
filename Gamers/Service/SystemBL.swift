//
//  SystemBL.swift
//  Gamers
//
//  Created by 虚空之翼 on 15/9/1.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

import Foundation
import Alamofire
import Bolts
import SwiftyJSON

class SystemBL: NSObject {
    // 单例模式
    static let sharedSingleton = SystemBL()
    
    // 获取版本信息
    func getVersion() -> BFTask {
        var fetchTask = BFTask(result: nil)
        
        fetchTask = fetchTask.continueWithBlock({ (task) -> AnyObject! in
            return SystemDao.getVersion()
        })
        
        fetchTask = fetchTask.continueWithSuccessBlock({ (task) -> AnyObject! in
            if let versions = task.result as? [Version] {
                for version in versions {
                    if version.app == "ios" {
                        return BFTask(result: version)
                    }
                }

                //return BFTask(result: version)
            }
            
            return task
        })
        
        fetchTask = fetchTask.continueWithBlock({ (task) -> AnyObject! in
            
            return task
        })
        
        return fetchTask
    }
    
    
}

