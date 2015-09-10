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
import Social
import RealmSwift

class VideoListController: UITableViewController {

    var gameData: Game!
    var videoListData = [Video]()
    var videoPageOffset = 1         //分页偏移量，默认为上次最后一个视频ID
    var videoPageCount = 20         //每页视频总数
    
    var isNoMoreData: Bool = false  //解决控件不能自己判断BUG

    override func viewDidLoad() {
        super.viewDidLoad()

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

        self.navigationItem.title = gameData.localName

        
    }
    
    override func viewWillAppear(animated: Bool) {
        // 播放页面返回后，重置导航条的透明属性，//todo:image_1.jpg需求更换下
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "navigation-bar1.png"),forBarMetrics: UIBarMetrics.CompactPrompt)
        self.navigationController?.navigationBar.shadowImage = UIImage(named: "navigation-bar1.png")
        self.navigationController?.navigationBar.translucent = false
    }
    
    // 初始化数据
    func loadInitData() {
        let hub = MBProgressHUD.showHUDAddedTo(self.navigationController!.view, animated: true)
        hub.labelText = "加载中..."
        
        videoPageOffset = 1
        GameBL.sharedSingleton.getGameVideo(gameId: gameData.gameId, page: videoPageOffset, limit: videoPageCount).continueWithSuccessBlock({ [weak self] (task: BFTask!) -> BFTask! in
            self!.videoListData = (task.result as? [Video])!
            self!.videoPageOffset += 1
            self?.tableView.reloadData()
            
            if self!.videoListData.count < self!.videoPageCount {
                self?.tableView.footer.noticeNoMoreData()
            }
            
            return nil
        }).continueWithBlock({ [weak self] (task: BFTask!) -> BFTask! in
            if task.error != nil { println(task.error) }
            MBProgressHUD.hideHUDForView(self!.navigationController!.view, animated: true)
            
            return nil
        })
    }
    /**
    刷新数据
    */
    func loadNewData() {
        videoPageOffset = 1
        GameBL.sharedSingleton.getGameVideo(gameId: gameData.gameId, page: videoPageOffset, limit: videoPageCount).continueWithSuccessBlock({ [weak self] (task: BFTask!) -> BFTask! in
            self!.videoListData = (task.result as? [Video])!
            self!.videoPageOffset += 1
            self?.tableView.reloadData()
            
            if self!.videoListData.count < self!.videoPageCount {
                self?.tableView.footer.noticeNoMoreData()
            } else {
                self?.tableView.footer.resetNoMoreData()
            }

            return nil
        }).continueWithBlock({ [weak self] (task: BFTask!) -> BFTask! in
            if task.error != nil { println(task.error) }
            self?.tableView.header.endRefreshing()
            self!.isNoMoreData = false
            
            return nil
        })
    }
    /**
    加载更多数据
    */
    func loadMoreData() {
        GameBL.sharedSingleton.getGameVideo(gameId: gameData.gameId, page: videoPageOffset, limit: videoPageCount).continueWithSuccessBlock({ [weak self] (task: BFTask!) -> BFTask! in
            var newData = (task.result as? [Video])!
            // 如果没有数据显示加载完成，否则继续
            if newData.isEmpty {
                self?.tableView.footer.noticeNoMoreData()
                self!.isNoMoreData = true
            } else{
                if newData.count < self!.videoPageCount {
                    self!.isNoMoreData = true
                }
                
                self!.videoListData += newData
                self!.videoPageOffset += 1
                self?.tableView.reloadData()
            }

            return nil
        }).continueWithBlock({ [weak self] (task: BFTask!) -> BFTask! in
            if task.error != nil { println(task.error) }
            if !self!.isNoMoreData {
                self?.tableView.footer.endRefreshing()
            }

            return nil
        })
    }
    
    // 跳转传值
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // 定义列表控制器
        var playerViewController = segue.destinationViewController as! PlayerViewController
        // 提取选中的游戏视频，把值传给列表页面
        var indexPath = self.tableView.indexPathForSelectedRow()!
        playerViewController.videoData =  videoListData[indexPath.row]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

// MARK: - 表格数据代理协议
extension VideoListController: UITableViewDataSource, UITableViewDelegate {
    // 一个分区
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    // 设置表格行数
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videoListData.count
    }
    // 设置行高
    //    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    //        return 100
    //    }
    
    // 设置表格行内容
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("VideoListCell", forIndexPath: indexPath) as! VideoListCell
        cell.setVideo(self.videoListData[indexPath.row])
        cell.delegate = self
        
        return cell
    }
    
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 30))
        
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

// MARK: - 表格行Cell代理
extension VideoListController: MyCellDelegate {
    // 分享按钮
    func clickCellButton(sender: UITableViewCell) {
        let table = self.view.viewWithTag(sender.superview!.superview!.tag) as! UITableView
        var index: NSIndexPath = table.indexPathForCell(sender)!
        //println("表格：\(sender.tag - index.row - 100)，行：\(index.row)")
        
        // 退出
        var actionSheetController: UIAlertController = UIAlertController()
        actionSheetController.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel) { (alertAction) -> Void in
            //code
        })
        // 关注频道
        actionSheetController.addAction(UIAlertAction(title: "跟随", style: UIAlertActionStyle.Destructive) { (alertAction) -> Void in
            if NSUserDefaults.standardUserDefaults().boolForKey("isLogin") {
                UserBL.sharedSingleton.setFollow(channelId: self.videoListData[index.row].ownerId)
            } else {
                var alertView: UIAlertView = UIAlertView(title: "", message: "请先登入", delegate: nil, cancelButtonTitle: "确定")
                alertView.show()
            }
        })
        // 分享到Facebook
        actionSheetController.addAction(UIAlertAction(title: "分享到Facebook", style: UIAlertActionStyle.Default) { (alertAction) -> Void in
            var slComposerSheet = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            slComposerSheet.setInitialText("share facebook")
            slComposerSheet.addImage(UIImage(named: "user.png"))
            slComposerSheet.addURL(NSURL(string: "http://www.facebook.com/"))
            self.presentViewController(slComposerSheet, animated: true, completion: nil)
            
            slComposerSheet.completionHandler = { (result: SLComposeViewControllerResult) in
                if result == .Done {
                    var alertView: UIAlertView = UIAlertView(title: "", message: "分享完成", delegate: nil, cancelButtonTitle: "确定")
                    alertView.show()
                }
            }
        })
        // 分享到Twitter
        actionSheetController.addAction(UIAlertAction(title: "分享到Twitter", style: UIAlertActionStyle.Default) { (alertAction) -> Void in
            var slComposerSheet = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            slComposerSheet.setInitialText("share facebook")
            slComposerSheet.addImage(UIImage(named: "user.png"))
            slComposerSheet.addURL(NSURL(string: "http://www.facebook.com/"))
            self.presentViewController(slComposerSheet, animated: true, completion: nil)
            
            slComposerSheet.completionHandler = { (result: SLComposeViewControllerResult) in
                if result == .Done {
                    var alertView: UIAlertView = UIAlertView(title: "", message: "分享完成", delegate: nil, cancelButtonTitle: "确定")
                    alertView.show()
                }
            }
        })
        
        // 显示Sheet
        self.presentViewController(actionSheetController, animated: true, completion: nil)

        
    }
}
