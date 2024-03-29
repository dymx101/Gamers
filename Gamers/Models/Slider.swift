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
        var collection = [Slider]()
        
        if let items = json.array {
            for item in items {
                collection.append(Slider.modelFromJSON(item))
            }
        }
    
        return collection
    }
    
    // 把JSON数据转换为对象
    class func modelFromJSON(json: JSON) -> Slider {
        let model = Slider()

        if let itemId = json["id"].string { model.id = itemId }
        if let imageHq = json["image_hq"].string { model.imageHq = imageHq }
        if let imageSmall = json["image_small"].string { model.imageSmall = imageSmall }
        if let title = json["title"].string { model.title = title }
        if let youtubeVideo = json["youtube_video"].string { model.youtubeVideo = youtubeVideo }
        
        if let link = json["link"].string { model.link = link }
        if let itemDescription = json["description"].string { model.itemDescription = itemDescription }
        if let priority = json["priority"].int { model.priority = priority }
        
        return model
    }
}