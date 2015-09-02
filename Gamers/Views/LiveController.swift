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
    
    var liveListData = [Live]()
    var videoPageOffset = 1         //分页偏移量
    var videoPageCount = 20         //每页视频总数
    
    var isNoMoreData: Bool = false  //解决控件不能自己判断BUG
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 刷新插件
        self.tableView.header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: "loadNewData")
        self.tableView.footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: "loadMoreData")
        
        // 子页面TwitchPlayerView的导航栏返回按钮文字，可为空（去掉按钮文字）
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
        
        LiveBL.sharedSingleton.getLive(page: videoPageOffset, limit: videoPageCount).continueWithSuccessBlock({ [weak self] (task: BFTask!) -> BFTask! in
            self!.liveListData = (task.result as? [Live])!
            self!.videoPageOffset += 1

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
        videoPageOffset = 1
        LiveBL.sharedSingleton.getLive(page: videoPageOffset, limit: videoPageCount).continueWithSuccessBlock({ [weak self] (task: BFTask!) -> BFTask! in
            self!.liveListData = (task.result as? [Live])!
            self!.videoPageOffset += 1
            
            self?.tableView.reloadData()

            return nil
        }).continueWithBlock({ [weak self] (task: BFTask!) -> BFTask! in
            self?.tableView.header.endRefreshing()
            self?.tableView.footer.resetNoMoreData()
            
            return nil
        })
        
    }
    /**
    加载更多数据
    */
    func loadMoreData() {
        LiveBL.sharedSingleton.getLive(page: videoPageOffset, limit: videoPageCount).continueWithSuccessBlock({ [weak self] (task: BFTask!) -> BFTask! in
            let newData = (task.result as? [Live])!

            // 如果没有数据显示加载完成，否则继续
            if newData.isEmpty {
                self?.tableView.footer.noticeNoMoreData()
                self!.isNoMoreData = true
            } else{
                self?.tableView.footer.endRefreshing()
                self!.liveListData += newData
                
                self!.videoPageOffset += 1
                self?.tableView.reloadData()
            }
            
            return nil
        }).continueWithBlock({ [weak self] (task: BFTask!) -> BFTask! in
            if task.error != nil { }
            if !self!.isNoMoreData {
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
        if liveListData.isEmpty {
            return 1
        } else {
            return liveListData.count
        }

    }
    // 设置行高
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if liveListData.isEmpty {
            return view.frame.size.height - 20 - 44
        } else {
            if indexPath.row < 5 {
                return 224
            } else {
                return 73
            }
        }
    }
    // 设置表格内容
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // 指定identify进行重用提高性能
        if liveListData.isEmpty {
            // 没有数据时候显示提醒
            let cell = tableView.dequeueReusableCellWithIdentifier("LiveNoDataCell", forIndexPath: indexPath) as! UITableViewCell
            cell.selectionStyle = UITableViewCellSelectionStyle.None        //不可选
            tableView.separatorStyle = UITableViewCellSeparatorStyle.None   //删除下划线
            
            return cell
        } else {
            tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
            
            if indexPath.row < 5 {
                let cell = tableView.dequeueReusableCellWithIdentifier("LiveLargeCell", forIndexPath: indexPath) as! LiveLargeCell
                cell.setLiveData(liveListData[indexPath.row])

                return cell
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier("LiveSmallCell", forIndexPath: indexPath) as! LiveSmallCell
                cell.setLiveData(liveListData[indexPath.row])

                return cell
            }
        }
        
        
    }
    // 点击跳转到播放页面
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if !self.liveListData.isEmpty {
            let view = self.storyboard!.instantiateViewControllerWithIdentifier("TwitchPlayerVC") as? TwitchPlayerController
            view?.LiveData = self.liveListData[indexPath.row]
            
            self.navigationController?.pushViewController(view!, animated: true)
        }
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