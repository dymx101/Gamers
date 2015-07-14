//
//  Thumbnail.swift
//  Gamers
//
//  Created by 虚空之翼 on 15/7/14.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON

class Thumbnail: Object {
    dynamic var resolution = "default"  // default, medium, high, standard, maxres
    dynamic var url        = ""
    dynamic var width      = 0
    dynamic var height     = 0
    
    // MARK: - Initialization
    
    // Custom initializer is not supported yet (github.com/realm/realm-cocoa/issues/1101)
    // init(resolution: String, json: JSON) {}
    
    class func modelFromJSON(json: JSON) -> Thumbnail {
        return Thumbnail.modelFromJSON(json, resolution: nil)
    }
    
    class func modelFromJSON(json: JSON, resolution: String?) -> Thumbnail {
        let model = Thumbnail()
        
        if let resolution = resolution {
            model.resolution = resolution
        }
        
        if let url = json["url"].string {
            model.url = url
        }
        
        if let width = json["width"].int {
            model.width = width
        }
        
        if let height = json["height"].int {
            model.height = height
        }
        
        return model
    }
}
