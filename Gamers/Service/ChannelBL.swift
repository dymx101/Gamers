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

    //var delegate: ChannelBLDelegate!
    
    func getChannel(channelType : String) -> BFTask {
        var fetchTask = BFTask(result: nil)
        
        fetchTask = fetchTask.continueWithBlock({ (task) -> AnyObject! in
            return ChannelDao.getChannels(channelType: channelType)
        })
        
        fetchTask = fetchTask.continueWithSuccessBlock({ (task) -> AnyObject! in
            if let channels = task.result as? [Channel] {
                return BFTask(result: channels)
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