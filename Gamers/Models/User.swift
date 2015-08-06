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

    dynamic var id = ""             //ID
    dynamic var nameName = ""       //游戏英文名
    dynamic var password = ""       //密码预留
    dynamic var nickName = ""       //别名
    dynamic var sex = ""            //性别
    dynamic var mail = ""           //邮箱
    
    dynamic var userToke = ""       //从服务器返回的用户令牌
    dynamic var lastLogin = ""      //最近一次登入时间
    
    class func collection(#json: JSON) -> User {
        let realm = Realm()
        
        var collection: User = User.modelFromJSON(json)

        return collection
    }
    
    // 把JSON数据转换为对象
    class func modelFromJSON(json: JSON) -> User {
        let model = User()
        
        if let itemId = json["id"].string { model.id = itemId }
        if let nameName = json["name"].string { model.nameName = nameName }
        if let password = json["password"].string { model.password = password }
        if let nickName = json["nickname"].string { model.nickName = nickName }
        if let sex = json["sex"].string { model.sex = sex }
        if let mail = json["mail"].string { model.mail = mail }
        
        if let userToke = json["userToke"].string { model.userToke = userToke }
        if let lastLogin = json["lastlogin"].string { model.lastLogin = lastLogin }
        
        return model
    }

    
    
    

}