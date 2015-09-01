//
//  Version.swift
//  Gamers
//
//  Created by 虚空之翼 on 15/9/1.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON

class Version: Object {
    dynamic var app = ""
    dynamic var version = ""
    dynamic var updateUrl = ""
    dynamic var appstoreUrl = ""    //苹果商店地址
    dynamic var date = ""
    
    class func collection(#json: JSON) -> [Version] {
        var collection = [Version]()
        if let items = json.array {
            for item in items {
                collection.append(Version.modelFromJSON(item))
            }
        }
        
        return collection
    }
    

    class func modelFromJSON(json: JSON) -> Version {
        let model = Version()
        
        if let app = json["app"].string { model.app = app }
        if let version = json["version"].string { model.version = version }
        if let updateUrl = json["updateurl"].string { model.updateUrl = updateUrl }
        if let appstoreUrl = json["appstoreurl"].string { model.appstoreUrl = appstoreUrl }
        if let date = json["date"].string { model.date = date }

        return model
    }


}