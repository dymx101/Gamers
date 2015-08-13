//
//  ChannelListController.swift
//  Gamers
//
//  Created by 虚空之翼 on 15/8/11.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

import UIKit
import MJRefresh
import MBProgressHUD
import Bolts

class ChannelListController: UITableViewController {

    let channelBL = ChannelBL()
    
    var channelType: String!
    var viewTag: Int!
    
    var videoData = [Video]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "新手推荐"

        // 上拉下拉刷新功能
        self.tableView.header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: "loadNewData")
        self.tableView.footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: "loadMoreData")
        
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
        
        
        loadInitData()
        

    }
    
    /**
    启动初始化数据
    */
    func loadInitData() {
        let hub = MBProgressHUD.showHUDAddedTo(self.navigationController!.view, animated: true)
        hub.labelText = "加载中..."
        
        channelBL.getRecommendChannel(channelType: "abc", offset: 0, count: 20, order: "date").continueWithSuccessBlock({ [weak self] (task: BFTask!) -> BFTask! in
            self!.videoData = (task.result as? [Video])!
            self?.tableView.reloadData()
            
            MBProgressHUD.hideHUDForView(self!.navigationController!.view, animated: true)
            
            return nil
        })
    }
    /**
    刷新数据
    */
    func loadNewData() {
        channelBL.getRecommendChannel(channelType: "abc", offset: 0, count: 20, order: "date").continueWithSuccessBlock({ [weak self] (task: BFTask!) -> BFTask! in
            self!.videoData = (task.result as? [Video])!
            
            self?.tableView.reloadData()
            self?.tableView.header.endRefreshing()
            
            return nil
        })
    }
    /**
    刷新数据
    */
    func loadMoreData() {
        channelBL.getRecommendChannel(channelType: "abc", offset: 0, count: 20, order: "date").continueWithSuccessBlock({ [weak self] (task: BFTask!) -> BFTask! in
            self!.videoData = (task.result as? [Video])!
            
            self?.tableView.reloadData()
            self?.tableView.header.endRefreshing()
            
            return nil
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return videoData.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ChannelListCell", forIndexPath: indexPath) as! VideoListCell
        
        let imageUrl = self.videoData[indexPath.row].imageSource.stringByReplacingOccurrencesOfString(" ", withString: "%20", options: NSStringCompareOptions.LiteralSearch, range: nil)
        cell.videoImage.kf_setImageWithURL(NSURL(string: imageUrl)!)
        cell.videoTitle.text = self.videoData[indexPath.row].videoTitle
        cell.videoChannel.text = self.videoData[indexPath.row].owner
        cell.videoViews.text = String(self.videoData[indexPath.row].views)
        
        cell.delegate = self
        
        return cell
    }
    
    // 跳转传值
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // 定义列表控制器
        var playerViewController = segue.destinationViewController as! PlayerViewController
        // 提取选中的游戏视频，把值传给列表页面
        var indexPath = self.tableView.indexPathForSelectedRow()!
        playerViewController.videoData =  videoData[indexPath.row]
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

// 表格行Cell代理
extension ChannelListController: MyCellDelegate {
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
