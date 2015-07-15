//
//  Sliders.swift
//  Gamers
//
//  Created by 虚空之翼 on 15/7/14.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON

class Slider: Object {
    
    dynamic var id = ""                     //ID
    dynamic var imageHq = ""                //大图
    dynamic var imageSmall = ""             //小图
    dynamic var title = ""                  //标题
    dynamic var youtubeVideo = ""           //youtube的视频地址
    
    dynamic var link = ""                   //介绍说明地址
    dynamic var itemDescription = ""        //描述
    dynamic var priority = 0                //优先级

    class func collection(#json: JSON) -> [Slider] {
        let realm = Realm()
        var collection = [Slider]()
        //println(json)
        
        for (index, value) in json {
            let sliderItem = Slider.modelFromJSON(value)
            //let model = Video.createOrUpdateInRealm(realm, withValue: videoItem)
            //realm.add(videoItem, update: true)
            collection.append(sliderItem)
        }
        
//        if let items = json.array {
//            realm.beginWrite()
//            
//            for item in items {
//                let sliderItem = Slider.modelFromJSON(item)
//                //let model = Video.createOrUpdateInRealm(realm, withValue: videoItem)
//                //realm.add(videoItem, update: true)
//                collection.append(sliderItem)
//            }
//            
//            realm.commitWrite()
//        }
        
        return collection
    }
    
    
    class func modelFromJSON(json: JSON) -> Slider {
        let model = Slider()
        
        // videos api
        if let itemId = json["id"].string {
            model.id = itemId
            
            // search api
        } else if let itemId = json["id"]["videoId"].string {
            model.id = itemId
        }
        
        if let title = json["snippet"]["title"].string {
            model.title = title
        }
        
        if let description = json["snippet"]["description"].string {
            //model.itemDescription = description
        }
        
        if let dateString = json["snippet"]["publishedAt"].string {
            //let dateFormatter = Video.dateFormatter()
            
            //if let publishedAt = dateFormatter.dateFromString(dateString) {
                //model.publishedAt = publishedAt
            //}
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
}