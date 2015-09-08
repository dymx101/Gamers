//
//  YouTubeVideoComment.swift
//  Gamers
//
//  Created by 虚空之翼 on 15/9/2.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON

class YTVComment: Object {
    dynamic var id = ""
    dynamic var nextPageToken = ""
    dynamic var channelId = ""
    dynamic var videoId = ""
    dynamic var textDisplay = ""
    
    dynamic var authorDisplayName = ""
    dynamic var authorProfileImageUrl = ""
    dynamic var authorChannelUrl = ""
    dynamic var authorChannelId = ""

    dynamic var likeCount = 0
    dynamic var publishedAt = ""
    dynamic var updatedAt = ""
    
    dynamic var canReply = 0
    dynamic var isPublic = 0
    dynamic var totalReplyCount = 0
    
    
    //dynamic var replies = [YouTubeVideoCommentReplies]()
    
    
    class func collection(#json: JSON) -> [YTVComment] {
        var collection = [YTVComment]()
        
        if let items = json["items"].array {
            for item in items {
                collection.append(YTVComment.modelFromJSON(item, nextPageToken: json["nextPageToken"].string))
            }
        }
        
        return collection
    }
    
    class func collectionOne(#json: JSON) -> YTVComment {
        return YTVComment.modelFromJSON(json, nextPageToken: "")
    }
    
    // 把JSON数据转换为对象
    class func modelFromJSON(json: JSON, nextPageToken: String?) -> YTVComment {
        let model = YTVComment()
        
        if nextPageToken != nil {  model.nextPageToken = nextPageToken! }
        
        if let id = json["id"].string { model.id = id }
        if let channelId = json["snippet"]["channelId"].string { model.channelId = channelId }
        if let videoId = json["snippet"]["videoId"].string { model.videoId = videoId }
        if let textDisplay = json["snippet"]["topLevelComment"]["snippet"]["textDisplay"].string { model.textDisplay = textDisplay }
        
        if let authorDisplayName = json["snippet"]["topLevelComment"]["snippet"]["authorDisplayName"].string { model.authorDisplayName = authorDisplayName }
        if let authorProfileImageUrl = json["snippet"]["topLevelComment"]["snippet"]["authorProfileImageUrl"].string { model.authorProfileImageUrl = authorProfileImageUrl }
        if let authorChannelUrl = json["snippet"]["topLevelComment"]["snippet"]["authorChannelUrl"].string { model.authorChannelUrl = authorChannelUrl }
        if let authorChannelId = json["snippet"]["topLevelComment"]["snippet"]["authorChannelId"]["value"].string { model.authorChannelId = authorChannelId }
        
        if let likeCount = json["snippet"]["topLevelComment"]["snippet"]["likeCount"].int { model.likeCount = likeCount }
        if let publishedAt = json["snippet"]["topLevelComment"]["snippet"]["publishedAt"].string { model.publishedAt = publishedAt }
        if let updatedAt = json["snippet"]["topLevelComment"]["snippet"]["updatedAt"].string { model.updatedAt = updatedAt }
        
        if let canReply = json["snippet"]["canReply"].int { model.canReply = canReply }
        if let isPublic = json["snippet"]["isPublic"].int { model.isPublic = isPublic }
        if let totalReplyCount = json["snippet"]["totalReplyCount"].int { model.totalReplyCount = totalReplyCount }
        
        //println(model)
        //model.data = CommentData.collection(json: json["data"])
        
        return model
    }
    
    
    
    
    
    
    
    
}

class YouTubeVideoCommentReplies: Object {

}