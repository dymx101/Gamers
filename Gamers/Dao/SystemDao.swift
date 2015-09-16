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
    
    // 获取版本信息
    static func getVersion() -> BFTask {
        var URLRequest = Router.Version()
        
        return fetchVersion(URLRequest: URLRequest)
    }
    

    // 解析版本JSON结构
    private static func fetchVersion(#URLRequest: URLRequestConvertible) -> BFTask {
        var source = BFTaskCompletionSource()
        
        Alamofire.request(URLRequest).responseJSON { (_, _, JSONDictionary, error) in
            if error == nil {
                if let JSONDictionary: AnyObject = JSONDictionary {
                    if JSON(JSONDictionary)["errCode"] == nil {
                        let version = Version.collection(json: JSON(JSONDictionary))
                        source.setResult(version)
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
