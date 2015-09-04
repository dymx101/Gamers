//
//  UserHistoryController.swift
//  Gamers
//
//  Created by 虚空之翼 on 15/8/6.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

import UIKit
import MJRefresh
import Bolts
import MBProgressHUD
import RealmSwift

class UserHistoryController: UITableViewController {
    
    let realm = Realm()

    var videoAllData = [Video]()
    var videoListData = [Video]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 上拉下拉刷新功能
        self.tableView.header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: "loadNewData")
        //self.tableView.footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: "loadMoreData")
        
        
        // 子页面PlayerView的导航栏返回按钮文字，可为空（去掉按钮文字）
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        // 删除多余的分割线
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        // cell分割线边距，ios8处理
        if self.tableView.respondsToSelector("setSeparatorInset:") {
            self.tableView.separatorInset = UIEdgeInsetsMake(0, 5, 0, 5)
        }
        if self.tableView.respondsToSelector("setLayoutMargins:") {
            self.tableView.layoutMargins = UIEdgeInsetsMake(0, 5, 0, 5)
        }
        
        // 加载初始数据
        loadInitData()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        // 播放页面返回后，重置导航条的透明属性，//todo:image_1.jpg需求更换下
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "image_1.jpg"),forBarMetrics: UIBarMetrics.CompactPrompt)
        self.navigationController?.navigationBar.shadowImage = UIImage(named: "image_1.jpg")
        self.navigationController?.navigationBar.translucent = false
    }
    
    // 初始化数据
    func loadInitData() {
        // 计算一星期前的时间
        var now = NSDate()
        var weekday = NSDate(timeInterval: -24*60*60*7, sinceDate: now)
        
        let predicate = NSPredicate(format: "playDate >= %@", weekday)
        let results = realm.objects(Video).filter(predicate).sorted("playDate", ascending: false)

        for video in results {
            videoListData.append(video)
        }

        self.tableView.reloadData()
    }
    // 下拉刷新数据
    func loadNewData() {
        videoListData = [Video]()
        
        // 计算一星期前的时间
        var now = NSDate()
        var weekday = NSDate(timeInterval: -24*60*60*7, sinceDate: now)
        
        let predicate = NSPredicate(format: "playDate >= %@", weekday)
        let results = realm.objects(Video).filter(predicate).sorted("playDate", ascending: false)
        
        for video in results {
            videoListData.append(video)
        }
        
        self.tableView.reloadData()

        self.tableView.header.endRefreshing()
    }
    
    // TODO: 上拉获取更多数据，采用分页形式，现在Realm不支持分页查询
    func loadMoreData() {
        
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

// MARK: - Table view data source
extension UserHistoryController: UITableViewDataSource, UITableViewDelegate {
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    // 设置总行数
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videoListData.count
    }
    // 设置表格行内容
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UserHistoryCell", forIndexPath: indexPath) as! UserHistoryCell
        cell.setVideo(videoListData[indexPath.row])
        
        return cell
    }
    // cell分割线的边距
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if cell.respondsToSelector("setSeparatorInset:") {
            cell.separatorInset = UIEdgeInsetsMake(0, 5, 0, 5)
        }
        if cell.respondsToSelector("setLayoutMargins:") {
            cell.layoutMargins = UIEdgeInsetsMake(0, 5, 0, 5)
        }
    }
    // 跳转传值
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // 定义列表控制器
        var playerViewController = segue.destinationViewController as! PlayerViewController
        // 提取选中的游戏视频，把值传给列表页面
        var indexPath = self.tableView.indexPathForSelectedRow()!
        playerViewController.videoData =  videoListData[indexPath.row]
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        var indexPaths = [indexPath]
        if editingStyle == UITableViewCellEditingStyle.Delete {
            //删除数据要先执行，再删除界面上表格行
            realm.write {
                self.realm.delete(self.videoListData[indexPath.row])
            }
            self.videoListData.removeAtIndex(indexPath.row)
            
            tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Automatic)
            
        }
        
        //self.tableView.reloadData()
    }
}
