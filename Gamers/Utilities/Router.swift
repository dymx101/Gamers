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
    static let baseURLString = "http://api.freedom.cn"

    // 
    // Alamofire请求路由，参考 github.com/Alamofire/Alamofire#api-parameter-abstraction
    //
    case Slider(channel: String?)                   //首页顶部轮播
    case RecommendGame()                            //首页推荐游戏：4个热门游戏、3个新游戏
    case RecommendChannel(channelType: String?, offset: Int?, count: Int?, order: String?)     //首页推荐频道：新手、游戏大咖

    case AllGame(offset: Int?, count: Int?)                                      //所有游戏
    case SeachGame(gameName: String?, type: String?, offset: Int?, count: Int?)  //获取游戏
    case GameVideo(name: String?, offset: Int?, count: Int?)                     //获取游戏视频
    case VideoRelate(videoId: String?)                                           //相关视频
    case VideoComment(videoId: String?, offset: Int?, count: Int?)               //视频相关评论

    case ChannelInfo(channelId: String?)                                //频道信息
    case ChannelVideo(channelId: String?, offset: Int?, count: Int?)    //频道视频
    
    case LiveVideo(offset: Int?, count: Int?)             //直播频道视频

    case UserLogin(userName: String?, password: String?)                                    //用户本地登入
    case GoogleLogin(userId: String?, userName: String?, email: String?, idToken: String?)  //Google登入
    case Subscriptions(userId: String?, userToken: String?) //所有订阅列表
    case Subscribe(userId: String?, channelId: String?)     //订阅
    

    case SearchVideo(keyword: String?, offset: Int?, count: Int?, order: String?)       //搜索视频
    case SearchChannel(keyword: String?, offset: Int?, count: Int?, order: String?)     //搜索频道
    
    // MARK: URL格式转换
    var URLRequest: NSURLRequest {
        let (method: Alamofire.Method, path: String, parameters: [String: AnyObject]?) = {
            switch self {
            //首页顶部轮播
            case .Slider(let channel):
                var parameters: [String: AnyObject] = ["channel": "home"]

                return (.GET, "/index/sliders", parameters)
            //首页推荐频道：新手、游戏大咖
            case .RecommendChannel(let channelType, let offset, let count, let order):
                var parameters: [String: AnyObject] = ["apitoken": "freedom"]
                if channelType != nil { parameters["type"] = channelType }
                parameters["offset"] = offset != nil ? offset : 0
                parameters["count"] = count != nil ? count : 20
                parameters["order"] = order != nil ? order : "date"

                return (.GET, "/index/recommendchannel", parameters)
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
            //视频相关评论列表
            case .VideoComment(let videoId, let offset, let count):
                var parameters: [String: AnyObject] = ["apitoken": "freedom"]
                if videoId != nil { parameters["videoid"] = videoId }
                parameters["offset"] = offset != nil ? offset : 0
                parameters["count"] = count != nil ? count : 20

                return (.GET, "/video/comments", parameters)
            //频道信息
            case .ChannelInfo(let channelId):
                var parameters: [String: AnyObject] = ["apitoken": "freedom"]
                if channelId != nil { parameters["channelid"] = channelId }
                
                return (.GET, "/channel/info", parameters)
            //频道视频列表
            case .ChannelVideo(let channelId, let offset, let count):
                var parameters: [String: AnyObject] = ["apitoken": "freedom"]
                if channelId != nil { parameters["channelid"] = channelId }
                parameters["offset"] = offset != nil ? offset : 0
                parameters["count"] = count != nil ? count : 20

                return (.GET, "/channel/videos", parameters)
            //直播频道列表
            case .LiveVideo(let offset, let count):
                var parameters: [String: AnyObject] = ["apitoken": "freedom"]
                parameters["offset"] = offset != nil ? offset : 0
                parameters["count"] = count != nil ? count : 20
                
                return (.GET, "/live/video", parameters)
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
            case .Subscriptions(let userId, let userToken):
                var parameters: [String: AnyObject] = ["apitoken": "freedom"]
                if userId != nil { parameters["userid"] = userId }
                if userToken != nil { parameters["usertoken"] = userToken }
                
                return (.GET, "/user/subscriptions", parameters)
            //搜索视频
            case .SearchVideo(let keyword, let offset, let count, let order):
                var parameters: [String: AnyObject] = ["apitoken": "freedom"]
                if keyword != nil { parameters["keyword"] = keyword }
                parameters["offset"] = offset != nil ? offset : 0
                parameters["count"] = count != nil ? count : 20
                parameters["order"] = order != nil ? order : "date"
                
                return (.GET, "/video/search", parameters)
            //搜索频道
            case .SearchChannel(let keyword, let offset, let count, let order):
                var parameters: [String: AnyObject] = ["apitoken": "freedom"]
                if keyword != nil { parameters["keyword"] = keyword }
                parameters["offset"] = offset != nil ? offset : 0
                parameters["count"] = count != nil ? count : 20
                parameters["order"] = order != nil ? order : "date"
                
                return (.GET, "/channel/search", parameters)
            //订阅
            case .Subscribe(let userId, let channelId):
                var parameters: [String: AnyObject] = ["apitoken": "freedom"]
                if userId != nil { parameters["userid"] = userId }
                if channelId != nil { parameters["channelid"] = channelId }
                
                return (.GET, "/user/subscribe", parameters)

                
                
                
            }
        }()
        
        // 组合成请求路径
        let encoding = Alamofire.ParameterEncoding.URL
        let URL = NSURL(string: Router.baseURLString)!
        let mutableURLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
        mutableURLRequest.HTTPMethod = method.rawValue
        
        // 用户令牌
        let userInfo = NSUserDefaults.standardUserDefaults()    //用户全局登入信息
        mutableURLRequest.addValue(String(stringInterpolationSegment: userInfo.objectForKey("userAuthToken")), forHTTPHeaderField: "Auth-token")
        
        return encoding.encode(mutableURLRequest, parameters: parameters).0
    }
}
