//
//  File.swift
//  Gamers
//
//  Created by 虚空之翼 on 15/8/12.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON

class Live {
    dynamic var user = Streamer()    //实况主
    dynamic var type = ""           //直播类型
    dynamic var stream = Stream()     //视频数据流
    
    class func collection(#json: JSON) -> [Live] {
        let realm = Realm()
        var collection = [Live]()
        
        if let items = json.array {
            //realm.beginWrite()
            
            for item in items {
                let gameItem = Live.modelFromJSON(item)
                collection.append(gameItem)
            }
            
            //realm.commitWrite()
        }
        return collection
    }
    
    // 把JSON数据转换为对象
    class func modelFromJSON(json: JSON) -> Live {
        let model = Live()
        
        if let type = json["type"].string { model.type = type }
        model.stream = Stream.collection(json: json["stream"])
        model.user = Streamer.collection(json: json["user"])
        
        return model
    }
    
}
/// 实况主
class Streamer: Object {
    dynamic var userId = ""
    dynamic var userName = ""
    dynamic var firstName = ""
    dynamic var lastName = ""
    dynamic var email = ""
    dynamic var communityId = 0
    dynamic var avatar = ""
    dynamic var streamBanner = ""
    dynamic var about = ""
    
    class func collection(#json: JSON) -> Streamer {
        return Streamer.modelFromJSON(json)
    }
    
    // 把JSON数据转换为对象
    class func modelFromJSON(json: JSON) -> Streamer {
        let model = Streamer()
        
        if let userId = json["user_id"].string { model.userId = userId }
        if let userName = json["username"].string { model.userName = userName }
        if let firstName = json["first_name"].string { model.firstName = firstName }
        if let lastName = json["last_name"].string { model.lastName = lastName }
        if let email = json["email"].string { model.email = email }
        
        if let communityId = json["community_id"].int { model.communityId = communityId }
        if let avatar = json["avatar"].string { model.avatar = avatar }
        if let streamBanner = json["stream_banner"].string { model.streamBanner = streamBanner }
        if let about = json["about"].string { model.about = about }

        return model
    }

}
/// 数据流缩略图
class StreamThunbnail: Object {
    dynamic var medium = ""
    dynamic var large = ""
    
    class func collection(#json: JSON) -> StreamThunbnail {
        return StreamThunbnail.modelFromJSON(json)
    }
    
    // 把JSON数据转换为对象
    class func modelFromJSON(json: JSON) -> StreamThunbnail {
        let model = StreamThunbnail()

        if let medium = json["medium"].string { model.medium = medium }
        if let large = json["large"].string { model.large = large }
        
        return model
    }
}

/// 数据流
class Stream: Object {
    dynamic var id = ""
    dynamic var streamUrl = ""
    dynamic var thumbnail = StreamThunbnail()
    dynamic var date = ""
    dynamic var steamDescription = ""
    
    dynamic var title = ""
    dynamic var views = 0
    dynamic var chatUrl = ""
    dynamic var gameName = ""
    dynamic var channelViews = 0
    
    dynamic var channelFollowers = 0
    dynamic var about = ""
    
    
    class func collection(#json: JSON) -> Stream {
        return Stream.modelFromJSON(json)
    }
    
    // 把JSON数据转换为对象
    class func modelFromJSON(json: JSON) -> Stream {
        let model = Stream()
        
        if let id = json["id"].string { model.id = id }
        if let streamUrl = json["stream_url"].string { model.streamUrl = streamUrl }
        
        model.thumbnail = StreamThunbnail.collection(json: json["thumbnail"])
        
        if let date = json["date"].string { model.date = date }
        if let steamDescription = json["description"].string { model.steamDescription = steamDescription }
        
        if let title = json["title"].string { model.title = title }
        if let views = json["views"].int { model.views = views }
        if let chatUrl = json["chat_url"].string { model.chatUrl = chatUrl }
        if let gameName = json["game_name"].string { model.gameName = gameName }
        if let channelViews = json["channel_views"].int { model.channelViews = channelViews }
        
        if let channelFollowers = json["channel_followers"].int { model.channelFollowers = channelFollowers }
        if let about = json["about"].string { model.about = about }
        
        return model
    }
}