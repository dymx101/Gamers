//
//  SliderDao.swift
//  Gamers
//
//  Created by 虚空之翼 on 15/7/15.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

import UIKit
import Bolts

class SliderDao: NSObject {
    // 系统配置
    let plistPath = NSBundle.mainBundle().pathForResource("system", ofType: "plist")
    var systemList: NSArray!    //systemList = NSArray(contentsOfFile: plistPath!)
    
    
    var delegate: SliderDaoDelegate!
    
    //保存数据列表
    var listData: NSMutableArray!
    
    class var sharedInstance: SliderDao {
        struct Static {
            static var instance: SliderDao?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = SliderDao()
        }
        return Static.instance!
    }
    
    func findAll() {
        
        APIClient.getSlider(channel: "aionChannel")
        
        
        
        
    }
    
    func fetchSlider(#refresh: Bool) -> BFTask {
        var fetchTask = BFTask(result: nil)
        
        println("结果：fetchSlider")
        fetchTask = fetchTask.continueWithBlock({ (task) -> AnyObject! in
            return APIClient.getSlider(channel: "channel")
        })
        
        fetchTask = fetchTask.continueWithSuccessBlock({ (task) -> AnyObject! in
            if let dictionary = task.result as? [String: AnyObject] {

                
                println("结果：\(dictionary)")
                
                return BFTask(result: dictionary)
            }
            
            return task
        })
        
        fetchTask = fetchTask.continueWithBlock({ (task) -> AnyObject! in
            
            return task
        })
        
        return fetchTask
    }

    
}