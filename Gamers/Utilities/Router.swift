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

    //static let baseURLString = "http://freedom.oyss.info"
    //static let baseURLString = "http://api.freedom.cn"
    static let baseURLString = "http://beta.gamers.tm:3000"
    //static let baseURLString = "http://192.168.32.106:3000"
    
    // 
    // Alamofire请求路由，参考 github.com/Alamofire/Alamofire#api-parameter-abstraction
    //
    case HomeSlider()                   //首页顶部轮播
    case RecommendGame()                //首页推荐游戏：4个热门游戏、3个新游戏
    case RecommendChannel(channelType: String, offset: Int, count: Int, order: String)  //首页推荐频道：新手、游戏大咖
    case Followers(limit: Int, videoCount: Int)    //游戏大咖（暂时同步网页）

    case AllGame(page: Int, limit: Int)                                 //所有游戏
    case SearchGame(gameName: String, page: Int, limit: Int)            //获取游戏
    case GameVideo(gameId: String, page: Int, limit: Int)               //获取游戏视频
    
    case VideoRelate(videoId: String)                                   //相关视频
    case VideoComment(videoId: String, nextPageToken: String, count: Int)               //视频相关评论

    case ChannelInfo(channelId: String)                                 //频道信息
    case ChannelVideo(channelId: String, offset: Int, count: Int, channels: String?)    //频道视频
    case ChannelSlider(channelId: String)
    
    case LiveVideo(page: Int, limit: Int)                               //直播频道视频

    case UserLogin(userName: String, password: String)                                      //用户本地登入
    case GoogleLogin(userId: String?, userName: String?, email: String?, idToken: String?)  //Google登入
    case Subscriptions(userToken: String?)                              //所有订阅列表
    case Subscribe(channelId: String)                                   //订阅
    case UnSubscribe(userToken: String?, channelId: String?)            //退订

    case SearchVideo(keyword: String, offset: Int, count: Int, order: String)           //搜索视频
    case SearchChannel(keyword: String, offset: Int, count: Int, order: String)         //搜索频道
    
    case Version()   //检查更新
    
    // MARK: URL格式转换
    var URLRequest: NSURLRequest {
        let (method: Alamofire.Method, path: String, parameters: [String: AnyObject]?) = {
            switch self {
            //首页顶部轮播
            case .HomeSlider():
                var parameters: [String: AnyObject]!

                return (.GET, "/mobile_api/sliders", parameters)
            case .ChannelSlider(let channelId):
                var parameters: [String: AnyObject] = ["channelid": channelId]
                
                return (.GET, "/mobile_api/sliders", parameters)
            //首页推荐频道：新手、游戏大咖
            case .RecommendChannel(let channelType, let offset, let count, let order):
                var parameters: [String: AnyObject] = [
                    "type": channelType,
                    "page": offset,
                    "count": count,
                    "order": "date"
                ]
                
                return (.GET, "/mobile_api/video/recommendchannel", parameters)
            //首页推荐游戏：4个热门游戏、3个新游戏
            case .RecommendGame():
                var parameters: [String: AnyObject]!

                return (.GET, "/mobile_api/recommendgame", parameters)
            //所有游戏
            case .AllGame(let page, let limit):
                var parameters: [String: AnyObject] = [
                    "page": page,
                    "limit": limit,
                    "format": "list",
                    "order": "latest"
                ]

                return (.GET, "/mobile_api/games", parameters)
            //获取游戏
            case .SearchGame(let name, let offset, let count):
                var parameters: [String: AnyObject] = [
                    "term": name,
                    "page": offset,
                    "limit": count,
                    "format": "list"
                ]

                return (.GET, "/mobile_api/games", parameters)
            //获取游戏视频
            case .GameVideo(let gameId, let page, let limit):
                var parameters: [String: AnyObject] = [
                    "page": page,
                    "limit": limit,
                    "order": "popular"
                ]
                
                return (.GET, "mobile_api/games/\(gameId)", parameters)
            //相关视频
            case .VideoRelate(let videoId):
                var parameters: [String: AnyObject] = ["videoid": videoId]
                
                return (.GET, "/mobile_api/videos/related", parameters)
            //视频相关评论列表
            case .VideoComment(let videoId, let nextPageToken, let count):
                var parameters: [String: AnyObject] = [
                    "videoid": videoId,
                    "next_page_token": nextPageToken,
                    "count": count
                ]
                return (.GET, "/video/comments", parameters)
            //频道信息
            case .ChannelInfo(let channelId):
                var parameters: [String: AnyObject] = ["channelid": channelId]
                
                return (.GET, "/mobile_api/channel/info", parameters)
            //频道视频列表
            case .ChannelVideo(let channelId, let offset, let count, let channels):
                var parameters: [String: AnyObject] = [
                    "page": offset,
                    "limit": count
                ]
                if channels != nil { parameters["channels"] = channels }

                return (.GET, "/mobile_api/youtuber/\(channelId)/videos", parameters)
            //直播频道列表
            case .LiveVideo(let page, let limit):
                var parameters: [String: AnyObject] = [
                    "page": page,
                    "limit": limit
                ]
                
                return (.GET, "/mobile_api/streamers/all", parameters)
            //本地用户登入
            case .UserLogin(let userName, let password):
                var parameters: [String: AnyObject] = [
                    "username": userName,
                    "password": password
                ]

                return (.GET, "/user/login", parameters)
            //Google登入
            case .GoogleLogin(let userId, let userName, let email, let idToken):
                var parameters: [String: AnyObject] = ["apitoken": "freedom"]
                if userId != nil { parameters["userid"] = userId }
                if userName != nil { parameters["username"] = userName }
                if email != nil { parameters["email"] = email }
                if idToken != nil { parameters["idtoken"] = idToken }

                return (.GET, "/user/googlelogin", parameters)
            //订阅列表
            case .Subscriptions(let userToken):
                var parameters: [String: AnyObject]!
                //if userId != nil { parameters["userid"] = userId }
                //if userToken != nil { parameters["usertoken"] = userToken }
                
                return (.GET, "/mobile_api/mobile_follow", parameters)
            //搜索视频
            case .SearchVideo(let keyword, let offset, let count, let order):
                var parameters: [String: AnyObject] = [
                    "q": keyword,
                    "offset": offset,
                    "count": count
                ]
                
                return (.GET, "/mobile_api/videos/search", parameters)
            //搜索频道
            case .SearchChannel(let keyword, let offset, let count, let order):
                var parameters: [String: AnyObject] = [
                    "keyword": keyword,
                    "offset": offset,
                    "count": count,
                    "order": "date",
                ]
                
                return (.GET, "/channel/search", parameters)
            //订阅，奇芭的GET和POST混搭，暂停使用
            case .Subscribe(let channelId):
                var parameters: [String: AnyObject] = ["userId": channelId]
                //if userToken != nil { parameters["token"] = userToken }

                
                //return (.GET, "/mobile_api/subscribe?useId=\(channelId!)", parameters)
                return (.POST, "/mobile_api/subscribe", parameters)
            //取消订阅
            case .UnSubscribe(let userToken, let channelId):
                var parameters: [String: AnyObject] = ["apitoken": "freedom"]
                if userToken != nil { parameters["token"] = userToken }
                if channelId != nil { parameters["userId"] = channelId }
                
                //return (.GET, "/mobile_api/subscribe?useId=\(channelId!)", parameters)
                return (.POST, "/mobile_api/unsubscribe", parameters)
            //检查更新
            case Version():
                var parameters: [String: AnyObject]!
                
                return (.GET, "/mobile_api/mobile/version", parameters)
            case .Followers(let limit, let videoCount):
                var parameters: [String: AnyObject] = [
                    "limit": limit,
                    "video_count": videoCount
                ]
                
                return (.GET, "/mobile_api/followers", parameters)
                
                
            }
        }()
        
        // 组合成请求路径
        let encoding = Alamofire.ParameterEncoding.URL
        let URL = NSURL(string: Router.baseURLString)!

        let mutableURLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
        mutableURLRequest.HTTPMethod = method.rawValue
 
        // 用户令牌
        let userDefaults = NSUserDefaults.standardUserDefaults()    //用户全局登入信息
        let isLogin = userDefaults.boolForKey("isLogin")
        if isLogin {
             mutableURLRequest.addValue(String(stringInterpolationSegment: userDefaults.stringForKey("userToken")!), forHTTPHeaderField: "Auth-token")
        }

        return encoding.encode(mutableURLRequest, parameters: parameters).0
    }
}
