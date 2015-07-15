//
//  SliderBL.swift
//  Gamers
//
//  Created by 虚空之翼 on 15/7/15.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

import Foundation

class SliderBL: NSObject, SliderBLDelegate {
    
    var delegate: SliderBLDelegate!
    
    //查询所有数据方法 成功
    func findAllNotesFinished(list : NSMutableArray) {
        
    }
    
    //查询所有数据方法 失败
    func findAllNotesFailed(error : NSError) {
        
    }
    
    
}