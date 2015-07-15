//
//  SliderDaoDelegate.swift
//  Gamers
//
//  Created by 虚空之翼 on 15/7/15.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

import Foundation

protocol SliderDaoDelegate {
    //查询所有数据方法 成功
    func findAllFinished(list : NSMutableArray)
    
    //查询所有数据方法 失败
    func findAllFailed(error : NSError)
    
    //按照主键查询数据方法 成功
    func findByIdFinished(model : Slider)
    
    //按照主键查询数据方法 失败
    func findByIdFailed(error : NSError)
}