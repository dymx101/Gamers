//
//  Router.swift
//  Gamers
//
//  Created by 虚空之翼 on 15/7/14.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

import Foundation
import Alamofire

enum Router: URLRequestConvertible {
//    static let baseURLString = "https://www.googleapis.com/youtube/v3"
//    static let kGoogleAPIKey = "AIzaSyBtW-zJkAl2Y7_2Z_AoJdmYovDWRJ1oGvE"
    
    static let baseURLString = "http://api.freedom.cn/index"
    static let kGoogleAPIKey = "AIzaSyBtW-zJkAl2Y7_2Z_AoJdmYovDWRJ1oGvE"
    
    // 
    // Alamofire请求路由，参考 github.com/Alamofire/Alamofire#api-parameter-abstraction
    //
    case MostPopular(pageToken: String?)
    case Search(query: String?, pageToken: String?)
    
    case Slider(channel: String?)                   //首页顶部轮播
    case Channel(channelType: String?)              //首页推荐频道：新手、游戏大咖
    case RecommendGame()                            //首页推荐游戏：4个热门游戏、3个新游戏
    case Game(gameName: String?, type: String?)
    
    // MARK: URL格式转换
    var URLRequest: NSURLRequest {
        let (method: Alamofire.Method, path: String, parameters: [String: AnyObject]?) = {
            switch self {
            case .Slider(let channel):
                var parameters: [String: AnyObject] = ["channel": "home"]
                
                return (.GET, "/sliders", parameters)
                
            case .Channel(let channelType):
                var parameters: [String: AnyObject] = ["apitoken": "freedom"]
                
                if channelType != nil {
                    parameters["type"] = channelType
                }

                return (.GET, "/channel", parameters)
            case .RecommendGame():
                var parameters: [String: AnyObject] = ["apitoken": "freedom"]
                
                return (.GET, "/recommendgame", parameters)
                
            case .Game(let name, let type):
                var parameters: [String: AnyObject] = ["apitoken": "freedom"]
                
                if name != nil {
                    parameters["name"] = name
                }
                if type != nil {
                    parameters["type"] = type
                }
                
                return (.GET, "/game", parameters)
                
            case .MostPopular(let pageToken):
                var parameters: [String: AnyObject] = [
                    "key": Router.kGoogleAPIKey,
                    "part": "snippet",
                    "chart": "mostPopular",
                    "maxResults": 20,
                ]
                
                if pageToken != nil {
                    parameters["pageToken"] = pageToken
                }
                
                let locale = NSLocale.currentLocale()
                
                if let countryCode = locale.objectForKey(NSLocaleCountryCode) as? String {
                    parameters["regionCode"] = countryCode
                }
                
                return (.GET, "/videos", parameters)
                
            case .Search(let query, let pageToken):
                var parameters: [String: AnyObject] = [
                    "key": Router.kGoogleAPIKey,
                    "part": "snippet",
                    "order": "date",
                    "maxResults": 20,
                ]
                
                if query != nil {
                    parameters["q"] = query
                }
                
                if pageToken != nil {
                    parameters["pageToken"] = pageToken
                }
                
                return (.GET, "/search", parameters)
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
