//
//  ModelSerializable.swift
//  Gamers
//
//  Created by 虚空之翼 on 15/7/14.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

import Foundation
import SwiftyJSON

public protocol ModelSerializable {
    static func modelFromJSON(json: JSON) -> Self
}
