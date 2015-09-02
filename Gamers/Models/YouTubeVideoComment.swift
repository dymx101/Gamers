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

class YouTubeVideoComment: Object {
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
    
    dynamic var canReply = false
    dynamic var isPublic = true
    dynamic var totalReplyCount = 0
    //dynamic var replies = [YouTubeVideoCommentReplies]()
    
}

class YouTubeVideoCommentReplies: Object {

}