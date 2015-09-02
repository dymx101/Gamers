//
//  CommentRouter.swift
//  Gamers
//
//  Created by 虚空之翼 on 15/9/1.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

import Foundation

import Foundation
import Alamofire

enum CommentRouter: URLRequestConvertible {
    
    static let baseURLString = "http://beta.gamers.tm:9090"
    
    //
    // Alamofire请求路由，参考 github.com/Alamofire/Alamofire#api-parameter-abstraction
    //
    case VideoComment(videoId: String?, nextPageToken: String?, count: Int?)      //视频相关评论
    case InsertComment(videoId: String, channelId: String, commentText: String, accessToken: String)
    

    // MARK: URL格式转换
    var URLRequest: NSURLRequest {
        let (method: Alamofire.Method, path: String, parameters: [String: AnyObject]?) = {
            switch self {
            //视频相关评论列表
            case .VideoComment(let videoId, let nextPageToken, let count):
                var parameters: [String: AnyObject] = ["apitoken": "freedom"]
                if videoId != nil { parameters["videoid"] = videoId }
                parameters["next_page_token"] = nextPageToken != nil ? nextPageToken : ""
                parameters["count"] = count != nil ? count : 20
                
                return (.GET, "/video/comments", parameters)
           
            case .InsertComment(let videoId, let channelId, let commentText, let accessToken):
                var parameters: [String: AnyObject] = [
                    "video_id": videoId,
                    "channel_id": channelId,
                    "comment_text": commentText,
                    "access_token": accessToken,
                ]
                
                return (.GET, "/youtube/insert_comment_thread", parameters)
                
            }
        }()
        
        // 组合成请求路径
        let encoding = Alamofire.ParameterEncoding.URL
        let URL = NSURL(string: CommentRouter.baseURLString)!
        
        let mutableURLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
        mutableURLRequest.HTTPMethod = method.rawValue
        
        return encoding.encode(mutableURLRequest, parameters: parameters).0
    }
}
