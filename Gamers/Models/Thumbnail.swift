//
//  Thumbnail.swift
//  Gamers
//
//  Created by 虚空之翼 on 15/7/14.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON

class Thumbnail: Object {
    dynamic var defaultSize = ThumbnailInfo()
    dynamic var mediumSize = ThumbnailInfo()
    dynamic var highSize = ThumbnailInfo()
    dynamic var standardSize = ThumbnailInfo()
    dynamic var maxresSize = ThumbnailInfo()
    
    class func collection(#json: JSON) -> Thumbnail {
        return Thumbnail.modelFromJSON(json)
    }
    
    class func modelFromJSON(json: JSON) -> Thumbnail {
        let model = Thumbnail()
        
        model.defaultSize = ThumbnailInfo.collection(json: json["default"])
        model.mediumSize = ThumbnailInfo.collection(json: json["medium"])
        model.highSize = ThumbnailInfo.collection(json: json["high"])
        model.standardSize = ThumbnailInfo.collection(json: json["standard"])
        model.maxresSize = ThumbnailInfo.collection(json: json["maxres"])
        
        return model
    }
    
}

class ThumbnailInfo: Object {
    dynamic var url = ""
    dynamic var width = 0
    dynamic var height = 0
    
    class func collection(#json: JSON) -> ThumbnailInfo {
        return ThumbnailInfo.modelFromJSON(json)
    }
    
    class func modelFromJSON(json: JSON) -> ThumbnailInfo {
        let model = ThumbnailInfo()
        
        if let url = json["url"].string { model.url = url }
        if let width = json["width"].int { model.width = width  }
        if let height = json["height"].int { model.height = height }
        
        return model
    }

}
