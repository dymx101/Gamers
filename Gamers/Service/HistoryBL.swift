//
//  HistoryBL.swift
//  Gamers
//
//  Created by 虚空之翼 on 15/8/17.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

import Foundation
import RealmSwift

private let _SingletonSharedInstanceHistoryBL = HistoryBL()

class HistoryBL: NSObject {
    // 单例模式
    class var sharedInstance : HistoryBL {
        return _SingletonSharedInstanceHistoryBL
    }
    
    // TODO: 获取数据
    func getList(offset: String?, count: String?) {
        let realm = Realm()
        
        // 计算一星期前的时间
        var now = NSDate()
        var weekday = NSDate(timeInterval: -24*60*60*7, sinceDate: now)
        
        let predicate = NSPredicate(format: "data >= %@ ", weekday)
        var history = realm.objects(History).filter(predicate)
        
    
        //return nil
    
    }
    
    // 添加历史记录
    func addVideo(video: Video) {
        let realm = Realm()
        
        let history = History()
        history.video = video
        history.date =  NSDate()
        
        realm.write {
            realm.add(history)
        }
        
        
    }


}