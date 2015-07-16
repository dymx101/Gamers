//
//  ChannelBLDelegate.swift
//  Gamers
//
//  Created by 虚空之翼 on 15/7/16.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

import Foundation
import Bolts

protocol ChannelBLDelegate {
    
    //查询所有数据方法 成功
    func findChannel(channelType : String) -> BFTask
    
    //查询所有数据方法 失败
    //func findAllNotesFailed(error : NSError)
    
}