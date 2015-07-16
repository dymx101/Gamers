//
//  ChannelBL.swift
//  Gamers
//
//  Created by 虚空之翼 on 15/7/16.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

import Foundation
import Alamofire
import Bolts
import SwiftyJSON


class ChannelBL: NSObject {

    var delegate: ChannelBLDelegate!
    
    func findChannel(channelType : String) -> BFTask {
        var fetchTask = BFTask(result: nil)
        
        fetchTask = fetchTask.continueWithBlock({ (task) -> AnyObject! in
            return ChannelDao.getSliders(channelType: channelType)
        })
        
        fetchTask = fetchTask.continueWithSuccessBlock({ (task) -> AnyObject! in
            if let dictionary = task.result as? [String: AnyObject] {
                var items = [Channel]()
                
                if let channels = dictionary["channels"] as? [Channel] {
                    for value in channels {
                        items.append(value)
                    }
                }
                println(items)
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