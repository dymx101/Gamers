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
    
    static let baseURLString = "http://freedom.oyss.info"
    //static let baseURLString = "http://api.freedom.cn"
    static let kGoogleAPIKey = "AIzaSyBtW-zJkAl2Y7_2Z_AoJdmYovDWRJ1oGvE"
    
    // 
    // Alamofire请求路由，参考 github.com/Alamofire/Alamofire#api-parameter-abstraction
    //
    case MostPopular(pageToken: String?)
    case Search(query: String?, pageToken: String?)
    
    case Slider(channel: String?)                   //首页顶部轮播
    case RecommendChannel(channelType: String?)     //首页推荐频道：新手、游戏大咖
    case RecommendGame()                            //首页推荐游戏：4个热门游戏、3个新游戏
    
    case AllGame(offset: Int?, count: Int?)         //所有游戏
    case SeachGame(gameName: String?, type: String?, offset: Int?, count: Int?)  //获取游戏
    case GameVideo(name: String?, offset: Int?, count: Int?)                     //获取游戏视频
    case VideoRelate(videoId: String?)                                           //相关视频
    case VideoComment(videoId: String?, offset: Int?, count: Int?)               //视频相关评论
    case ChannelInfo(channelId: String?)            //频道信息
    
    case LiveVideo(offset: Int?, count: Int?)       //直播频道视频
    
    
    
    // MARK: URL格式转换
    var URLRequest: NSURLRequest {
        let (method: Alamofire.Method, path: String, parameters: [String: AnyObject]?) = {
            switch self {
            //首页顶部轮播
            case .Slider(let channel):
                var parameters: [String: AnyObject] = ["channel": "home"]
                
                return (.GET, "/index/sliders", parameters)
            //首页推荐频道：新手、游戏大咖
            case .RecommendChannel(let channelType):
                var parameters: [String: AnyObject] = ["apitoken": "freedom"]
                if channelType != nil { parameters["type"] = channelType }

                return (.GET, "/channel/recommend", parameters)
            //首页推荐游戏：4个热门游戏、3个新游戏
            case .RecommendGame():
                var parameters: [String: AnyObject] = ["apitoken": "freedom"]

                return (.GET, "/index/recommendgame", parameters)
            //所有游戏
            case .AllGame(let offset, let count):
                var parameters: [String: AnyObject] = ["apitoken": "freedom"]
                parameters["offset"] = offset != nil ? offset : 0
                parameters["count"] = count != nil ? count : 20
                
                return (.GET, "/game/games", parameters)
            //获取游戏
            case .SeachGame(let name, let type, let offset, let count):
                var parameters: [String: AnyObject] = ["apitoken": "freedom"]
                if name != nil { parameters["keyword"] = name }
                if type != nil { parameters["type"] = type }
                parameters["offset"] = offset != nil ? offset : 0
                parameters["count"] = count != nil ? count : 20
                
                return (.GET, "/game/seachgame", parameters)
            //获取游戏视频
            case .GameVideo(let name, let offset, let count):
                var parameters: [String: AnyObject] = ["apitoken": "freedom"]
                if name != nil { parameters["name"] = name }
                parameters["offset"] = offset != nil ? offset : 0
                parameters["count"] = count != nil ? count : 20
                
                return (.GET, "/game/gamevideo", parameters)
            //相关视频
            case .VideoRelate(let videoId):
                var parameters: [String: AnyObject] = ["apitoken": "freedom"]
                if videoId != nil { parameters["videoid"] = videoId }
                
                return (.GET, "/video/relate", parameters)
            //视频相关评论
            case .VideoComment(let videoId, let offset, let count):
                var parameters: [String: AnyObject] = ["apitoken": "freedom"]
                if videoId != nil { parameters["videoid"] = videoId }
                parameters["offset"] = offset != nil ? offset : 0
                parameters["count"] = count != nil ? count : 20
                println("222222")
                return (.GET, "/video/comments", parameters)
            //频道信息
            case .ChannelInfo(let channelId):
                var parameters: [String: AnyObject] = ["apitoken": "freedom"]
                if channelId != nil { parameters["channelid"] = channelId }
                
                return (.GET, "/channel/info", parameters)
            //直播频道
            case .LiveVideo(let offset, let count):
                var parameters: [String: AnyObject] = ["apitoken": "freedom"]
                parameters["offset"] = offset != nil ? offset : 0
                parameters["count"] = count != nil ? count : 20
                
                return (.GET, "/live/video", parameters)
                
                
         
                
            
                
                
                
                
                
                
                
                
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
