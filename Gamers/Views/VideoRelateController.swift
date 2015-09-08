//
//  VideoRelateController.swift
//  Gamers
//
//  Created by 虚空之翼 on 15/8/3.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

import UIKit
import MJRefresh
import Bolts

class VideoRelateController: UITableViewController, UITableViewDataSource, UITableViewDelegate {

    var videoData: Video!
    var videoRelateData = [Video]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ChannelBL.sharedSingleton.getChannelVideo(channelId: videoData.ownerId, offset: 0, count: 20).continueWithSuccessBlock({ [weak self] (task: BFTask!) -> BFTask! in
            self!.videoRelateData = (task.result as? [Video])!
            self?.tableView.reloadData()
            
            return nil
        })
        
        
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    // 设置分区
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    // 设置表格行数
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return videoRelateData.count
    }

    // 设置单元格
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("VideoRelateCell", forIndexPath: indexPath) as! VideoRelateCell
        cell.setVideo(self.videoRelateData[indexPath.row])
        
        return cell
    }

    // 点击视频触发
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("选中了：\(indexPath.row)")

        var dataDict = ["data": videoRelateData[indexPath.row]]
        
        NSNotificationCenter.defaultCenter().postNotificationName("reloadPlayerViewNotification", object: nil, userInfo: dataDict)
        NSNotificationCenter.defaultCenter().postNotificationName("reloadVideoInfoNotification", object: nil, userInfo: dataDict)
        NSNotificationCenter.defaultCenter().postNotificationName("reloadVideoCommentNotification", object: nil, userInfo: dataDict)
        
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
