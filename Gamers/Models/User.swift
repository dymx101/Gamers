//
//  User.swift
//  Gamers
//
//  Created by 虚空之翼 on 15/7/24.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON

class User: Object {

    dynamic var userId = ""         //ID
    dynamic var userName = ""       //用户名称
    dynamic var firstName = ""
    dynamic var lastName = ""
    dynamic var email = ""          //邮箱
    dynamic var gender = ""         //性别
    dynamic var mobilePhone = ""
    
    dynamic var country = ""
    dynamic var state = ""
    dynamic var zip = ""
    dynamic var communityId = ""
    dynamic var avatar = ""         //头像
    dynamic var about = ""
    
    dynamic var userToken = ""       //从服务器返回的用户令牌
    dynamic var expires = 0        //有效期（到期时间）
    
    override static func primaryKey() -> String? {
        return "userId"
    }
    
    class func collection(#json: JSON) -> User {
        return User.modelFromJSON(json)
    }
    
    // 把JSON数据转换为对象
    class func modelFromJSON(json: JSON) -> User {
        let model = User()
        
        if let userId = json["user_id"].string { model.userId = userId }
        if let userName = json["username"].string { model.userName = userName }
        if let firstName = json["first_name"].string { model.firstName = firstName }
        if let lastName = json["last_name"].string { model.lastName = lastName }
        if let email = json["email"].string { model.email = email }
        if let gender = json["gender"].string { model.gender = gender }
        if let mobilePhone = json["mobile_phone"].string { model.mobilePhone = mobilePhone }
        
        if let country = json["country"].string { model.country = country }
        if let state = json["state"].string { model.state = state }
        if let zip = json["zip"].string { model.zip = zip }
        if let communityId = json["communityId"].string { model.communityId = communityId }
        if let avatar = json["avatar"].string { model.avatar = avatar }
        if let about = json["about"].string { model.about = about }
        
        if let userToken = json["token"].string { model.userToken = userToken }
        if let expires = json["expires"].int { model.expires = expires }
        
        return model
    }

    
    
    

}