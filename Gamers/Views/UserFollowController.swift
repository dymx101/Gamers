//
//  UserFollowController.swift
//  Gamers
//
//  Created by 虚空之翼 on 15/8/6.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

import UIKit
import MJRefresh
import Bolts
import MBProgressHUD

class UserFollowController: UITableViewController {

    var videoData = [Video]()
    
    let userBL = UserBL()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 上拉下拉刷新功能
        self.tableView.header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: "loadNewData")
        self.tableView.footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: "loadMoreData")

        // 删除多余的分割线
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        // cell分割线边距，ios8处理
        if self.tableView.respondsToSelector("setSeparatorInset:") {
            self.tableView.separatorInset = UIEdgeInsetsMake(0, 5, 0, 5)
        }
        if self.tableView.respondsToSelector("setLayoutMargins:") {
            self.tableView.layoutMargins = UIEdgeInsetsMake(0, 5, 0, 5)
        }
        

        
        
        
        
    }

    
    // 初始化数据
    func loadInitData() {
        
        
    }
    // 下拉刷新数据
    func loadNewData() {
        userBL.getSubscriptions(userId: "", userToken: "").continueWithSuccessBlock({ [weak self] (task: BFTask!) -> BFTask! in
            println(task.result)
            self!.videoData = (task.result as? [Video])!
            
            self?.tableView.reloadData()
            self?.tableView.header.endRefreshing()
            
            return nil
        })
    }
    
    
    // 上拉获取更多数据
    func loadMoreData() {
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
// MARK: - Table view data source
extension UserFollowController: UITableViewDataSource, UITableViewDelegate {
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    // 设置总行数
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videoData.count
    }
    // 设置表格行内容
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UserFollowCell", forIndexPath: indexPath) as! VideoListCell
        
        let imageUrl = self.videoData[indexPath.row].imageSource.stringByReplacingOccurrencesOfString(" ", withString: "%20", options: NSStringCompareOptions.LiteralSearch, range: nil)
        cell.videoImage.kf_setImageWithURL(NSURL(string: imageUrl)!)
        cell.videoTitle.text = self.videoData[indexPath.row].videoTitle
        cell.videoChannel.text = self.videoData[indexPath.row].owner
        cell.videoViews.text = String(self.videoData[indexPath.row].views)
        
        cell.delegate = self
        
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
}

// MARK: 表格行Cell代理
extension UserFollowController: MyCellDelegate {
    // 分享按钮
    func clickCellButton(sender: UITableViewCell) {
        
        let table = self.view.viewWithTag(sender.superview!.superview!.tag) as! UITableView
        var index: NSIndexPath = table.indexPathForCell(sender)!
        
        println("表格：\(sender.tag - index.row - 100)，行：\(index.row)")
        
        
        var actionSheetController: UIAlertController = UIAlertController()
        
        actionSheetController.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel) { (alertAction) -> Void in
            NSLog("Tap 取消 Button")
        })
        actionSheetController.addAction(UIAlertAction(title: "破坏性按钮", style: UIAlertActionStyle.Destructive) { (alertAction) -> Void in
            NSLog("Tap 破坏性按钮 Button")
        })
        
        actionSheetController.addAction(UIAlertAction(title: "新浪微博", style: UIAlertActionStyle.Default) { (alertAction) -> Void in
            NSLog("Tap 新浪微博 Button")
        })
        
        //显示
        self.presentViewController(actionSheetController, animated: true, completion: nil)
        
        
    }
}





