//
//  SliderBL.swift
//  Gamers
//
//  Created by 虚空之翼 on 15/7/15.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

import Foundation
import Alamofire
import Bolts
import SwiftyJSON

class SliderBL: NSObject {
    
    var delegate: SliderBLDelegate!
    
    //查询所有数据方法 成功
    func findAllNotesFinished(list : NSMutableArray) {
        
    }

    func getSliders(#channel: String) -> BFTask {
        var fetchTask = BFTask(result: nil)
        
        fetchTask = fetchTask.continueWithBlock({ (task) -> AnyObject! in
            return SliderDao.getSliders(channel: "Home")
        })
        
        fetchTask = fetchTask.continueWithSuccessBlock({ (task) -> AnyObject! in
            if let dictionary = task.result as? [String: AnyObject] {
                var items = [Slider]()

                if let sliders = dictionary["sliders"] as? [Slider] {
                    for value in sliders {
                        items.append(value)
                    }
                }
                

                return BFTask(result: items)
            }
            
            return task
        })
        
        fetchTask = fetchTask.continueWithBlock({ (task) -> AnyObject! in
            //self.loading = false
            
            return task
        })
        
        return fetchTask
        
        
    }
    

    
}