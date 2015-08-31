//
//  UserFollowController.swift
//  Gamers
//
//  Created by 虚空之翼 on 15/8/6.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

import UIKit
import MJRefresh
import Bolts
import MBProgressHUD

class UserFollowController: UITableViewController {

    var userListData = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 上拉下拉刷新功能
        self.tableView.header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: "loadNewData")
        //self.tableView.footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: "loadMoreData")

        // 删除多余的分割线
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        // cell分割线边距，ios8处理
        if self.tableView.respondsToSelector("setSeparatorInset:") {
            self.tableView.separatorInset = UIEdgeInsetsMake(0, 5, 0, 5)
        }
        if self.tableView.respondsToSelector("setLayoutMargins:") {
            self.tableView.layoutMargins = UIEdgeInsetsMake(0, 5, 0, 5)
        }
        

        // 加载数据
        loadInitData()
        
        //self.tableView.editing = true
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true

        
    }

    
    // 初始化数据
    func loadInitData() {
        let hub = MBProgressHUD.showHUDAddedTo(self.navigationController!.view, animated: true)
        hub.labelText = "加载中..."
        UserBL.sharedSingleton.getSubscriptions(userToken: "").continueWithSuccessBlock({ [weak self] (task: BFTask!) -> BFTask! in
            self!.userListData = (task.result as? [User])!
            self?.tableView.reloadData()
            
            return nil
        }).continueWithBlock({ [weak self] (task: BFTask!) -> BFTask! in
            MBProgressHUD.hideHUDForView(self!.navigationController!.view, animated: true)
            
            return nil
        })
        
    }
    // 下拉刷新数据
    func loadNewData() {
        UserBL.sharedSingleton.getSubscriptions(userToken: "").continueWithSuccessBlock({ [weak self] (task: BFTask!) -> BFTask! in
            self!.userListData = (task.result as? [User])!
            self?.tableView.reloadData()
            
            return nil
        }).continueWithBlock({ [weak self] (task: BFTask!) -> BFTask! in
            self?.tableView.header.endRefreshing()
            
            return nil
        })
    }
    
    
    // 上拉获取更多数据
    func loadMoreData() {
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var channelVideoVC = segue.destinationViewController as! ChannelVideoController
        var cell = sender as! UITableViewCell
        var indexPath = self.tableView.indexPathForCell(cell)!

        channelVideoVC.userData = self.userListData[indexPath.row]
    }
    
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
// MARK: - Table view data source
extension UserFollowController: UITableViewDataSource, UITableViewDelegate {
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    // 设置总行数
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userListData.count
    }
    // 设置表格行内容
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UserFollowCell", forIndexPath: indexPath) as! UserFollowCell
        cell.setUserData(self.userListData[indexPath.row])

        cell.delegate = self
        
        return cell
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
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        var indexPaths = [indexPath]
        if editingStyle == UITableViewCellEditingStyle.Delete {
            self.userListData.removeAtIndex(indexPath.row) //删除数据要先执行，再删除表格行
            tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Automatic)
            
            UserBL.sharedSingleton.setUnFollow(channelId: self.userListData[indexPath.row].userId)
        }
        
        //self.tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String! {
        return "取消跟随"
    }
}

// MARK: 表格行Cell代理
extension UserFollowController: ChannelCellDelegate {
    
    func clickCellUnFollow(cell: UITableViewCell) {
        var index: NSIndexPath = self.tableView.indexPathForCell(cell)!
        
        println("表格行：\(index.row)")
        
        var actionSheetController: UIAlertController = UIAlertController(title: "", message: "是否取消跟随", preferredStyle: UIAlertControllerStyle.Alert)
        actionSheetController.addAction(UIAlertAction(title: "否", style: UIAlertActionStyle.Cancel, handler: { (alertAction) -> Void in
            //
        }))
        actionSheetController.addAction(UIAlertAction(title: "是", style: UIAlertActionStyle.Default, handler: { (alertAction) -> Void in
            //
            UserBL.sharedSingleton.setUnFollow(channelId: self.userListData[index.row].userId)
        }))
        
        
        // 显示Sheet
        self.presentViewController(actionSheetController, animated: true, completion: nil)
        
    }
    
    

}





