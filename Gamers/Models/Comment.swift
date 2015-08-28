//
//  Comment.swift
//  Gamers
//
//  Created by 虚空之翼 on 15/8/3.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON

class Comment: Object {
    
    dynamic var id = ""         //ID
    dynamic var title = ""      //标题
    dynamic var content = ""    //内容
    dynamic var data = ""       //标题
    dynamic var videoId = ""    //视频ID
    
    dynamic var userId = ""     //评论人ID
    dynamic var userName = ""   //评论人名称

    
    class func collection(#json: JSON) -> [Comment] {
        var collection = [Comment]()
        
        if let items = json.array {            
            for item in items {
                collection.append(Comment.modelFromJSON(item))
            }
        }
        
        return collection
    }
    
    // 把JSON数据转换为对象
    class func modelFromJSON(json: JSON) -> Comment {
        let model = Comment()
        
        if let id = json["id"].string { model.id = id }
        if let title = json["title"].string { model.title = title }
        if let content = json["content"].string { model.content = content }
        if let data = json["data"].string { model.data = data }
        if let videoId = json["videoid"].string { model.videoId = videoId }
        
        if let userId = json["userid"].string { model.userId = userId }
        if let userName = json["username"].string { model.userName = userName }
        
        return model
    }
    
    
    
}
