//
//  APIClient.swift
//  Gamers
//
//  Created by 虚空之翼 on 15/7/14.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

import Alamofire
import Bolts
import Realm
import SwiftyJSON

struct APIClient {}


extension APIClient {
    static func fetchMostPopularVideos(#pageToken: String?) -> BFTask {
        var URLRequest = Router.MostPopular(pageToken: pageToken)
        
        return fetchVideos(URLRequest: URLRequest)
    }
    
    static func searchVideos(#query: String?, pageToken: String?) -> BFTask {
        var URLRequest = Router.Search(query: query, pageToken: pageToken)
        
        return fetchVideos(URLRequest: URLRequest)
    }
    
    static func getSlider(#channel: String?) -> BFTask {
        var URLRequest = Router.Slider(channel: channel)
        
        return fetchVideos(URLRequest: URLRequest)
    }
    
    private static func fetchVideos(#URLRequest: URLRequestConvertible) -> BFTask {
        var source = BFTaskCompletionSource()
        
        Alamofire.request(URLRequest).responseJSON { (_, _, JSONDictionary, error) in
            if error == nil {
                //println(JSONDictionary)
                // Save in background
                var result: [String: AnyObject]!
                var sliders = [Slider]()
                
                
                //if let JSONDictionary: AnyObject = JSONDictionary {
                    let json = JSON(JSONDictionary!)
                //println(json)
                    sliders = Slider.collection(json: json)
                    
                    
                //}
                
                result = ["sliders": sliders]
                
                
                
                source.setResult(JSONDictionary)
                
            } else {
                println(error)
                source.setError(error)
            }
        }
        
        return source.task
    }


}
