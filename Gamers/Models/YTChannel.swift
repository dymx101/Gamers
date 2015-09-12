//
//  YTChannel.swift
//  Gamers
//
//  Created by 虚空之翼 on 15/9/12.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON

class YTChannel: Object {
    dynamic var id = ""
    dynamic var title = ""
    dynamic var channelDescription = ""
    dynamic var publishedAt = ""
    dynamic var thumbnailDefault = ""
    dynamic var thumbnailHigh = ""
    
    class func collection(#json: JSON) -> YTChannel {
        return YTChannel.modelFromJSON(json["snippet"])
    }
    
    // 把JSON数据转换为对象
    class func modelFromJSON(json: JSON) -> YTChannel {
        let model = YTChannel()
        
        if let id = json["resourceId"]["channelId"].string { model.id = id }
        if let title = json["title"].string { model.title = title }
        if let channelDescription = json["description"].string { model.channelDescription = channelDescription }
        if let publishedAt = json["publishedAt"].string { model.publishedAt = publishedAt }
        if let thumbnailDefault = json["thumbnail"]["defalut"].string { model.thumbnailDefault = thumbnailDefault }
        if let thumbnailHigh = json["thumbnail"]["high"].string { model.thumbnailHigh = thumbnailHigh }
        
        return model
    }
    
}