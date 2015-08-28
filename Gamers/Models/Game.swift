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
    dynamic var id = ""             //ID
    dynamic var gameId = ""
    dynamic var imageSource = ""    //封面
    dynamic var platforms = ""
    dynamic var tags = ""
    dynamic var type = ""           //类型：1热门、2新游戏推荐
    
    dynamic var names = [GameName]()
    dynamic var videos = [Video]()
    
    class func collection(#json: JSON) -> [Game] {
        var collection = [Game]()
        
        if let items = json.array {
            for item in items {
                collection.append(Game.modelFromJSON(item))
            }
        }

        return collection
    }
    
    // 把JSON数据转换为对象
    class func modelFromJSON(json: JSON) -> Game {
        let model = Game()
        
        if let itemId = json["id"].string { model.id = itemId }
        if let gameId = json["game_id"].string { model.gameId = gameId }
        if let imageSource = json["image_source"].string { model.imageSource = imageSource }
        if let platforms = json["platforms"].string { model.platforms = platforms }
        if let tags = json["tags"].string { model.tags = tags }
        if let type = json["type"].string { model.type = type }
        
        model.videos = Video.collection(json: json["videos"])
        model.names = GameName.collection(json: json["game_name"])
        
        //model.videos = Game.collection2(json: json["videos"])
        
        return model
    }
    
    class func collection2(#json: JSON) -> [Video] {
        var collection = [Video]()
        
        if let items = json.array {
            for item in items {
                collection.append(Video.modelFromJSON(item))
            }
        }
        
        return collection
    }

}

class GameName: Object {
    dynamic var language = ""
    dynamic var translation = ""
    
    class func modelFromJSON(json: JSON) -> GameName {
        let model = GameName()
        if let language = json["language"].string { model.language = language }
        if let translation = json["translation"].string { model.translation = translation }
        
        return model
    }
    
    class func collection(#json: JSON) -> [GameName] {
        var collection = [GameName]()
        
        if let items = json.array {
            for item in items {
                collection.append(GameName.modelFromJSON(item))
            }
        }
        
        return collection
    }

}