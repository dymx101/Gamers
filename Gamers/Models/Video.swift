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
    
    dynamic var id = ""                 //ID
    dynamic var playListId = ""         //youtube的播放列表
    dynamic var videoId = ""            //youtube的视频ID
    dynamic var userID = ""             //用户ID
    dynamic var imageSource = ""        //视频图片
    
    dynamic var videoTitle = ""         //视频标题
    dynamic var owner = ""              //频道名称
    dynamic var ownerId = ""            //频道ID
    dynamic var views = 0               //播放次数
    dynamic var comments = 0            //评论次数
    
    dynamic var likes = 0               //分享次数（？）
    dynamic var featured = false        //是否属于特殊
    
    
    
    // MARK: - Relation
    
    //dynamic var thumbnails = RLMArray(objectClassName: Thumbnail.className())
    
    // MARK: - Initialization
    
    // Custom initializer is not supported yet (github.com/realm/realm-cocoa/issues/1101)
    // init(json: JSON) {}
    
    class func modelFromJSON(json: JSON) -> Video {
        let model = Video()
        
        // videos api
        if let itemId = json["id"].string {
            model.id = itemId
            
            // search api
        } else if let itemId = json["id"]["videoId"].string {
            model.id = itemId
        }
        
        if let title = json["snippet"]["title"].string {
            model.videoTitle = title
        }
        
        if let description = json["snippet"]["description"].string {
            //model.itemDescription = description
        }
        
        if let dateString = json["snippet"]["publishedAt"].string {
            let dateFormatter = Video.dateFormatter()
            
            if let publishedAt = dateFormatter.dateFromString(dateString) {
                //model.publishedAt = publishedAt
            }
        }
        
        let thumbnails = json["snippet"]["thumbnails"]
        
        if thumbnails.type == Type.Dictionary {
            
            for (key: String, subJson: JSON) in thumbnails {
                let thumbnail = Thumbnail.modelFromJSON(subJson, resolution: key)
                //model.thumbnails.addObject(thumbnail)
            }
        }
        
        return model
    }
    
    // MARK: - Override
    
    override class func primaryKey() -> String {
        return "itemId"
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
        let realm = Realm()
        var collection = [Video]()
        
        if let items = json["items"].array {
            realm.beginWrite()
            
            for item in items {
                let videoItem = Video.modelFromJSON(item)
                //let model = Video.createOrUpdateInRealm(realm, withValue: videoItem)
                realm.add(videoItem, update: true)
                collection.append(videoItem)
            }
            
            realm.commitWrite()
        }
        
        return collection
    }
    
}