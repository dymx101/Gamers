//
//  SystemController.swift
//  Gamers
//
//  Created by 虚空之翼 on 15/8/6.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

import UIKit
import RealmSwift
import Haneke

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
            let homeUrl = "http://www.gamers.tm"
            UIApplication.sharedApplication().openURL(NSURL(string: homeUrl)!)
        case 1 where indexPath.row == 1 :
            let storeUrl = "itms-apps://itunes.apple.com/app/id1040036058"
            println(storeUrl)
            UIApplication.sharedApplication().openURL(NSURL(string: storeUrl)!)
        default: ()

        }
        

    }
    
    // 清理系统缓存
    func systemClear() {
        // 清理数据库
        //let history = History()
        realm.write {
            self.realm.deleteAll()
            //self.realm.delete(history)
        }
        
        // 清理缓存
        Shared.dataCache.removeAll()
        Shared.imageCache.removeAll()
        
        // 提示
        var alertController: UIAlertController = UIAlertController(title: "", message: "清理完毕", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.Cancel) { (alertAction) -> Void in
            

        })
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }

}
