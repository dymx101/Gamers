//
//  LiveController.swift
//  Gamers
//
//  Created by 虚空之翼 on 15/7/20.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

import UIKit
import Bolts
import MJRefresh
import MBProgressHUD
import ReachabilitySwift

class LiveController: UITableViewController {
    
    let liveBL = LiveBL()
    
    var liveData = [Live]()
    var videoPageOffset = 0         //分页偏移量，默认为上次最后一个视频ID
    var videoPageCount = 20         //每页视频总数
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 刷新插件
        self.tableView.header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: "loadNewData")
        self.tableView.footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: "loadMoreData")
        
        // 子页面TwitchPlayerView的导航栏返回按钮文字，可为空（去掉按钮文字）
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        // cell分割线边距，ios8处理
        if self.tableView.respondsToSelector("setSeparatorInset:") {
            self.tableView.separatorInset = UIEdgeInsetsMake(0, 5, 0, 5)
        }
        if self.tableView.respondsToSelector("setLayoutMargins:") {
            self.tableView.layoutMargins = UIEdgeInsetsMake(0, 5, 0, 5)
        }
        
        // 初始化数据
        loadInitData()
        
        //self.tabBarItem.badgeValue = "22"
        self.navigationController?.tabBarItem.badgeValue = nil  //=""，会有小红点


    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /**
    启动初始化数据
    */
    func loadInitData() {
        let hub = MBProgressHUD.showHUDAddedTo(self.navigationController!.view, animated: true)
        hub.labelText = "加载中..."
        
        liveBL.getLive(offset: videoPageOffset, count: videoPageCount).continueWithSuccessBlock({ [weak self] (task: BFTask!) -> BFTask! in
            self!.liveData = (task.result as? [Live])!
            self!.videoPageOffset += self!.videoPageCount

            self?.tableView.reloadData()
            
            return nil
        }).continueWithBlock({ [weak self] (task: BFTask!) -> BFTask! in
            if task.error != nil {
                println(task.error)
            }
            MBProgressHUD.hideHUDForView(self!.navigationController!.view, animated: true)
            
            return nil
        })
        
    }
    
    /**
    刷新数据
    */
    func loadNewData() {
        videoPageOffset = 0
        liveBL.getLive(offset: videoPageOffset, count: videoPageCount).continueWithSuccessBlock({ [weak self] (task: BFTask!) -> BFTask! in
            self!.liveData = (task.result as? [Live])!
            self!.videoPageOffset += self!.videoPageCount
            
            self?.tableView.reloadData()
            self?.tableView.header.endRefreshing()
            self?.tableView.footer.resetNoMoreData()

            return nil
        }).continueWithBlock({ [weak self] (task: BFTask!) -> BFTask! in
            if task.error != nil {
                println(task.error)
                self?.tableView.header.endRefreshing()
            }
            
            return nil
        })
        
        
    }
    /**
    加载更多数据
    */
    func loadMoreData() {
        liveBL.getLive(offset: videoPageOffset, count: videoPageCount).continueWithSuccessBlock({ [weak self] (task: BFTask!) -> BFTask! in
            let newData = (task.result as? [Live])!

            // 如果没有数据显示加载完成，否则继续
            if newData.isEmpty {
                self?.tableView.footer.noticeNoMoreData()
            } else{
                self?.tableView.footer.endRefreshing()
                self!.liveData += newData
                
                self!.videoPageOffset += self!.videoPageCount
                self?.tableView.reloadData()
            }
            
            return nil
        }).continueWithBlock({ [weak self] (task: BFTask!) -> BFTask! in
            if task.error != nil {
                println(task.error)
                self?.tableView.footer.endRefreshing()
            }
            return nil
        })
        
        
    }

    override func viewWillAppear(animated: Bool) {
        // 播放页面返回后，重置导航条的透明属性，//todo:image_1.jpg需求更换下
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "image_1.jpg"),forBarMetrics: UIBarMetrics.CompactPrompt)
        self.navigationController?.navigationBar.shadowImage = UIImage(named: "image_1.jpg")
        self.navigationController?.navigationBar.translucent = false
    }
 
}

// MARK: - 表格代理协议
extension LiveController: UITableViewDataSource, UITableViewDelegate {
    // 设置表格行数
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return liveData.count
    }
    // 设置行高
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row < 5 {
            return 224
        } else {
            return 73
        }
    }
    // 设置表格内容
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // 指定identify进行重用提高性能
        
        if indexPath.row < 5 {
            let cell = tableView.dequeueReusableCellWithIdentifier("LiveLargeCell", forIndexPath: indexPath) as! LiveLargeCell
            
            cell.channelName.text = liveData[indexPath.row].user.userName
            cell.videoViews.text = liveData[indexPath.row].stream.steamDescription
            
            let imageUrl = liveData[indexPath.row].stream.thumbnail.large.stringByReplacingOccurrencesOfString(" ", withString: "%20", options: NSStringCompareOptions.LiteralSearch, range: nil)
            cell.videoImage.kf_setImageWithURL(NSURL(string: imageUrl)!)
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("LiveSmallCell", forIndexPath: indexPath) as! LiveSmallCell
            
            cell.channelName.text = liveData[indexPath.row].user.userName
            cell.videoViews.text = liveData[indexPath.row].stream.steamDescription
            
            let imageUrl = liveData[indexPath.row].stream.thumbnail.large.stringByReplacingOccurrencesOfString(" ", withString: "%20", options: NSStringCompareOptions.LiteralSearch, range: nil)
            cell.videoImage.kf_setImageWithURL(NSURL(string: imageUrl)!)
            
            return cell
        }
        
    }
    // 点击跳转到播放页面
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        NSLog("点击了第%ld个游戏", indexPath.row)
        let view = self.storyboard!.instantiateViewControllerWithIdentifier("TwitchPlayerVC") as? TwitchPlayerController
        view?.LiveData = self.liveData[indexPath.row]
        
        self.navigationController?.pushViewController(view!, animated: true)
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