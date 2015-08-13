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

class SearchController: UITableViewController, UITableViewDataSource, UITableViewDelegate  {
    
    var searchContentView: UIView!
    var searchBackgroundView: UIView!
    var autocompleteView: UITableView!
    var searchBarView: UIView!
    var searchBar: UISearchBar!
    var tapGesture: UITapGestureRecognizer!
    
    let videoBL = VideoBL()

    var keyword = ""
    var offset = 0
    var count = 20
    var order = "date"
    var videoData = [Video]()
    // 下拉刷新数据
    func loadNewData() {
        keyword = searchBar.text
        offset = 0
        
        videoBL.getSearchVideo(keyword: keyword, offset: offset, count: count, order: order).continueWithSuccessBlock({ [weak self] (task: BFTask!) -> BFTask! in
            self!.videoData = (task.result as? [Video])!
            self!.tableView.reloadData()
            self?.tableView.header.endRefreshing()
            self?.tableView.footer.resetNoMoreData()
            
            return nil
        })
    }
    // 上拉获取更多数据
    func loadMoreData() {
        keyword = searchBar.text
        offset = offset + count
        
        videoBL.getSearchVideo(keyword: keyword, offset: offset, count: count, order: order).continueWithSuccessBlock({ [weak self] (task: BFTask!) -> BFTask! in
            var newData = (task.result as? [Video])!
            if newData.isEmpty {
                self?.tableView.footer.noticeNoMoreData()
            } else {
                self!.videoData = self!.videoData + newData
                self!.tableView.reloadData()
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }

    // MARK: 表格代理协议
    // 分区
//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        return 1
//    }
    // 表格行高度
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch tableView {
        case autocompleteView:
            return 32
        default:
            return 100
        }
    }
    // 行数
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videoData.count
    }
    // 单元格内容
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //
        
        switch tableView {
        case autocompleteView:
            let cell = tableView.dequeueReusableCellWithIdentifier("autocompleteCell", forIndexPath: indexPath) as! UITableViewCell
            
            return cell
        default:
            var cell = tableView.dequeueReusableCellWithIdentifier("SearchCell", forIndexPath: indexPath) as! SearchCell
            
            cell.videoTitle.text = self.videoData[indexPath.row].videoTitle
            cell.videoChannel.text = self.videoData[indexPath.row].owner
            cell.videoViews.text = String(self.videoData[indexPath.row].views)
            
            let imageUrl = self.videoData[indexPath.row].imageSource.stringByReplacingOccurrencesOfString(" ", withString: "%20", options: NSStringCompareOptions.LiteralSearch, range: nil)
            cell.videoImage.kf_setImageWithURL(NSURL(string: imageUrl)!)

            cell.delegate = self
            
            return cell
            
        }


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
    
    override func viewWillAppear(animated: Bool) {
        // 播放页面返回后，重置导航条的透明属性，//todo:image_1.jpg需求更换下
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "image_1.jpg"),forBarMetrics: UIBarMetrics.CompactPrompt)
        self.navigationController?.navigationBar.shadowImage = UIImage(named: "image_1.jpg")
        self.navigationController?.navigationBar.translucent = false
    }
    
    override func dismissViewControllerAnimated(flag: Bool, completion: (() -> Void)?) {
        searchBar.resignFirstResponder()
    }
    
    
}

// MARK: 搜索代理
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
        keyword = searchBar.text
        
        videoBL.getSearchVideo(keyword: keyword, offset: offset, count: count, order: order).continueWithSuccessBlock({ [weak self] (task: BFTask!) -> BFTask! in
            self!.videoData = (task.result as? [Video])!
            self!.tableView.reloadData()

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
        println("canncel")
        
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
// 表格行Cell代理
extension SearchController: MyCellDelegate {
    // 隐藏键盘
    func hideKeyboard(cell: UITableViewCell) {
        searchBar.resignFirstResponder()
    }
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



