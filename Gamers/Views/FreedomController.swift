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

class FreedomController: UITableViewController, UITableViewDataSource, UITableViewDelegate {
    // 轮播视图属性
    var cycleScrollView: SDCycleScrollView!
    var cycleTitles: [String] = []
    var cycleImagesURLStrings: [String] = [];
    
    let videoBL = VideoBL()
    let channelBL = ChannelBL()
    let sliderBL = SliderBL()
    
    var videoListData  = [Video]()  //视频列表
    var videoPageOffset = ""        //分页偏移量，默认为上次最后一个视频ID
    var videoPageCount = 20         //每页视频总数
    
    var refresh = 0     // 刷新数据计数
    let channelId = "freedom"  //freedom的ID
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 上拉下拉刷新功能
        self.tableView.header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: "loadNewData")
        self.tableView.footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: "loadMoreData")
        
        // 顶部轮播
        cycleScrollView = SDCycleScrollView(frame: CGRectMake(0, 0, self.view.frame.width, 160), imagesGroup: nil)
        cycleScrollView.backgroundColor = UIColor.grayColor()
        // 轮播视图的基本属性
        cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight
        cycleScrollView.infiniteLoop = true;
        cycleScrollView.delegate = self
        cycleScrollView.dotColor = UIColor.yellowColor() // 自定义分页控件小圆标颜色
        cycleScrollView.autoScrollTimeInterval = 4.0
        cycleScrollView.placeholderImage = UIImage(named: "1.jgp")
        
        self.tableView.tableHeaderView = cycleScrollView

        // 加载初始化数据
        loadInitData()

        // 顶部图标
        //[navigationController.navigationBar setBackgroundImage: [UIImage imageNamed:@"banner.png"] forBarMetrics:UIBarMetricsDefault];
        //navigationController?.navigationBar.backgroundImageForBarMetrics(UIBarMetrics.Default)
//        let imageView = UIImage(named: "1.jpg")
//        let view = UIView(frame: CGRectMake(110, 6, 32, 32))
//        view.backgroundColor = UIColor.redColor()
        
        navigationController?.navigationBar.addSubview(view)
        
        
        
        
        
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
        hub.labelText = "加载中..."
        
        channelBL.getChannelVideo(channelId, offset: 0, count: videoPageCount).continueWithSuccessBlock({ [weak self] (task: BFTask!) -> BFTask! in
            self!.videoListData = (task.result as? [Video])!
            self?.tableView.reloadData()
            
            return nil
        })
        
        let sliderBL = SliderBL()
        sliderBL.getSliders(channel: "Home").continueWithSuccessBlock({ [weak self] (task: BFTask!) -> BFTask! in
            if let sliders = task.result as? [Slider] {
                for slider in sliders {
                    self!.cycleTitles.append(slider.title)
                    self!.cycleImagesURLStrings.append(slider.imageSmall)
                }
            }
            self!.cycleScrollView.titlesGroup = self!.cycleTitles
            self!.cycleScrollView.imageURLStringsGroup = self!.cycleImagesURLStrings
            self!.cycleTitles = []
            self!.cycleImagesURLStrings = [];
            
            MBProgressHUD.hideHUDForView(self!.navigationController!.view, animated: true)
            
            return nil
        })

    }
    
    /**
    刷新数据
    */
    func loadNewData() {
        channelBL.getChannelVideo(channelId, offset: 110, count: videoPageCount).continueWithSuccessBlock({ [weak self] (task: BFTask!) -> BFTask! in
            self!.videoListData = (task.result as? [Video])!
            
            self?.tableView.reloadData()
            
            // 所有获取完后结束刷新动画
            self!.refresh = self!.refresh + 1
            if self!.refresh == 2 { //self!.refresh++ == 2 不行？
                self?.tableView.header.endRefreshing()
                self!.refresh = 0
            }
            
            return nil
        })

        sliderBL.getSliders(channel: "freedoom").continueWithSuccessBlock({ [weak self] (task: BFTask!) -> BFTask! in
            if let sliders = task.result as? [Slider] {
                for slider in sliders {
                    self!.cycleTitles.append(slider.title)
                    self!.cycleImagesURLStrings.append(slider.imageSmall)
                }
            }
            self!.cycleScrollView.titlesGroup = self!.cycleTitles
            self!.cycleScrollView.imageURLStringsGroup = self!.cycleImagesURLStrings
            self!.cycleTitles = []
            self!.cycleImagesURLStrings = [];
            
            // 所有获取完后结束刷新动画
            self!.refresh = self!.refresh + 1
            if self!.refresh == 2 {
                self?.tableView.header.endRefreshing()
                self!.refresh = 0
            }
            
            return nil
        })
    }
    
    /**
    加载更多数据
    */
    func loadMoreData() {
        channelBL.getChannelVideo("freedoom", offset: 0, count: 20).continueWithSuccessBlock({ [weak self] (task: BFTask!) -> BFTask! in
            let newData = (task.result as? [Video])!
            
            // 如果没有数据显示加载完成，否则继续
            if newData.isEmpty {
                self?.tableView.footer.noticeNoMoreData()
            } else{
                self?.tableView.footer.endRefreshing()
                self!.videoListData += newData
                
                self?.tableView.reloadData()
            }

            return nil
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
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
            tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
            
            let imageUrl = self.videoListData[indexPath.row].imageSource.stringByReplacingOccurrencesOfString(" ", withString: "%20", options: NSStringCompareOptions.LiteralSearch, range: nil)
            cell.videoImage.kf_setImageWithURL(NSURL(string: imageUrl)!)
            cell.videoTitle.text = self.videoListData[indexPath.row].videoTitle
            cell.videoChannel.text = self.videoListData[indexPath.row].owner
            cell.videoViews.text = String(self.videoListData[indexPath.row].views)
            
            cell.delegate = self
            
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // 定义列表控制器
        var playerViewController = segue.destinationViewController as! PlayerViewController
        // 提取选中的游戏视频，把值传给列表页面
        var indexPath = self.tableView.indexPathForSelectedRow()!
        playerViewController.videoData =  videoListData[indexPath.row]
    }


}

// 顶部轮播的代理方法
extension FreedomController: SDCycleScrollViewDelegate {
    func cycleScrollView(cycleScrollView: SDCycleScrollView!, didSelectItemAtIndex index: Int) {
        NSLog("---点击了第%ld张图片", index);
        var view = self.storyboard!.instantiateViewControllerWithIdentifier("sliderView") as? SliderController
        self.navigationController?.pushViewController(view!, animated: true)
    }
}
// 表格行Cell代理
extension FreedomController: MyCellDelegate {
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
