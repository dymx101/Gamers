//
//  YouTubeRouter.swift
//  Gamers
//
//  Created by 虚空之翼 on 15/8/15.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

import Foundation
import Alamofire

enum YouTubeRouter: URLRequestConvertible {

    static let baseURLString = "https://www.googleapis.com/youtube/v3"
    static let kGoogleAPIKey = "AIzaSyDjDe5F-JLx_abyX_sKDsjh2AXNyYLTHdo"

    case MostPopular()
    
    var URLRequest: NSURLRequest {
        let (method: Alamofire.Method, path: String, parameters: [String: AnyObject]?) = {
            switch self {
                //首页顶部轮播
            case .MostPopular():
                var parameters: [String: AnyObject] = [
                    "key": Router.kGoogleAPIKey,
                    "part": "snippet",
                    "order": "date",
                    "maxResults": 20,
                ]
                
                
                
                return (.GET, "/index/sliders", parameters)
                
            }
            
        }()
        
        
        
        // 组合成请求路径
        let encoding = Alamofire.ParameterEncoding.URL
        let URL = NSURL(string: Router.baseURLString)!
        let mutableURLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
        mutableURLRequest.HTTPMethod = method.rawValue
        
        return encoding.encode(mutableURLRequest, parameters: parameters).0
        
    }
}