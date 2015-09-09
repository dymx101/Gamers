//
//  YTError.swift
//  Gamers
//
//  Created by 虚空之翼 on 15/9/9.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON

class YTError: Object {
    dynamic var code = 0        //返回代码
    dynamic var message = ""    //返回文本消息
    dynamic var errors = ""     //返回附带数据
    
    class func collection(#json: JSON) -> YTError {
        return YTError.modelFromJSON(json["error"])
    }
    
    // 把JSON数据转换为对象
    class func modelFromJSON(json: JSON) -> YTError {
        let model = YTError()
        
        if let code = json["code"].int { model.code = code }
        if let message = json["message"].string { model.message = message }
        if let errors = json["errors"].string { model.errors = errors }
        
        return model
    }
    
}