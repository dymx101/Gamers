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
    case RecommendChannel(channelType: String?, offset: Int?, count: Int?, order: String?)  //首页推荐频道：新手、游戏大咖

    case AllGame(page: Int?, limit: Int?)                               //所有游戏
    case SearchGame(gameName: String?, page: Int?, limit: Int?)        //获取游戏
    case GameVideo(gameId: String, page: Int?, limit: Int?)             //获取游戏视频
    
    case VideoRelate(videoId: String?)                                  //相关视频
    case VideoComment(videoId: String?, nextPageToken: String?, count: Int?)      //视频相关评论

    case ChannelInfo(channelId: String?)                                   //频道信息
    case ChannelVideo(channelId: String?, offset: Int?, count: Int?)    //频道视频
    case ChannelSlider(channelId: String?)
    
    case LiveVideo(page: Int?, limit: Int?)                             //直播频道视频

    case UserLogin(userName: String?, password: String?)                                    //用户本地登入
    case GoogleLogin(userId: String?, userName: String?, email: String?, idToken: String?)  //Google登入
    case Subscriptions(userToken: String?)                              //所有订阅列表
    case Subscribe(userToken: String?, channelId: String?)              //订阅
    case UnSubscribe(userToken: String?, channelId: String?)            //退订

    case SearchVideo(keyword: String?, offset: Int?, count: Int?, order: String?)           //搜索视频
    case SearchChannel(keyword: String?, offset: Int?, count: Int?, order: String?)         //搜索频道
    
    case Version()   //检查更新
    
    // MARK: URL格式转换
    var URLRequest: NSURLRequest {
        let (method: Alamofire.Method, path: String, parameters: [String: AnyObject]?) = {
            switch self {
            //首页顶部轮播
            case .HomeSlider():
                var parameters: [String: AnyObject] = ["apitoken": "freedom"]

                return (.GET, "/mobile_api/sliders", parameters)
            case .ChannelSlider(let channelId):
                var parameters: [String: AnyObject] = ["apitoken": "freedom"]
                if channelId != nil { parameters["channelid"] = channelId }
                
                return (.GET, "/mobile_api/sliders", parameters)
            //首页推荐频道：新手、游戏大咖
            case .RecommendChannel(let channelType, let offset, let count, let order):
                var parameters: [String: AnyObject] = ["apitoken": "freedom"]
                if channelType != nil { parameters["type"] = channelType }
                parameters["offset"] = offset != nil ? offset : 0
                parameters["count"] = count != nil ? count : 20
                parameters["order"] = order != nil ? order : "date"

                return (.GET, "/mobile_api/video/recommendchannel", parameters)
            //首页推荐游戏：4个热门游戏、3个新游戏
            case .RecommendGame():
                var parameters: [String: AnyObject] = ["apitoken": "freedom"]

                return (.GET, "/mobile_api/recommendgame", parameters)
            //所有游戏
            case .AllGame(let page, let limit):
                var parameters: [String: AnyObject] = ["apitoken": "freedom"]
                parameters["page"] = page != nil ? page : 1
                parameters["limit"] = limit != nil ? limit : 20
                parameters["format"] = "list"
                parameters["order"] = "latest"

                return (.GET, "/mobile_api/games", parameters)
            //获取游戏
            case .SearchGame(let name, let offset, let count):
                var parameters: [String: AnyObject] = ["apitoken": "freedom"]
                if name != nil { parameters["term"] = name }
                parameters["page"] = offset != nil ? offset : 1
                parameters["limit"] = count != nil ? count : 20
                parameters["format"] = "list"

                return (.GET, "/mobile_api/games", parameters)
            //获取游戏视频
            case .GameVideo(let gameId, let page, let limit):
                var parameters: [String: AnyObject] = ["apitoken": "freedom"]
                //if gameId != nil { parameters["gameid"] = gameId }
                parameters["page"] = page != nil ? page : 1
                parameters["limit"] = limit != nil ? limit : 20
                parameters["order"] = "popular"
                
                return (.GET, "mobile_api/games/\(gameId)", parameters)
            //相关视频
            case .VideoRelate(let videoId):
                var parameters: [String: AnyObject] = ["apitoken": "freedom"]
                if videoId != nil { parameters["videoid"] = videoId }
                
                return (.GET, "/mobile_api/videos/related", parameters)
            //视频相关评论列表
            case .VideoComment(let videoId, let nextPageToken, let count):
                var parameters: [String: AnyObject] = ["apitoken": "freedom"]
                if videoId != nil { parameters["videoid"] = videoId }
                parameters["next_page_token"] = nextPageToken != nil ? nextPageToken : ""
                parameters["count"] = count != nil ? count : 20

                return (.GET, "/video/comments", parameters)
            //频道信息
            case .ChannelInfo(let channelId):
                var parameters: [String: AnyObject] = ["apitoken": "freedom"]
                if channelId != nil { parameters["channelid"] = channelId }
                
                return (.GET, "/mobile_api/channel/info", parameters)
            //频道视频列表
            case .ChannelVideo(let channelId, let offset, let count):
                var parameters: [String: AnyObject] = ["apitoken": "freedom"]
                if channelId != nil { parameters["channelid"] = channelId }
                parameters["offset"] = offset != nil ? offset : 0
                parameters["count"] = count != nil ? count : 20

                return (.GET, "/mobile_api/youtuber/\(channelId!)/videos", parameters)
            //直播频道列表
            case .LiveVideo(let page, let limit):
                var parameters: [String: AnyObject] = ["apitoken": "freedom"]
                parameters["page"] = page != nil ? page : 1
                parameters["limit"] = limit != nil ? limit : 20
                
                return (.GET, "/mobile_api/streamers/all", parameters)
            //本地用户登入
            case .UserLogin(let userName, let password):
                var parameters: [String: AnyObject] = ["apitoken": "freedom"]
                if userName != nil { parameters["username"] = userName }
                if password != nil { parameters["password"] = password }

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
                var parameters: [String: AnyObject] = ["apitoken": "freedom"]
                //if userId != nil { parameters["userid"] = userId }
                //if userToken != nil { parameters["usertoken"] = userToken }
                
                return (.GET, "/mobile_api/mobile_follow", parameters)
            //搜索视频
            case .SearchVideo(let keyword, let offset, let count, let order):
                var parameters: [String: AnyObject] = ["apitoken": "freedom"]
                if keyword != nil { parameters["q"] = keyword }
                parameters["offset"] = offset != nil ? offset : 0
                parameters["count"] = count != nil ? count : 20
                //parameters["order"] = order != nil ? order : "date"
                
                return (.GET, "/mobile_api/videos/search", parameters)
            //搜索频道
            case .SearchChannel(let keyword, let offset, let count, let order):
                var parameters: [String: AnyObject] = ["apitoken": "freedom"]
                if keyword != nil { parameters["keyword"] = keyword }
                parameters["offset"] = offset != nil ? offset : 0
                parameters["count"] = count != nil ? count : 20
                parameters["order"] = order != nil ? order : "date"
                
                return (.GET, "/channel/search", parameters)
            //订阅，奇芭的GET和POST混搭，暂停使用
            case .Subscribe(let userToken, let channelId):
                var parameters: [String: AnyObject] = ["apitoken": "freedom"]
                if userToken != nil { parameters["token"] = userToken }
                if channelId != nil { parameters["userId"] = channelId }
                
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
                var parameters: [String: AnyObject] = ["apitoken": "freedom"]
                
                return (.GET, "/mobile_api/mobile/version", parameters)
                
                
                
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
