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
    static func getSliders(#channel: String?) -> BFTask {
        var URLRequest = Router.Slider(channel: channel)
        
        return fetchVideos(URLRequest: URLRequest)
    }
    
    private static func fetchVideos(#URLRequest: URLRequestConvertible) -> BFTask {
        var source = BFTaskCompletionSource()
        
        Alamofire.request(URLRequest).responseJSON { (_, _, JSONDictionary, error) in
            if error == nil {
                
                // 保存数据到本地
                var result: [String: AnyObject]!
                var sliders = [Slider]()
                
                if let JSONDictionary: AnyObject = JSONDictionary {
                    let json = JSON(JSONDictionary)
                    sliders = Slider.collection(json: json)
                }

                //TODO: 返回该对象集合,view直接读取
                source.setResult(sliders)

            } else {
                source.setError(error)
            }
        }
        
        return source.task
    }
    
}
