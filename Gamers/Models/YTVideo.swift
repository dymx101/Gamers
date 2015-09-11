//
//  YTVideo.swift
//  Gamers
//
//  Created by 虚空之翼 on 15/9/11.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON

class YTVideo: Object {
    dynamic var id = ""
    dynamic var nextPageToken = ""
    dynamic var channelId = ""
    dynamic var channelTitle = ""
    dynamic var liveBroadcastContent = ""
    
    dynamic var title = ""
    dynamic var videoDescription = ""
    dynamic var thumbnailDefault = ""
    dynamic var thumbnailMedium = ""
    dynamic var thumbnailHigh = ""
    
    dynamic var publishedAt = ""

    
    class func collection(#json: JSON) -> [YTVideo] {
        var collection = [YTVideo]()
        
        if let items = json["items"].array {
            for item in items {
                collection.append(YTVideo.modelFromJSON(item, nextPageToken: json["nextPageToken"].string))
            }
        }

        return collection
    }
    
    class func collectionOne(#json: JSON) -> YTVComment {
        return YTVComment.modelFromJSON(json, nextPageToken: "")
    }
    
    // 把JSON数据转换为对象
    class func modelFromJSON(json: JSON, nextPageToken: String?) -> YTVideo {
        let model = YTVideo()
        
        if nextPageToken != nil {  model.nextPageToken = nextPageToken! }
        
        if let id = json["id"]["videoId"].string { model.id = id }
        if let channelId = json["snippet"]["channelId"].string { model.channelId = channelId }
        if let channelTitle = json["snippet"]["channelTitle"].string { model.channelTitle = channelTitle }
        if let liveBroadcastContent = json["snippet"]["liveBroadcastContent"].string { model.liveBroadcastContent = liveBroadcastContent }
        
        if let title = json["snippet"]["title"].string { model.title = title }
        if let videoDescription = json["snippet"]["description"].string { model.videoDescription = videoDescription }
        if let thumbnailDefault = json["snippet"]["thumbnails"]["default"]["url"].string { model.thumbnailDefault = thumbnailDefault }
        if let thumbnailMedium = json["snippet"]["thumbnails"]["medium"]["url"].string { model.thumbnailMedium = thumbnailMedium }
        if let thumbnailHigh = json["snippet"]["thumbnails"]["high"]["url"].string { model.thumbnailDefault = thumbnailHigh }
        
        if let publishedAt = json["snippet"]["publishedAt"].string { model.publishedAt = publishedAt }

        
        return model
    }

}