//
//  YouTubeRouter.swift
//  Gamers
//
//  Created by 虚空之翼 on 15/8/15.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

import Foundation
import Alamofire

enum YouTubeGetRouter: URLRequestConvertible {

    static let baseURLString = "https://www.googleapis.com/youtube/v3"
    static let kGoogleAPIKey = "AIzaSyDjDe5F-JLx_abyX_sKDsjh2AXNyYLTHdo"

    case ChannelInfoById(channelId: String)     //根据ID查询频道信息
    case ChannelInfoByName(channelName: String) //根据名字查询频道信息
    
    case VideoComment(videoId: String, pageToken: String, maxResults: Int)          //视频评论
    case ChannelComment(channelId: String)      //频道的评论
    case InsertVideoComment(videoId: String, jsonData: String)
    case InsertChannelComment(channelId: String, jsonData: String)
    
    case ChannelVideos(channelId: String, pageToken: String, maxResults: Int, order: String, videoDefinition: String?)        //频道视频
    
    var URLRequest: NSURLRequest {
        let (method: Alamofire.Method, path: String, parameters: [String: AnyObject]?) = {
            switch self {
            case .ChannelInfoById(let channelId):
                var parameters: [String: AnyObject] = [
                    "key": YouTubeGetRouter.kGoogleAPIKey,
                    "part": "snippet",
                    "id": channelId,
                ]

                return (.GET, "/youtube.channels.list", parameters)
            case .ChannelInfoByName(let channelName):
                var parameters: [String: AnyObject] = [
                    "key": YouTubeGetRouter.kGoogleAPIKey,
                    "part": "snippet",
                    "forUsername": channelName,
                ]
                
                return (.GET, "/youtube.channels.list", parameters)
            case .VideoComment(let videoId, let pageToken, let maxResults):
                var parameters: [String: AnyObject] = [
                    "key": YouTubeGetRouter.kGoogleAPIKey,
                    "part": "snippet",  //snippet,replies
                    "videoId": videoId,
                    "pageToken": pageToken,
                    "maxResults": maxResults
                ]
                
                return (.GET, "/commentThreads", parameters)
            case .ChannelComment(let channelId):
                var parameters: [String: AnyObject] = [
                    "key": YouTubeGetRouter.kGoogleAPIKey,
                    "part": "snippet",  //snippet,replies
                    "allThreadsRelatedToChannelId": channelId,
                ]
                
                return (.GET, "/commentThreads", parameters)
            case .InsertVideoComment(let videoId, let jsonData):
                var parameters: [String: AnyObject] = [
                    "key": YouTubeGetRouter.kGoogleAPIKey,
                ]
                
                return (.POST, "/commentThreads", parameters)
            case .InsertChannelComment(let channelId, let jsonData):
                var parameters: [String: AnyObject] = [
                    "key": YouTubeGetRouter.kGoogleAPIKey,
                ]
                
                return (.POST, "/commentThreads", parameters)
            
            case .ChannelVideos(let channelId, let pageToken, let maxResults, let order, let videoDefinition):
                var parameters: [String: AnyObject] = [
                    "key": YouTubeGetRouter.kGoogleAPIKey,
                    "type": "video",
                    "order": order,
                    "maxResults": maxResults,
                    "channelId": channelId,
                    "part": "snippet",
                    "pageToken": pageToken
                ]
                parameters["videoDefinition"] = videoDefinition != nil ? videoDefinition : "high"

                return (.GET, "/search", parameters)
   
                
            }
        
        }()
        
        
        
        // 组合成请求路径
        let encoding = Alamofire.ParameterEncoding.URL
        let URL = NSURL(string: YouTubeGetRouter.baseURLString)!
        let mutableURLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
        mutableURLRequest.HTTPMethod = method.rawValue

        return encoding.encode(mutableURLRequest, parameters: parameters).0
        
    }
}