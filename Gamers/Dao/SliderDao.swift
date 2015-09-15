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
    // 首页的轮播视图
    static func getHomeSlider() -> BFTask {
        var URLRequest = Router.HomeSlider()
        
        return fetchVideos(URLRequest: URLRequest)
    }
    // 频道的轮播视图
    static func getChannelSlider(#channelId: String) -> BFTask {
        var URLRequest = Router.ChannelSlider(channelId: channelId)
        
        return fetchVideos(URLRequest: URLRequest)
    }
    
    // 解析
    private static func fetchVideos(#URLRequest: URLRequestConvertible) -> BFTask {
        var source = BFTaskCompletionSource()
        
        Alamofire.request(URLRequest).responseJSON { (_, _, JSONDictionary, error) in
            if error == nil {
                var sliders = [Slider]()
                
                if let JSONDictionary: AnyObject = JSONDictionary {
                    sliders = Slider.collection(json: JSON(JSONDictionary))
                }

                source.setResult(sliders)
            } else {
                source.setError(error)
            }
        }
        
        return source.task
    }
    
}
