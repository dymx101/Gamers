//
//  VideoItem.swift
//  Gamers
//
//  Created by 虚空之翼 on 15/7/14.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON

class Video: Object {
    static let sharedSingleton = Video()
    
    dynamic var id = ""                 //ID
    dynamic var playListId = ""         //youtube的播放列表
    dynamic var videoId = ""            //youtube的视频ID
    //dynamic var userId = ""             //用户ID
    dynamic var imageSource = ""        //视频图片
    
    dynamic var videoTitle = ""         //视频标题
    dynamic var owner = ""              //频道名称
    dynamic var ownerId = ""            //频道ID
    dynamic var views = 0               //播放次数
    dynamic var comments = 0            //评论次数
    
    dynamic var likes = 0               //分享次数（？）
    dynamic var featured = false        //是否属于特殊
    dynamic var playDate = NSDate()
    dynamic var publishedAt = ""        //发布时间
    
    
    class func modelFromJSON(json: JSON) -> Video {
        let model = Video()
        
        if let itemId = json["id"].string { model.id = itemId }
        if let playListId = json["playlist_id"].string { model.playListId = playListId }
        if let videoId = json["video_id"].string { model.videoId = videoId }
        //if let userId = json["user_id"].string { model.userId = userId }
        if let imageSource = json["image_source"].string { model.imageSource = imageSource }
        
        if let videoTitle = json["video_title"].string { model.videoTitle = videoTitle }
        if let owner = json["owner"].string { model.owner = owner }
        if let ownerId = json["owner_id"].string { model.ownerId = ownerId }
        if let views = json["views"].int { model.views = views }
        if let comments = json["comments"].int { model.comments = comments }
        
        if let likes = json["likes"].int { model.likes = likes }
        if let featured = json["featured"].bool { model.featured = featured }
        if let publishedAt = json["published_at"].string { model.publishedAt = publishedAt }
        
        return model
    }
    
    // MARK: - Override
    override class func primaryKey() -> String {
        return "id"
    }
    
    // MARK: - Private
    private class func dateFormatter() -> NSDateFormatter {
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        dateFormatter.timeZone = NSTimeZone(name: "GMT")
        
        // parse.com/docs/rest#objects-classes
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        
        return dateFormatter
    }
    
    // MARK: - ResponseCollectionSerializable
    class func collection(#json: JSON) -> [Video] {
        var collection = [Video]()
        if let items = json.array {
            for item in items {
                collection.append(Video.modelFromJSON(item))
            }
        }
        
        return collection
    }
    
}