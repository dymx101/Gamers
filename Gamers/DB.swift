//
//  DB.swift
//  Sqlite-2
//
//  Created by 虚空之翼 on 15/6/23.
//  Copyright (c) 2015年 虚空之翼. All rights reserved.
//

import Foundation

class DB{
    class func getDb()->FMDatabase{
        let filemgr = NSFileManager.defaultManager()
        let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let docsDir = dirPaths[0] as! String
        println(docsDir)
        var databasePath = docsDir.stringByAppendingPathComponent("gamers.db")
        // 第一次初始化数据库
        if !filemgr.fileExistsAtPath(databasePath) {
            let db = FMDatabase(path: databasePath)
            if db == nil {
                println("Error: \(db.lastErrorMessage())")
            }
            if db.open() {
                let sql_stmt = "CREATE TABLE IF NOT EXISTS SYSTEM (ID TEXT PRIMARY KEY, KEYWORDS VARCHAR, IOS INTEGER, ANDROID INTEGER, REMARK TEXT)"
                if !db.executeStatements(sql_stmt) {
                    println("Error: \(db.lastErrorMessage())")
                }
                db.close()
            } else {
                println("Error: \(db.lastErrorMessage())")
            }
        }
        let freedomDB = FMDatabase(path: databasePath)
        return freedomDB
    }
    
}

