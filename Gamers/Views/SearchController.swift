//
//  SeachController.swift
//  Gamers
//
//  Created by 虚空之翼 on 15/7/20.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

import UIKit
import MJRefresh
import Bolts
import MBProgressHUD
import Social

class SearchController: UITableViewController, UITableViewDataSource, UITableViewDelegate {
    
    var searchContentView: UIView!
    var searchBackgroundView: UIView!
    var autocompleteView: UITableView!
    var searchBarView: UIView!
    var searchBar: UISearchBar!
    var tapGesture: UITapGestureRecognizer!
    
    // 搜索变量
    var videoListData = [Video]()
    var videoPageOffset = 0
    var videoPageCount = 20
    var order = "date"
    var keyword = ""
    
    var isNoMoreData: Bool = false  //解决控件不能自己判断BUG
    
    // 下拉刷新数据
    func loadNewData() {
        keyword = searchBar.text
        videoPageOffset = 0
        
        VideoBL.sharedSingleton.getSearchVideo(keyword: keyword, offset: videoPageOffset, count: videoPageCount, order: order).continueWithSuccessBlock({ [weak self] (task: BFTask!) -> BFTask! in
            self!.videoListData = (task.result as? [Video])!
            self!.videoPageOffset += self!.videoPageCount
            self!.tableView.reloadData()
            
            if self!.videoListData.count < self!.videoPageCount {
                self?.tableView.footer.noticeNoMoreData()
            } else {
                self?.tableView.footer.resetNoMoreData()
            }
            
            return nil
        }).continueWithBlock({ [weak self] (task: BFTask!) -> BFTask! in
            self?.tableView.header.endRefreshing()
            self!.isNoMoreData = false
            
            return nil
        })
    }
    // 上拉获取更多数据
    func loadMoreData() {
        keyword = searchBar.text
        VideoBL.sharedSingleton.getSearchVideo(keyword: keyword, offset: videoPageOffset, count: videoPageCount, order: order).continueWithSuccessBlock({ [weak self] (task: BFTask!) -> BFTask! in
            var newData = (task.result as? [Video])!
            if newData.isEmpty {
                self?.tableView.footer.noticeNoMoreData()
                self!.isNoMoreData = true
            } else {
                if newData.count < self!.videoPageCount {
                    self!.isNoMoreData = true
                }
                
                self!.videoListData += newData
                self!.videoPageOffset += self!.videoPageCount
                self!.tableView.reloadData()
            }

            return nil
        }).continueWithBlock({ [weak self] (task: BFTask!) -> BFTask! in
            if !self!.isNoMoreData {
                self?.tableView.footer.endRefreshing()
            }

            return nil
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 上拉下拉刷新功能
        self.tableView.header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: "loadNewData")
        self.tableView.footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: "loadMoreData")
        
        
        // 导航栏添加搜索框
        searchBarView = UIView(frame: CGRectMake(45, 0, self.view.frame.size.width, 44))
        searchBarView.backgroundColor = UIColor.whiteColor()
        
        searchBar = UISearchBar(frame: CGRectMake(0, 0, self.view.frame.size.width-85, 44))
        searchBar.searchBarStyle = UISearchBarStyle.Minimal
        searchBar.tintColor = self.navigationController?.navigationBar.barTintColor
        searchBar.showsBookmarkButton = false
        //searchBar.showsCancelButton = true
        searchBar.delegate = self
        searchBar.tag = 601
        //searchBar.becomeFirstResponder()
        searchBarView.addSubview(searchBar)
        

        //self.navigationController?.view.addSubview(searchBarView)
        self.navigationItem.titleView = searchBarView
        self.navigationItem.titleView?.sizeToFit()

        // autocomplete 界面
        searchContentView = UIView(frame: CGRectMake(0, 64, self.view.frame.size.width, 160))
        searchContentView.backgroundColor = UIColor.whiteColor()
        searchContentView.layer.borderWidth = 1
        searchContentView.layer.borderColor = UIColor.grayColor().CGColor

        
        autocompleteView = UITableView(frame: CGRectMake(0, 0, self.view.frame.size.width, 160))
        autocompleteView.delegate = self
        autocompleteView.dataSource = self
        autocompleteView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "autocompleteCell")
        searchContentView.addSubview(autocompleteView)
        
        
        // 灰色背景
        searchBackgroundView = UIView(frame: CGRectMake(0, 224, self.view.frame.size.width, self.view.frame.size.height-224))
        searchBackgroundView.backgroundColor = UIColor.grayColor()
        searchBackgroundView.alpha = 0.7
        
        // TODO: 搜索关键字自动查询
        //self.navigationController?.view.addSubview(searchContentView)
        //self.navigationController?.view.addSubview(searchBackgroundView)
        // 默认隐藏搜索界面
        searchContentView.hidden = true
        searchBackgroundView.hidden = true
        
        // 设置tableview顶部不在导航栏下
        self.edgesForExtendedLayout = UIRectEdge.None
        // 隐藏底部工具栏
        //self.tabBarController!.tabBar.hidden = true
        
//        UIView.animateWithDuration(1, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
//           searchContentView.frame.size.height = 224
//            
//        }, completion: nil)
        
        
        
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
        if autocompleteView.respondsToSelector("setSeparatorInset:") {
            autocompleteView.separatorInset = UIEdgeInsetsMake(0, 5, 0, 5)
        }
        if autocompleteView.respondsToSelector("setLayoutMargins:") {
            autocompleteView.layoutMargins = UIEdgeInsetsMake(0, 5, 0, 5)
        }

    }

    // 卸载界面
    override func viewWillDisappear(animated: Bool) {
        // 返回等切换页面，删除搜索界面
        searchContentView.removeFromSuperview()
        searchBackgroundView.removeFromSuperview()
    }

    // 跳转传值
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // 定义列表控制器
        var playerViewController = segue.destinationViewController as! PlayerViewController
        // 提取选中的游戏视频，把值传给列表页面
        var indexPath = self.tableView.indexPathForSelectedRow()!
        playerViewController.videoData =  videoListData[indexPath.row]
    }
    

    
    override func viewWillAppear(animated: Bool) {
        // 播放页面返回后，重置导航条的透明属性，//todo:image_1.jpg需求更换下
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "image_1.jpg"),forBarMetrics: UIBarMetrics.CompactPrompt)
        self.navigationController?.navigationBar.shadowImage = UIImage(named: "image_1.jpg")
        self.navigationController?.navigationBar.translucent = false
    }
    
    override func dismissViewControllerAnimated(flag: Bool, completion: (() -> Void)?) {
        searchBar.resignFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
}
// MARK: - 表格代理协议
extension SearchController: UITableViewDataSource, UITableViewDelegate {
    
    // 表格行高度
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch tableView {
        case autocompleteView:
            return 32
        default:
            if videoListData.isEmpty {
                return view.frame.size.height
            } else {
                return 100
            }
        }
    }
    // 行数
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if videoListData.isEmpty {
            return 1
        } else {
            return videoListData.count
        }
    }
    // 单元格内容
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch tableView {
        case autocompleteView:
            let cell = tableView.dequeueReusableCellWithIdentifier("autocompleteCell", forIndexPath: indexPath) as! UITableViewCell
            
            return cell
        default:
            if videoListData.isEmpty {
                var cell = tableView.dequeueReusableCellWithIdentifier("SearchVideoNoDataCell", forIndexPath: indexPath) as! UITableViewCell
                
                return cell
            } else {
                var cell = tableView.dequeueReusableCellWithIdentifier("SearchCell", forIndexPath: indexPath) as! SearchCell
                cell.setVideo(self.videoListData[indexPath.row])
                cell.delegate = self
                
                return cell
            }

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

// MARK: - 搜索代理
extension SearchController: UISearchBarDelegate {
    // 第一响应者时触发
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        // 显示搜索界面
        searchContentView.hidden  = false
        searchBackgroundView.hidden = false
        
        //self.tableView.addGestureRecognizer(tapGesture)
        
        return true
    }
    // 点击搜索
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        let hub = MBProgressHUD.showHUDAddedTo(self.navigationController!.view, animated: true)
        hub.labelText = "加载中..."
        
        keyword = searchBar.text
        videoPageOffset = 0
        
        VideoBL.sharedSingleton.getSearchVideo(keyword: keyword, offset: videoPageOffset, count: videoPageCount, order: order).continueWithSuccessBlock({ [weak self] (task: BFTask!) -> BFTask! in
            self!.videoListData = (task.result as? [Video])!
            self!.videoPageOffset += self!.videoPageCount
            self!.tableView.reloadData()
            
            if self!.videoListData.count < self!.videoPageCount {
                self?.tableView.footer.noticeNoMoreData()
            } else {
                self?.tableView.footer.resetNoMoreData()
            }

            return nil
        }).continueWithBlock({ [weak self] (task: BFTask!) -> BFTask! in
            //self?.tableView.footer.endRefreshing()
            MBProgressHUD.hideHUDForView(self!.navigationController!.view, animated: true)
            
            return nil
        })
        
        // 隐藏搜索界面
        searchContentView.hidden  = true
        searchBackgroundView.hidden = true
        // 搜索提交后，收起键盘
        searchBar.resignFirstResponder()
    }
    // 点击取消时触发事件
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        //println("canncel")
        
    }
    // 搜索内容发生变化时触发事件
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        // 显示搜索界面
        searchContentView.hidden  = false
        searchBackgroundView.hidden = false
    }
    // 搜索范围标签变化时
    func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {

    }
    
}

// MARK: - 表格行Cell代理
extension SearchController: MyCellDelegate {
    // 隐藏键盘
    func hideKeyboard(cell: UITableViewCell) {
        searchBar.resignFirstResponder()
    }
    // 分享按钮
    func clickCellButton(sender: UITableViewCell) {
        var index: NSIndexPath = self.tableView.indexPathForCell(sender)!
        //println("表格行：\(index.row)")
        
        var video = self.videoListData[index.row]
        // 退出
        var actionSheetController: UIAlertController = UIAlertController()
        actionSheetController.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel) { (alertAction) -> Void in
            //code
        })
        // 关注频道
        actionSheetController.addAction(UIAlertAction(title: "跟随", style: UIAlertActionStyle.Destructive) { (alertAction) -> Void in
            if NSUserDefaults.standardUserDefaults().boolForKey("isLogin") {
                UserBL.sharedSingleton.setFollow(channelId: video.ownerId)
            } else {
                var alertView: UIAlertView = UIAlertView(title: "", message: "请先登入", delegate: nil, cancelButtonTitle: "确定")
                alertView.show()
            }
        })
        // 分享到Facebook
        actionSheetController.addAction(UIAlertAction(title: "分享到Facebook", style: UIAlertActionStyle.Default) { (alertAction) -> Void in
            var slComposerSheet = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            slComposerSheet.setInitialText(video.videoTitle)
            slComposerSheet.addImage(UIImage(named: video.imageSource))
            slComposerSheet.addURL(NSURL(string: "https://www.youtube.com/watch?v=\(video.videoId)"))
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
            slComposerSheet.setInitialText(video.videoTitle)
            slComposerSheet.addImage(UIImage(named: video.imageSource))
            slComposerSheet.addURL(NSURL(string: "https://www.youtube.com/watch?v=\(video.videoId)"))
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



