//
//  Channel.swift
//  Gamers
//
//  Created by 虚空之翼 on 15/7/16.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON

class Channel: Object {
    
    dynamic var id = ""             //ID
    dynamic var name = ""           //频道名称
    dynamic var details = ""        //频道介绍
    dynamic var mark = ""           //频道标识：新手、大咖等
    dynamic var image = ""          //频道图片
    
    dynamic var subscribers = ""      //订阅数
    dynamic var videos = ""          //视频总数
    dynamic var views = ""           //播放次数
    
//    override static func primaryKey() -> String? {
//        return "id"
//    }
    
    class func collection(#json: JSON) -> [Channel] {
        let realm = Realm()
        var collection = [Channel]()
        
        if let items = json.array {
            //realm.beginWrite()
            
            for item in items {
                let channelItem = Channel.modelFromJSON(item)
                //let model = Video.createOrUpdateInRealm(realm, withValue: videoItem)
                //realm.add(videoItem, update: true)
                collection.append(channelItem)
            }
            
            //realm.commitWrite()
        }
        
        return collection
    }
    
    class func Info(#json: JSON) -> Channel {
        let realm = Realm()
        
        var info: Channel = Channel.modelFromJSON(json)
        
        return info
    }
    
    
    // 把JSON数据转换为对象
    class func modelFromJSON(json: JSON) -> Channel {
        let model = Channel()

        if let itemId = json["id"].string { model.id = itemId }
        if let name = json["name"].string { model.name = name }
        if let details = json["details"].string { model.details = details }
        if let mark = json["mark"].string { model.mark = mark }
        if let image = json["image"].string { model.image = image }
        
        if let subscribers = json["subscribers"].string { model.subscribers = subscribers }
        if let videos = json["videos"].string { model.videos = videos }
        if let views = json["views"].string { model.views = views }
        
        return model
    }
    
    
    
    
}