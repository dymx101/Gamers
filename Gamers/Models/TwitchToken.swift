//
//  TwitchToken.swift
//  Gamers
//
//  Created by 虚空之翼 on 15/9/4.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON

class TwitchToken: Object {
    dynamic var token = ""
    dynamic var sig = ""
    dynamic var mobileRestricted = false

    class func collection(#json: JSON) -> TwitchToken {
        return TwitchToken.modelFromJSON(json)
    }
    
    // 把JSON数据转换为对象
    class func modelFromJSON(json: JSON) -> TwitchToken {
        let model = TwitchToken()
        
        if let token = json["token"].string { model.token = token }
        if let sig = json["sig"].string { model.sig = sig }
        if let mobileRestricted = json["mobile_restricted"].bool { model.mobileRestricted = mobileRestricted }
        
        return model
    }
    
}