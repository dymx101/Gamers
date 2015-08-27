//
//  Response.swift
//  Gamers
//
//  Created by 虚空之翼 on 15/8/20.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON

class Response: Object {
    dynamic var code = ""       //返回代码
    dynamic var message = ""    //返回文本消息
    dynamic var data = ""       //返回附带数据

    class func collection(#json: JSON) -> Response {
        var collection: Response = Response.modelFromJSON(json)

        return collection
    }
    
    // 把JSON数据转换为对象
    class func modelFromJSON(json: JSON) -> Response {
        let model = Response()
        
        if let code = json["errCode"].string { model.code = code }
        if let message = json["errmsg"].string { model.message = message }
        if let data = json["data"].string { model.data = data }
        
        return model
    }
    
}