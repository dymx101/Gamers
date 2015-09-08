//
//  YouTubePostRouter.swift
//  Gamers
//
//  Created by 虚空之翼 on 15/9/8.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

import Foundation
import Alamofire

enum YouTubePostRouter: URLRequestConvertible {
    
    static let baseURLString = "https://www.googleapis.com/youtube/v3"
    static let kGoogleAPIKey = "AIzaSyDjDe5F-JLx_abyX_sKDsjh2AXNyYLTHdo"
    
    case InsertVideoComment(videoId: String, textOriginal: String)
    case InsertChannelComment(channelId: String, textOriginal: String)
    
    var URLRequest: NSURLRequest {
        let (method: Alamofire.Method, path: String, parameters: [String: AnyObject]?) = {
            switch self {
            case .InsertVideoComment(let videoId, let textOriginal):
                var parameters: [String: AnyObject] = [
                    "snippet": [
                        "topLevelComment": ["snippet": ["textOriginal": textOriginal]],
                        "videoId": videoId
                    ]
                ]
                
                return (.POST, "/commentThreads?part=snippet", parameters)
            case .InsertChannelComment(let channelId, let textOriginal):
                var parameters: [String: AnyObject] = [
                    "snippet": [
                        "channelId": channelId,
                        "topLevelComment": ["snippet": ["textOriginal": textOriginal]],
                    ]
                ]
                
                return (.POST, "/commentThreads?part=snippet", parameters)
                
                
                
                
                
                
            }
            
        }()
        
        
        
        // 组合成请求路径
        let encoding = Alamofire.ParameterEncoding.JSON
        let URL = NSURL(string: YouTubePostRouter.baseURLString)!
        let mutableURLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
        mutableURLRequest.HTTPMethod = method.rawValue

        return encoding.encode(mutableURLRequest, parameters: parameters).0
        
    }
}