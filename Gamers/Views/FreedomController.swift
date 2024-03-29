//
//  FreedomController.swift
//  Gamers
//
//  Created by 虚空之翼 on 15/8/5.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

import UIKit
import SDCycleScrollView
import MJRefresh
import Bolts
import MBProgressHUD
import Social

class FreedomController: UITableViewController {
    let userDefaults = NSUserDefaults.standardUserDefaults()        //用户全局登入信息
    // 轮播视图属性
    var cycleScrollView: SDCycleScrollView!
    var cycleTitles: [String] = []
    var cycleImagesURLStrings: [String] = [];
    
    var videoListData  = [Video]()  //视频列表
    var pageToken = ""         //分页偏移量，默认为上次最后一个视频ID
    var maxResults = 20         //每页视频总数
    
    var videoPageOffset = 0
    var videoPageCount = 20
    
    var isNoMoreData: Bool = false  //解决控件不能自己判断BUG
    
    let freedomChannelId = "88f8111b-6b69-415a-af5d-f68b4118f43a"  //freedom的ID
    let freedomChannels = "UCoXRFunEMD4Bzec_3yK7NTQ"

    override func viewDidLoad() {
        super.viewDidLoad()

        // 上拉下拉刷新功能
        self.tableView.header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: "loadNewData")
        self.tableView.footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: "loadMoreData")
        
//        // 顶部轮播
//        cycleScrollView = SDCycleScrollView(frame: CGRectMake(0, 0, self.view.frame.width, 160), imagesGroup: nil)
//        //cycleScrollView.backgroundColor = UIColor.grayColor()
//        // 轮播视图的基本属性
//        cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight
//        cycleScrollView.infiniteLoop = true;
//        cycleScrollView.delegate = self
//        cycleScrollView.dotColor = UIColor.yellowColor() // 自定义分页控件小圆标颜色
//        cycleScrollView.autoScrollTimeInterval = 4.0
//        cycleScrollView.placeholderImage = UIImage(named: "placeholder.png")
//        self.tableView.tableHeaderView = cycleScrollView
        
        // 头部使用图片
        //let headerView = UIImageView(frame: CGRectMake(0, 0, self.view.frame.width, 160))
        //headerView.image = UIImage(named: "gamers_header.jpg")
        //self.tableView.tableHeaderView = headerView

        // 加载初始化数据
        loadInitData()

        
        
        
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

    }
    
    override func viewWillAppear(animated: Bool) {
        // 播放页面返回后，重置导航条的透明属性，//todo:image_1.jpg需求更换下
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "image_1.jpg"),forBarMetrics: UIBarMetrics.CompactPrompt)
        self.navigationController?.navigationBar.shadowImage = UIImage(named: "image_1.jpg")
        self.navigationController?.navigationBar.translucent = false
    }
    
    /**
    延迟函数，delay(seconds: 3.0, completion: {  })
    */
    func delay(#seconds: Double, completion:()->()) {
        let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64( Double(NSEC_PER_SEC) * seconds ))
        
        dispatch_after(popTime, dispatch_get_main_queue()) {
            completion()
        }
    }
    

    /**
    启动初始化数据
    */
    func loadInitData() {
        let hub = MBProgressHUD.showHUDAddedTo(self.navigationController!.view, animated: true)
        hub.labelText = NSLocalizedString("Loading...", comment: "加載中...")
        
//        VideoBL.sharedSingleton.getChannelVideos(channelId: freedomChannels, pageToken: pageToken, maxResults: maxResults, order: "date", videoDefinition: "high").continueWithSuccessBlock({ [weak self] (task: BFTask!) -> BFTask! in
//            self!.videoListData = (task.result as? [YTVideo])!
//            if !self!.videoListData.isEmpty {
//                self?.tableView.reloadData()
//                if self!.videoListData.last!.nextPageToken == "" {
//                    self?.tableView.footer.noticeNoMoreData()
//                    self!.isNoMoreData = true
//                } else {
//                    self!.pageToken = self!.videoListData.last!.nextPageToken
//                }
//            }
//            return nil
//        }).continueWithBlock({ [weak self] (task: BFTask!) -> BFTask! in
//            if task.error != nil { println(task.error) }
//            MBProgressHUD.hideHUDForView(self!.navigationController!.view, animated: true)
//
//            return nil
//        })


        ChannelBL.sharedSingleton.getChannelVideo(channelId: freedomChannelId, offset: videoPageOffset, count: videoPageCount, channels: freedomChannels).continueWithSuccessBlock({ [weak self] (task: BFTask!) -> BFTask! in
            self!.videoListData = (task.result as? [Video])!
            self!.videoPageOffset += 1
            self?.tableView.reloadData()
            
            if self!.videoListData.count < self!.videoPageCount {
                self?.tableView.footer.noticeNoMoreData()
            }
            //println(self!.videoListData)
            return nil
        }).continueWithBlock({ [weak self] (task: BFTask!) -> BFTask! in
            if task.error != nil { println(task.error) }
            MBProgressHUD.hideHUDForView(self!.navigationController!.view, animated: true)
            
            return nil
        })

//        SliderBL.sharedSingleton.getChannelSlider(channelId: freedomChannelId).continueWithSuccessBlock({ [weak self] (task: BFTask!) -> BFTask! in
//            if let sliders = task.result as? [Slider] {
//                for slider in sliders {
//                    self!.cycleTitles.append(slider.title)
//                    self!.cycleImagesURLStrings.append(slider.imageSmall)
//                }
//            }
//            self!.cycleScrollView.titlesGroup = self!.cycleTitles
//            self!.cycleScrollView.imageURLStringsGroup = self!.cycleImagesURLStrings
//            self!.cycleTitles = []
//            self!.cycleImagesURLStrings = []
//
//            return nil
//        }).continueWithBlock({ [weak self] (task: BFTask!) -> BFTask! in
//            if task.error != nil {
//                println(task.error)
//            }
//            
//            MBProgressHUD.hideHUDForView(self!.navigationController!.view, animated: true)
//            
//            return nil
//        })

    }
    
    /**
    刷新数据
    */
    func loadNewData() {
//        pageToken = ""
//        isNoMoreData = false
//        VideoBL.sharedSingleton.getChannelVideos(channelId: freedomChannels, pageToken: pageToken, maxResults: maxResults, order: "date", videoDefinition: "high").continueWithSuccessBlock({ [weak self] (task: BFTask!) -> BFTask! in
//            self!.videoListData = (task.result as? [YTVideo])!
//            if !self!.videoListData.isEmpty {
//                self?.tableView.reloadData()
//                if self!.videoListData.last!.nextPageToken == "" {
//                    self?.tableView.footer.noticeNoMoreData()
//                    self!.isNoMoreData = true
//                } else {
//                    self!.pageToken = self!.videoListData.last!.nextPageToken
//                }
//            }
//
//            return nil
//        }).continueWithBlock({ [weak self] (task: BFTask!) -> BFTask! in
//            if task.error != nil { println(task.error) }
//            self?.tableView.header.endRefreshing()
//            if !self!.isNoMoreData {
//                self?.tableView.footer.endRefreshing()
//            }
//            
//            return nil
//        })
        
        videoPageOffset = 1
        ChannelBL.sharedSingleton.getChannelVideo(channelId: freedomChannelId, offset: videoPageOffset, count: videoPageCount, channels: freedomChannels).continueWithSuccessBlock({ [weak self] (task: BFTask!) -> BFTask! in
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

//        SliderBL.sharedSingleton.getChannelSlider(channelId: freedomChannelId).continueWithSuccessBlock({ [weak self] (task: BFTask!) -> BFTask! in
//            if let sliders = task.result as? [Slider] {
//                for slider in sliders {
//                    self!.cycleTitles.append(slider.title)
//                    self!.cycleImagesURLStrings.append(slider.imageSmall)
//                }
//            }
//            self!.cycleScrollView.titlesGroup = self!.cycleTitles
//            self!.cycleScrollView.imageURLStringsGroup = self!.cycleImagesURLStrings
//            self!.cycleTitles = []
//            self!.cycleImagesURLStrings = []
//            
//            return nil
//        }).continueWithBlock({ [weak self] (task: BFTask!) -> BFTask! in
//            if task.error != nil {
//                println(task.error)
//            }
//            
//            // 所有获取完后结束刷新动画
//            self!.stopRefensh()
//            
//            return nil
//        })
        
    }
    
    /**
    加载更多数据
    */
    func loadMoreData() {
//        VideoBL.sharedSingleton.getChannelVideos(channelId: freedomChannels, pageToken: pageToken, maxResults: maxResults, order: "date", videoDefinition: "high").continueWithSuccessBlock({ [weak self] (task: BFTask!) -> BFTask! in
//            let newData = (task.result as? [YTVideo])!
//            
//            if newData.isEmpty {
//                self?.tableView.footer.noticeNoMoreData()
//                self!.isNoMoreData = true
//            } else{
//                self!.videoListData += newData
//                
//                if newData.last!.nextPageToken == "" {
//                    self?.tableView.footer.noticeNoMoreData()
//                    self!.isNoMoreData = true
//                } else {
//                    self!.pageToken = self!.videoListData.last!.nextPageToken
//                }
//                
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
        
        ChannelBL.sharedSingleton.getChannelVideo(channelId: freedomChannelId, offset: videoPageOffset, count: videoPageCount, channels: freedomChannels).continueWithSuccessBlock({ [weak self] (task: BFTask!) -> BFTask! in
            let newData = (task.result as? [Video])!
            
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
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "FreedomPlayerSegue" {
            // 定义列表控制器
            var playerViewController = segue.destinationViewController as! PlayerViewController
            // 提取选中的游戏视频，把值传给列表页面
            var indexPath = self.tableView.indexPathForSelectedRow()!
            playerViewController.videoData =  videoListData[indexPath.row]
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

// MARK: - 表格代理协议
extension FreedomController: UITableViewDataSource, UITableViewDelegate {
    // 表格分区
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    // 表格行数
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if videoListData.isEmpty {
            return 1
        } else {
            return videoListData.count
        }
    }
    // 设置单元格
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if videoListData.isEmpty {
            // 没有数据时候显示提醒
            let cell = tableView.dequeueReusableCellWithIdentifier("FreedomNoDataCell", forIndexPath: indexPath) as! UITableViewCell
            cell.selectionStyle = UITableViewCellSelectionStyle.None        //不可选
            
            tableView.separatorStyle = UITableViewCellSeparatorStyle.None   //删除下划线
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("FreedomCell", forIndexPath: indexPath) as! VideoListCell
            cell.setVideo(self.videoListData[indexPath.row])
            cell.delegate = self
            
            tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
            
            return cell
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
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if videoListData.isEmpty {
            return view.frame.size.height - 20 - 44 - 160
        } else {
            return 100
        }
    }

}

// MARK: - 顶部轮播的代理方法
extension FreedomController: SDCycleScrollViewDelegate {
    func cycleScrollView(cycleScrollView: SDCycleScrollView!, didSelectItemAtIndex index: Int) {
        var view = self.storyboard!.instantiateViewControllerWithIdentifier("SliderVC") as? SliderController
        self.navigationController?.pushViewController(view!, animated: true)
    }
}

// MARK: - 表格行Cell代理
extension FreedomController: MyCellDelegate {
    // 分享按钮
    func clickCellButton(sender: UITableViewCell) {
        var index: NSIndexPath = self.tableView.indexPathForCell(sender)!
        var video = self.videoListData[index.row]
        
        // 退出
        var actionSheetController: UIAlertController = UIAlertController()
        actionSheetController.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "取消"), style: UIAlertActionStyle.Cancel) { (alertAction) -> Void in
            //code
        })
//        // 关注频道
//        actionSheetController.addAction(UIAlertAction(title: "追隨", style: UIAlertActionStyle.Destructive) { (alertAction) -> Void in
//            if self.userDefaults.boolForKey("isLogin") {
//                UserBL.sharedSingleton.setFollow(channelId: self.freedomChannelId)
//            } else {
//                var alertView: UIAlertView = UIAlertView(title: "", message: "请先登入", delegate: nil, cancelButtonTitle: "确定")
//                alertView.show()
//            }
//        })
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
