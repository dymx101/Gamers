//
//  TwitchRouter.swift
//  Gamers
//
//  Created by 虚空之翼 on 15/9/4.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

import Foundation
import Alamofire

enum TwitchRouter: URLRequestConvertible {
    
    static let baseURLString = "https://api.twitch.tv/api"
    //static let kGoogleAPIKey = "AIzaSyDjDe5F-JLx_abyX_sKDsjh2AXNyYLTHdo"
    
    case StreamsToken(channelId: String)
    
    var URLRequest: NSURLRequest {
        let (method: Alamofire.Method, path: String, parameters: [String: AnyObject]?) = {
            switch self {
            //获取播放令牌
            case .StreamsToken(let channelId):
                var parameters: [String: AnyObject]!

                return (.GET, "/channels/\(channelId)/access_token", parameters)
                
            }
            
        }()
        
        
        
        // 组合成请求路径
        let encoding = Alamofire.ParameterEncoding.URL
        let URL = NSURL(string: TwitchRouter.baseURLString)!
        let mutableURLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
        mutableURLRequest.HTTPMethod = method.rawValue
        
        return encoding.encode(mutableURLRequest, parameters: parameters).0
        
    }
}