//
//  VideoListController.swift
//  Gamers
//
//  Created by 虚空之翼 on 15/7/27.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

import UIKit
import Bolts
import MJRefresh
import MBProgressHUD

class VideoListController: UITableViewController {
    
    let gameBL = GameBL()
    
    var gameData: Game!
    var videoData = [Video]()
    var videoPageOffset = 0         //分页偏移量，默认为上次最后一个视频ID
    var videoPageCount = 20         //每页视频总数

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = self.gameData.nameZh
        
        // 刷新功能
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

        // 加载初始化数据
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
        let hub = MBProgressHUD.showHUDAddedTo(self.navigationController!.view, animated: true)
        hub.labelText = "加载中..."
        
        videoPageOffset = 0
        gameBL.getGameVideo(self.gameData.name, offset: videoPageOffset, count: videoPageCount).continueWithSuccessBlock({ [weak self] (task: BFTask!) -> BFTask! in
            self!.videoData = (task.result as? [Video])!
            
            self?.tableView.reloadData()
            
            return nil
        }).continueWithBlock({ [weak self] (task: BFTask!) -> BFTask! in
            MBProgressHUD.hideHUDForView(self!.navigationController!.view, animated: true)
            
            return nil
        })
    }
    /**
    刷新数据
    */
    func loadNewData() {
        videoPageOffset = 0
        gameBL.getGameVideo(self.gameData.name, offset: videoPageOffset, count: videoPageCount).continueWithSuccessBlock({ [weak self] (task: BFTask!) -> BFTask! in
            self!.videoData = (task.result as? [Video])!
            self?.tableView.reloadData()

            return nil
        }).continueWithBlock({ [weak self] (task: BFTask!) -> BFTask! in
            self?.tableView.header.endRefreshing()
            
            return nil
        })
    }
    /**
    加载更多数据
    */
    func loadMoreData() {
        gameBL.getGameVideo(self.gameData.name, offset: videoPageOffset, count: videoPageCount).continueWithSuccessBlock({ [weak self] (task: BFTask!) -> BFTask! in
            var newData = (task.result as? [Video])!
            
            // 如果没有数据显示加载完成，否则继续
            if newData.isEmpty {
                self?.tableView.footer.noticeNoMoreData()
            } else{
                self!.videoData += newData
                self!.videoPageOffset += self!.videoPageCount
                
                self?.tableView.reloadData()
            }
            
            return nil
        }).continueWithBlock({ [weak self] (task: BFTask!) -> BFTask! in
            self?.tableView.footer.endRefreshing()
            
            return nil
        })
    }
    
    // 跳转传值
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // 定义列表控制器
        var playerViewController = segue.destinationViewController as! PlayerViewController
        // 提取选中的游戏视频，把值传给列表页面
        var indexPath = self.tableView.indexPathForSelectedRow()!
        playerViewController.videoData =  videoData[indexPath.row]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

// MARK: - Table view data source
extension VideoListController: UITableViewDataSource, UITableViewDelegate {
    // 一个分区
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    // 设置表格行数
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return videoData.count
    }
    // 设置行高
    //    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    //        return 100
    //    }
    
    // 设置表格行内容
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("VideoListCell", forIndexPath: indexPath) as! VideoListCell
        
        let imageUrl = self.videoData[indexPath.row].imageSource.stringByReplacingOccurrencesOfString(" ", withString: "%20", options: NSStringCompareOptions.LiteralSearch, range: nil)
        cell.videoImage.kf_setImageWithURL(NSURL(string: imageUrl)!)
        cell.videoTitle.text = self.videoData[indexPath.row].videoTitle
        cell.videoChannel.text = self.videoData[indexPath.row].owner
        cell.videoViews.text = String(self.videoData[indexPath.row].views)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 30))
        //footerView.backgroundColor = UIColor.blackColor()
        return footerView
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