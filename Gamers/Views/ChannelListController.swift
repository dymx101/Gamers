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
import Social

class ChannelListController: UITableViewController {

    var videoListData = [Video]()
    var channelType: String = "new"
    var videoPageOffset = 1         //分页偏移量
    var videoPageCount = 9         //每页视频总数
    
    var isNoMoreData: Bool = false  //解决控件不能自己判断BUG
    let userDefaults = NSUserDefaults.standardUserDefaults()    //用户全局登入信息
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = NSLocalizedString("Featured youtuber", comment: "")

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
        
        // 初始化数据
        loadInitData()
        

    }
    
    /**
    启动初始化数据
    */
    func loadInitData() {
        let hub = MBProgressHUD.showHUDAddedTo(self.navigationController!.view, animated: true)
        hub.labelText = NSLocalizedString("Loading...", comment: "加載中...")
        
        ChannelBL.sharedSingleton.getRecommendChannel(channelType: channelType, offset: videoPageOffset, count: videoPageCount, order: "date").continueWithSuccessBlock({ [weak self] (task: BFTask!) -> BFTask! in
            self!.videoListData = (task.result as? [Video])!
            self!.videoPageOffset += 1
            self?.tableView.reloadData()
            
//            if self!.videoListData.count < self!.videoPageCount {
//                self?.tableView.footer.noticeNoMoreData()
//            }

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
        ChannelBL.sharedSingleton.getRecommendChannel(channelType: channelType, offset: videoPageOffset, count: videoPageCount, order: "date").continueWithSuccessBlock({ [weak self] (task: BFTask!) -> BFTask! in
            self!.videoListData = (task.result as? [Video])!
            self!.videoPageOffset += 1
            self?.tableView.reloadData()
            
//            if self!.videoListData.count < self!.videoPageCount {
//                self?.tableView.footer.noticeNoMoreData()
//            } else {
//                self?.tableView.footer.resetNoMoreData()
//            }
            
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
//    func loadMoreData() {
//        ChannelBL.sharedSingleton.getRecommendChannel(channelType: channelType, offset: videoPageOffset, count: videoPageCount, order: "date").continueWithSuccessBlock({ [weak self] (task: BFTask!) -> BFTask! in
//            var newData = (task.result as? [Video])!
//            if newData.isEmpty {
//                self?.tableView.footer.noticeNoMoreData()
//                self!.isNoMoreData = true
//            } else {
//                if newData.count < self!.videoPageCount {
//                    self!.isNoMoreData = true
//                }
//                
//                self!.videoListData += newData
//                self!.videoPageOffset += 1
//                self?.tableView.reloadData()
//            }
//
//            return nil
//        }).continueWithBlock({ [weak self] (task: BFTask!) -> BFTask! in
//            if task.error != nil { println(task.error) }
//            if !self!.isNoMoreData {
//                self?.tableView.footer.endRefreshing()
//            }
//            
//            return nil
//        })
//        
//    }
    
    override func viewWillAppear(animated: Bool) {
        // 播放页面返回后，重置导航条的透明属性，//todo:image_1.jpg需求更换下
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "navigation-bar1.png"),forBarMetrics: UIBarMetrics.CompactPrompt)
        self.navigationController?.navigationBar.shadowImage = UIImage(named: "navigation-bar1.png")
        self.navigationController?.navigationBar.translucent = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

// MARK: - 表格代理协议
extension ChannelListController: UITableViewDataSource, UITableViewDelegate {
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videoListData.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ChannelListCell", forIndexPath: indexPath) as! VideoListCell
        cell.setVideo(videoListData[indexPath.row])
        cell.delegate = self
        
        return cell
    }
    
    // 跳转传值
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // 定义列表控制器
        var playerViewController = segue.destinationViewController as! PlayerViewController
        // 提取选中的游戏视频，把值传给列表页面
        var indexPath = self.tableView.indexPathForSelectedRow()!
        playerViewController.videoData =  videoListData[indexPath.row]
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
extension ChannelListController: MyCellDelegate {
    // 分享按钮
    func clickCellButton(sender: UITableViewCell) {
        var index: NSIndexPath = self.tableView.indexPathForCell(sender)!
        var video = self.videoListData[index.row]
        
        // 退出
        var actionSheetController: UIAlertController = UIAlertController()
        actionSheetController.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "取消"), style: UIAlertActionStyle.Cancel) { (alertAction) -> Void in
            //code
        })
        // 关注频道
        actionSheetController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "确定"), style: UIAlertActionStyle.Destructive) { (alertAction) -> Void in
            if self.userDefaults.boolForKey("isLogin") {
                UserBL.sharedSingleton.setFollow(channelId: video.ownerId)
            } else {
                var alertView: UIAlertView = UIAlertView(title: "", message: NSLocalizedString("Please Login", comment: "请先登入"), delegate: nil, cancelButtonTitle: NSLocalizedString("OK", comment: "确定"))
                alertView.show()
            }
        })
        // 分享到Facebook
        actionSheetController.addAction(UIAlertAction(title: NSLocalizedString("Share on Facebook", comment: "分享到Facebook"), style: UIAlertActionStyle.Default) { (alertAction) -> Void in
            var slComposerSheet = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            slComposerSheet.setInitialText(video.videoTitle)
            slComposerSheet.addImage(UIImage(named: video.imageSource))
            slComposerSheet.addURL(NSURL(string: "https://www.youtube.com/watch?v=\(video.videoId)"))
            self.presentViewController(slComposerSheet, animated: true, completion: nil)
            SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook)
            
            slComposerSheet.completionHandler = { (result: SLComposeViewControllerResult) in
                if result == .Done {
                    var alertView: UIAlertView = UIAlertView(title: "", message: NSLocalizedString("Share Finish", comment: "分享完成"), delegate: nil, cancelButtonTitle: NSLocalizedString("OK", comment: "确定"))
                    alertView.show()
                }
            }
        })
        // 分享到Twitter
        actionSheetController.addAction(UIAlertAction(title: NSLocalizedString("Share on Twitter", comment: "分享到Twitter"), style: UIAlertActionStyle.Default) { (alertAction) -> Void in
            var slComposerSheet = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            slComposerSheet.setInitialText(video.videoTitle)
            slComposerSheet.addImage(UIImage(named: video.imageSource))
            slComposerSheet.addURL(NSURL(string: "https://www.youtube.com/watch?v=\(video.videoId)"))
            self.presentViewController(slComposerSheet, animated: true, completion: nil)
            
            slComposerSheet.completionHandler = { (result: SLComposeViewControllerResult) in
                if result == .Done {
                    var alertView: UIAlertView = UIAlertView(title: "", message: NSLocalizedString("Share Finish", comment: "分享完成"), delegate: nil, cancelButtonTitle: NSLocalizedString("OK", comment: "确定"))
                    alertView.show()
                }
            }
        })
        
        // 显示Sheet
        self.presentViewController(actionSheetController, animated: true, completion: nil)
        
        
    }
}
