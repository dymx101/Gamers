//
//  Game.swift
//  Gamers
//
//  Created by 虚空之翼 on 15/7/17.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON

class Game: Object {
    dynamic var id = ""         //ID
    dynamic var name = ""       //游戏英文名
    dynamic var nameZh = ""     //游戏中文名
    dynamic var image = ""      //封面
    dynamic var details = ""    //简介
    dynamic var type = 0        //类型：1热门、2新游戏推荐
    
    dynamic var videos = ""     //JSON视频数据（临时测试）

    class func collection(#json: JSON) -> [Game] {
        let realm = Realm()
        var collection = [Game]()
        
        if let items = json.array {
            //realm.beginWrite()
            
            for item in items {
                let sliderItem = Game.modelFromJSON(item)
                //let model = Video.createOrUpdateInRealm(realm, withValue: videoItem)
                //realm.add(videoItem, update: true)
                collection.append(sliderItem)
            }
            
            //realm.commitWrite()
        }
        
        return collection
    }
    
    // 把JSON数据转换为对象
    class func modelFromJSON(json: JSON) -> Game {
        let model = Game()
        
        if let itemId = json["id"].string {
            model.id = itemId
        }
        
        if let name = json["name"].string {
            model.name = name
        }
        
        if let details = json["details"].string {
            model.details = details
        }
        
        if let nameZh = json["nameZh"].string {
            model.nameZh = nameZh
        }
        
        if let image = json["image"].string {
            model.image = image
        }
        
        if let type = json["type"].int {
            model.type = type
        }
        
        // 测试
        if let videos = json["videos"].string {
            model.videos = videos
        }
        
        return model
    }

}