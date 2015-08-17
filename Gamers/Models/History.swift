//
//  History.swift
//  Gamers
//
//  Created by 虚空之翼 on 15/8/17.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

import Foundation
import RealmSwift

class History: Object {
    //dynamic var user = User()
    dynamic var id = 0
    dynamic var video = Video()
    dynamic var date = NSDate()
    
    override static func primaryKey() -> String? {
        return "id"
    }

}