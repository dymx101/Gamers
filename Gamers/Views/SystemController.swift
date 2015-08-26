//
//  SystemController.swift
//  Gamers
//
//  Created by 虚空之翼 on 15/8/6.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

import UIKit
import RealmSwift
import Kingfisher

class SystemController: UITableViewController {
    
    let realm = Realm()

    override func viewDidLoad() {
        super.viewDidLoad()

        // 统计缓存总数
        

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

    // 点击触发
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        switch indexPath.section {
        case 0 :
            systemClear()
        case 1 where indexPath.row == 0 :
            let storeUrl = "https://www.freedom.tm"
            UIApplication.sharedApplication().openURL(NSURL(string: storeUrl)!)
        case 1 where indexPath.row == 1 :
            let storeUrl = "http://itunes.apple.com/us/app/apple-store/id375380948?mt=8"
            UIApplication.sharedApplication().openURL(NSURL(string: storeUrl)!)
        default:
            println("abc")
        }
        

    }
    
    // 清理系统缓存
    func systemClear() {
        
        println("清理数据")
        // 清理数据库
        
        //let history = History()
        
//        realm.write {
//            self.realm.deleteAll()
//            //self.realm.delete(history)
//        }
        
        // 清理缓存
        let cache = KingfisherManager.sharedManager.cache
        cache.clearMemoryCache()
        cache.clearDiskCache()
        cache.cleanExpiredDiskCache()
        
        // 提示
        var alertController: UIAlertController = UIAlertController(title: "", message: "清理完毕", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.Cancel) { (alertAction) -> Void in
            

        })
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }

}
