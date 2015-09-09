//
//  VideoCommentController.swift
//  Gamers
//
//  Created by 虚空之翼 on 15/8/21.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

import UIKit
import Bolts
//import UITableView+FDTemplateLayoutCell
import MJRefresh

class VideoCommentController: UIViewController {
    let userDefaults = NSUserDefaults.standardUserDefaults()    //用户全局登入信息
    
    var videoData: Video!
    var commentData = [YTVComment]()
    var pageToken = ""          //分页偏移量，默认为上次最后一个视频ID的nextpagetoken
    var maxResults = 20         //每页评论数量
    
    var keyboardMoveStatus: Bool = false
    var keyboardHeight: CGFloat = 0
    var keyboardPageStatus: Int = 0
    
    var isNoMoreData: Bool = false  //解决控件不能自己判断BUG
    
    @IBOutlet weak var commentTableView: UITableView!
    @IBOutlet weak var chatToolView: UIView!
    
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var commentText: UITextField!
    @IBOutlet weak var emoticonsButton: UIButton!
    
    @IBAction func clickEmoticon(sender: AnyObject) {
    }
    @IBAction func clickComment(sender: AnyObject) {
        //commentText.becomeFirstResponder()
    }
    @IBAction func clickSend(sender: AnyObject) {
        if keyboardMoveStatus {
            moveDown(keyboardHeight)
        }
        
        insertComment()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 刷新功能
        commentTableView.header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: "loadNewData")
        commentTableView.footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: "loadMoreData")
        
        // 加载初始化数据
        loadInit()
        
        // 重新加载视频评论监听器，键盘收起监听器
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadVideoComment:", name: "reloadVideoCommentNotification", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardHide:", name: UIKeyboardWillHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardChange:", name: UIKeyboardWillChangeFrameNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "pagingMenukeyboardHide:", name: "pagingMenukeyboardHideNotification", object: nil)

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

//        superview bringSubviewToFront:subview
        self.view.bringSubviewToFront(chatToolView)
        
        //println(userDefaults.stringForKey("googleTokenBeginTime"))

        //userDefaults.removeObjectForKey("googleAccessToken")

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
    
    // 屏幕和键盘上移
    func moveUp(upHeight: CGFloat) {
        if !keyboardMoveStatus {
            keyboardMoveStatus = true
            keyboardPageStatus = 1
            //NSNotificationCenter.defaultCenter().postNotificationName("moveUpViewNotification", object: nil, userInfo: nil)
            
            //设置动画的名字
            UIView.beginAnimations("Animation", context: nil)
            //设置动画的间隔时间
            UIView.setAnimationDuration(0.20)
            //使用当前正在运行的状态开始下一段动画
            UIView.setAnimationBeginsFromCurrentState(true)
            //设置视图移动的位移
            self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y - upHeight, self.view.frame.size.width, self.view.frame.size.height);
            //设置动画结束
            
            UIView.commitAnimations()
            
            self.view.bringSubviewToFront(chatToolView)
        }
    }
    // 屏幕和键盘下移
    func moveDown(upHeight: CGFloat) {
        if keyboardMoveStatus {
            keyboardMoveStatus = false
            
            //设置动画的名字
            UIView.beginAnimations("Animation", context: nil)
            //设置动画的间隔时间
            UIView.setAnimationDuration(0.20)
            //??使用当前正在运行的状态开始下一段动画
            UIView.setAnimationBeginsFromCurrentState(true)
            //设置视图移动的位移
            self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + upHeight, self.view.frame.size.width, self.view.frame.size.height);
            //设置动画结束
            UIView.commitAnimations()
            
            // 收起键盘
            self.view.endEditing(true)
            keyboardHeight = 0
        }
    }
    
    // 隐藏键盘
    func handleTapGesture(sender: UITapGestureRecognizer) {
        moveDown(keyboardHeight)
        
    }
    
    // 第一步监听键盘弹出，获取键盘的高度
    func keyboardShow(notification: NSNotification) {
        println("键盘出现")
        let userInfo = notification.userInfo!
        let keyObject = userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue
        keyboardHeight = keyObject.CGRectValue().size.height
        
        moveUp(keyObject.CGRectValue().size.height)
        
        self.view.bringSubviewToFront(chatToolView)
    }
    func keyboardHide(notification: NSNotification) {
        moveDown(keyboardHeight)
    }
    // 界面切换时隐藏键盘，BUG：第一次触发会自动隐藏掉键盘
    func pagingMenukeyboardHide(notification: NSNotification) {
        println("界面切换1")
        if keyboardPageStatus >= 2 {
            self.view.endEditing(true)
            keyboardPageStatus = 1
        } else {
            keyboardPageStatus += 1
        }
    }
    
    func keyboardChange(notification: NSNotification) {
        if keyboardMoveStatus {
            let userInfo = notification.userInfo!
            let keyObject = userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue
            let newKeyboardHeight = keyObject.CGRectValue().size.height
            println("高度差：\(newKeyboardHeight - keyboardHeight)")
            //设置动画的名字
            UIView.beginAnimations("Animation", context: nil)
            //设置动画的间隔时间
            UIView.setAnimationDuration(0.20)
            //??使用当前正在运行的状态开始下一段动画
            UIView.setAnimationBeginsFromCurrentState(true)
            //设置视图移动的位移
            self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y - newKeyboardHeight + keyboardHeight, self.view.frame.size.width, self.view.frame.size.height);
            //设置动画结束
            UIView.commitAnimations()
        }
    }
    
    // 重新加载视频评论
    func reloadVideoComment(notification: NSNotification) {
        println("重新加载视频评论")
        loadInit()
    }
    
    // 判断是否登入Google
    func isGoogleLogin() {
        let googleAccessToken = userDefaults.stringForKey("googleAccessToken")
        let googleBeginTime = userDefaults.stringForKey("googleTokenBeginTime")?.toInt()
        let now = Int(NSDate().dateByAddingTimeInterval(0).timeIntervalSince1970)

        // googleAccessToken == nil || (googleBeginTime != nil && now - googleBeginTime! > 3600)
        if googleAccessToken == nil {
            googleLogin()
        }
        
        if googleBeginTime != nil && now - googleBeginTime! > 3600 {
            println("登入超时")
            googleLogin()
        }
    }
    func googleLogin() {
        var actionSheetController: UIAlertController = UIAlertController(title: "", message: "需要登入YouTube，是否登入？", preferredStyle: UIAlertControllerStyle.Alert)
        actionSheetController.addAction(UIAlertAction(title: "否", style: UIAlertActionStyle.Cancel, handler: { (alertAction) -> Void in
            //
        }))
        actionSheetController.addAction(UIAlertAction(title: "是", style: UIAlertActionStyle.Default, handler: { (alertAction) -> Void in
            let userInfoView = self.storyboard!.instantiateViewControllerWithIdentifier("GoogleLoginVC") as? GoogleLoginController
            
            self.navigationController?.pushViewController(userInfoView!, animated: true)
        }))
        
        // 显示Sheet
        self.presentViewController(actionSheetController, animated: true, completion: nil)
    }
    
    // 提交评论
    func insertComment() {
        if self.commentText.text == "" {
            println("内容为空")
        } else {
            VideoBL.sharedSingleton.InsertVideoComment(videoId: videoData.videoId, textOriginal: commentText.text).continueWithSuccessBlock({ [weak self] (task: BFTask!) -> BFTask! in
                if let responseData = (task.result as? YTVComment) {
                    var newComment = YTVComment()
                    newComment.textDisplay = responseData.textOriginal
                    newComment.authorDisplayName = responseData.authorDisplayName
                    newComment.publishedAt = responseData.publishedAt
                    
                    self!.commentData.insert(newComment, atIndex: 0)
                    // 清空数据
                    self?.commentText.text = ""
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

        //NSNotificationCenter.defaultCenter().removeObserver(UIKeyboardWillHideNotification)
    }

}

// MARK: - 文本框代理协议，键盘的收起和输入上下移动
extension VideoCommentController: UITextFieldDelegate, UITextViewDelegate {
    // 键盘和文本框输入事件
    func textFieldDidBeginEditing(textField: UITextField) {
        //moveUp(keyboardHeight)
        isGoogleLogin()
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        moveDown(keyboardHeight)

        insertComment()
        
        return true
    }
    func textFieldDidEndEditing(textField: UITextField) {


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

    
}

