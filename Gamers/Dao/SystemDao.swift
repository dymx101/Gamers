//
//  SystemDao.swift
//  Gamers
//
//  Created by 虚空之翼 on 15/9/1.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

import UIKit
import Alamofire
import Bolts
import SwiftyJSON

struct SystemDao {}

extension SystemDao {
    static func getVersion() -> BFTask {
        var URLRequest = Router.Version()
        
        return fetchVersion(URLRequest: URLRequest)
    }
    

    
    private static func fetchVersion(#URLRequest: URLRequestConvertible) -> BFTask {
        var source = BFTaskCompletionSource()
        
        Alamofire.request(URLRequest).responseJSON { (_, _, JSONDictionary, error) in
            if error == nil {
                var sliders = [Version]()
                
                if let JSONDictionary: AnyObject = JSONDictionary {
                    sliders = Version.collection(json: JSON(JSONDictionary))
                }
                
                source.setResult(sliders)
                
            } else {
                source.setError(error)
            }
        }
        
        return source.task
    }
    
}
