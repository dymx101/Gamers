//
//  SliderDao.swift
//  Gamers
//
//  Created by 虚空之翼 on 15/7/15.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

import UIKit
import Alamofire
import Bolts
import SwiftyJSON

struct SliderDao {}

extension SliderDao {

    /**
    首页的轮播视图
    
    :returns: 首页顶部的轮播信息
    */
    static func getHomeSlider() -> BFTask {
        var URLRequest = Router.HomeSlider()
        
        return fetchSlider(URLRequest: URLRequest)
    }
    
    /**
    频道的轮播视图
    
    :param: channelId 频道ID
    :returns: 顶部的轮播信息
    */
    static func getChannelSlider(#channelId: String) -> BFTask {
        var URLRequest = Router.ChannelSlider(channelId: channelId)
        
        return fetchSlider(URLRequest: URLRequest)
    }
    
    // MARK: - 解析
    
    // 解析轮播JSON信息
    private static func fetchSlider(#URLRequest: URLRequestConvertible) -> BFTask {
        var source = BFTaskCompletionSource()
        
        Alamofire.request(URLRequest).responseJSON { (_, _, JSONDictionary, error) in
            if error == nil {
                if let JSONDictionary: AnyObject = JSONDictionary {
                    if JSON(JSONDictionary)["errCode"] == nil {
                        let sliders = Slider.collection(json: JSON(JSONDictionary))
                        source.setResult(sliders)
                    } else {
                        let response = Response.collection(json: JSON(JSONDictionary))
                        source.setResult(response)
                    }
                } else {
                   source.setResult(Response())
                }
            } else {
                source.setError(error)
            }
        }
        
        return source.task
    }
    
}
