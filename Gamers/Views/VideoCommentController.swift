//
//  VideoCommentController.swift
//  Gamers
//
//  Created by 虚空之翼 on 15/8/21.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

import UIKit
import Bolts
import MJRefresh

class VideoCommentController: UIViewController {
    let userDefaults = NSUserDefaults.standardUserDefaults()    //用户全局登入信息
    
    var videoData: Video!
    var commentData = [YTVComment]()
    var pageToken = ""          //分页偏移量，默认为上次最后一个视频ID的nextpagetoken
    var maxResults = 20         //每页评论数量
    
    var isNoMoreData: Bool = false  //解决控件不能自己判断BUG
    
    @IBOutlet weak var commentTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 刷新功能
        commentTableView.header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: "loadNewData")
        commentTableView.footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: "loadMoreData")

        // 删除多余的分割线
        self.commentTableView.tableFooterView = UIView(frame: CGRectZero)
        // cell分割线边距，ios8处理
        if self.commentTableView.respondsToSelector("setSeparatorInset:") {
            self.commentTableView.separatorInset = UIEdgeInsetsMake(0, 5, 0, 5)
        }
        if self.commentTableView.respondsToSelector("setLayoutMargins:") {
            self.commentTableView.layoutMargins = UIEdgeInsetsMake(0, 5, 0, 5)
        }
        
        // 设置手势点击数,收起键盘
        var tapGesture = UITapGestureRecognizer(target: self, action: "handleTapGesture:")
        tapGesture.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(tapGesture)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "insertComment:", name: "insertCommentNotification", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadVideoComment:", name: "reloadVideoCommentNotification", object: nil)
        // 加载初始化数据
        loadInit()
    }
    
    // 隐藏键盘
    func handleTapGesture(sender: UITapGestureRecognizer) {
        NSNotificationCenter.defaultCenter().postNotificationName("handleTapGestureNotification", object: nil, userInfo: nil)
    }
    
    // 初始化数据
    func loadInit() {
        pageToken = ""
        VideoBL.sharedSingleton.getYoutubeComment(videoId: videoData.videoId, pageToken: pageToken, maxResults: maxResults).continueWithSuccessBlock({ [weak self] (task: BFTask!) -> BFTask! in
            self!.commentData = (task.result as? [YTVComment])!

            if !self!.commentData.isEmpty {
                self?.commentTableView.reloadData()
                
                if self!.commentData.last!.nextPageToken == "" {
                    self?.commentTableView.footer.noticeNoMoreData()
                    self!.isNoMoreData = true
                } else {
                    self!.pageToken = self!.commentData.last!.nextPageToken
                }
            } else {
                self?.commentData.removeAll(keepCapacity: false)
                self?.commentTableView.reloadData()
            }
            
            return nil
        }).continueWithBlock({ [weak self] (task: BFTask!) -> BFTask! in
            
            return nil
        })
        
    }
    
    
    // 下拉重新刷新数据
    func loadNewData() {
        pageToken = ""
        isNoMoreData = false
        VideoBL.sharedSingleton.getYoutubeComment(videoId: videoData.videoId, pageToken: pageToken, maxResults: maxResults).continueWithSuccessBlock({ [weak self] (task: BFTask!) -> BFTask! in
            self!.commentData = (task.result as? [YTVComment])!
            if !self!.commentData.isEmpty {
                self?.commentTableView.reloadData()
                if self!.commentData.last!.nextPageToken == "" {
                    self?.commentTableView.footer.noticeNoMoreData()
                    self!.isNoMoreData = true
                } else {
                    self!.pageToken = self!.commentData.last!.nextPageToken
                }
            }
            return nil
        }).continueWithBlock({ [weak self] (task: BFTask!) -> BFTask! in
            self?.commentTableView.header.endRefreshing()
            // 刷新Google的token
            if (self!.userDefaults.stringForKey("googleRefreshToken") != nil) {
                UserBL.sharedSingleton.googleRefreshToken2()
            }
            
            return nil
        })
    }
    // 上拉加载更多数据
    func loadMoreData() {
        VideoBL.sharedSingleton.getYoutubeComment(videoId: videoData.videoId, pageToken: pageToken, maxResults: maxResults).continueWithSuccessBlock({ [weak self] (task: BFTask!) -> BFTask! in
            let newData = (task.result as? [YTVComment])!

            if newData.isEmpty {
                self?.commentTableView.footer.noticeNoMoreData()
                self!.isNoMoreData = true
            } else{
                self!.commentData += newData
                
                if newData.last!.nextPageToken == "" {
                    self?.commentTableView.footer.noticeNoMoreData()
                    self!.isNoMoreData = true
                } else {
                    self!.pageToken = self!.commentData.last!.nextPageToken
                }

                self?.commentTableView.reloadData()
            }
            
            return nil
        }).continueWithBlock({ [weak self] (task: BFTask!) -> BFTask! in
            if !self!.isNoMoreData {
                self?.commentTableView.footer.endRefreshing()
            }
            
            // 刷新Google的token
            if (self!.userDefaults.stringForKey("googleRefreshToken") != nil) {
                UserBL.sharedSingleton.googleRefreshToken2()
            }

            return nil
        })
    }
    
    // 重新加载视频评论
    func reloadVideoComment(notification: NSNotification) {
        let userInfo = notification.userInfo!
        self.videoData = userInfo["data"] as! Video

        loadInit()
    }
    
    // 提交评论
    func insertComment(notification: NSNotification) {
        
        let userInfo = notification.userInfo!
        let CommentData = userInfo["data"] as! String
        if CommentData == "" {
            println("内容为空")
        } else {
            VideoBL.sharedSingleton.InsertVideoComment(videoId: videoData.videoId, textOriginal: CommentData).continueWithSuccessBlock({ [weak self] (task: BFTask!) -> BFTask! in
                if let responseData = (task.result as? YTVComment) {
                    var newComment = YTVComment()
                    newComment.textDisplay = responseData.textOriginal
                    newComment.authorDisplayName = responseData.authorDisplayName
                    newComment.publishedAt = responseData.publishedAt
                    
                    self!.commentData.insert(newComment, atIndex: 0)
                    // 清空数据
                    //self?.commentText.text = ""
                    // 在表格头部新增数据
                    self?.commentTableView.beginUpdates()
                    var indexPathsToInsert = NSMutableArray()
                    indexPathsToInsert.addObject(NSIndexPath(forRow: 0, inSection: 0))
                    self?.commentTableView.insertRowsAtIndexPaths(indexPathsToInsert as [AnyObject], withRowAnimation: UITableViewRowAnimation.Top)
                    self?.commentTableView.endUpdates()
                    
                } else {
                    var actionSheetController: UIAlertController = UIAlertController(title: "", message: "需要登入YouTube，是否登入？", preferredStyle: UIAlertControllerStyle.Alert)
                    actionSheetController.addAction(UIAlertAction(title: "否", style: UIAlertActionStyle.Cancel, handler: { (alertAction) -> Void in
                        //
                    }))
                    actionSheetController.addAction(UIAlertAction(title: "是", style: UIAlertActionStyle.Default, handler: { (alertAction) -> Void in
                        let userInfoView = self!.storyboard!.instantiateViewControllerWithIdentifier("GoogleLoginVC") as? GoogleLoginController
                        
                        self!.navigationController?.pushViewController(userInfoView!, animated: true)
                    }))
                    
                    // 显示Sheet
                    self!.presentViewController(actionSheetController, animated: true, completion: nil)
                }
                
                return nil
            }).continueWithBlock({ [weak self] (task: BFTask!) -> BFTask! in
                if task.error != nil { println(task.error) }
                return nil
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

// MARK: - 表格代理协议
extension VideoCommentController: UITableViewDataSource, UITableViewDelegate {
    // 设置表格行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentData.count
    }
    // 设置单元格
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("VideoCommentCell", forIndexPath: indexPath) as! VideoCommentCell
        cell.setComment(self.commentData[indexPath.row])
        
        return cell
    }
    // cell分割线的边距
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if cell.respondsToSelector("setSeparatorInset:") {
            cell.separatorInset = UIEdgeInsetsMake(0, 5, 0, 5)
        }
        if cell.respondsToSelector("setLayoutMargins:") {
            cell.layoutMargins = UIEdgeInsetsMake(0, 5, 0, 5)
        }
    }
    // cell自动行高设置
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return tableView.fd_heightForCellWithIdentifier("VideoCommentCell", cacheByIndexPath: indexPath) { (cell) -> Void in
            cell.setComment(self.commentData[indexPath.row])
        }
    }
    // 发出收起键盘事件
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        NSNotificationCenter.defaultCenter().postNotificationName("handleTapGestureNotification", object: nil, userInfo: nil)
    }
    
}

