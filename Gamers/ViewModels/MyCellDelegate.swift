//
//  MyCellDelegate.swift
//  Gamers
//
//  Created by 虚空之翼 on 15/8/13.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

import UIKit
import Foundation

// videoCell的代理协议
@objc protocol MyCellDelegate: NSObjectProtocol {
    // 点击分享功能
    optional func clickCellButton(cell: UITableViewCell)
    // 点击隐藏键盘
    optional func hideKeyboard(cell: UITableViewCell)
}

// channelCell的代理协议
@objc protocol ChannelCellDelegate: NSObjectProtocol {
    // 点击取消跟随
    optional func clickCellUnFollow(cell: UITableViewCell)
}