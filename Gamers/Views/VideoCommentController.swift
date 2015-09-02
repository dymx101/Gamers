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
    var commentData = [Comment]()
    var nextPageToken = ""         //分页偏移量，默认为上次最后一个视频ID的nextpagetoken
    var commentPageCount = 20      //每页视频总数
    
    var keyboardMoveStatus: Bool = false
    var keyboardHeight: CGFloat!
    
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
        
        var newComment = Comment()
        newComment.title = "abc"
        newComment.content = commentText.text
        commentData.insert(newComment, atIndex: 0)
        // 清空数据
        commentText.text = ""
        // 在表格头部新增数据
        commentTableView.beginUpdates()
        var indexPathsToInsert = NSMutableArray()
        indexPathsToInsert.addObject(NSIndexPath(forRow: 0, inSection: 0))
        commentTableView.insertRowsAtIndexPaths(indexPathsToInsert as [AnyObject], withRowAnimation: UITableViewRowAnimation.Top)
        commentTableView.endUpdates()
        
        // 提交评论数据
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
        
        println(self.videoData)
        
    
    }
    
    // 初始化数据
    func loadInit() {
        nextPageToken = ""
        VideoBL.sharedSingleton.getVideoComment(videoData.videoId, nextPageToken: nextPageToken, count: commentPageCount).continueWithSuccessBlock({ [weak self] (task: BFTask!) -> BFTask! in
            self!.commentData = (task.result as? [Comment])!
            if !self!.commentData.isEmpty {
                self?.commentTableView.reloadData()
                //println("视频ID：\(self!.videoData.videoId), 链接地址：https://www.youtube.com/watch?v=\(self!.videoData.videoId)")
                //println(self!.commentData)
                
                self!.nextPageToken = self!.commentData.last!.data.nextPageToken
            }

            return nil
        })
    }
    // 下拉重新刷新数据
    func loadNewData() {
        nextPageToken = ""
        VideoBL.sharedSingleton.getVideoComment(videoData.videoId, nextPageToken: nextPageToken, count: commentPageCount).continueWithSuccessBlock({ [weak self] (task: BFTask!) -> BFTask! in
            self!.commentData = (task.result as? [Comment])!
            if !self!.commentData.isEmpty {
                self?.commentTableView.reloadData()
                self!.nextPageToken = self!.commentData.last!.data.nextPageToken
            }
            return nil
        }).continueWithBlock({ [weak self] (task: BFTask!) -> BFTask! in
            self?.commentTableView.header.endRefreshing()
            
            return nil
        })
    }
    // 上拉加载更多数据
    func loadMoreData() {
        VideoBL.sharedSingleton.getVideoComment(videoData.videoId, nextPageToken: nextPageToken, count: commentPageCount).continueWithSuccessBlock({ [weak self] (task: BFTask!) -> BFTask! in
            let newData = (task.result as? [Comment])!

            if newData.isEmpty {
                self?.commentTableView.footer.noticeNoMoreData()
            } else{
                self!.commentData += newData
                self!.nextPageToken = self!.commentData.last!.data.nextPageToken
                
                self?.commentTableView.reloadData()
            }
            
            return nil
        }).continueWithBlock({ [weak self] (task: BFTask!) -> BFTask! in
            self?.commentTableView.footer.endRefreshing()
            
            return nil
        })
    }
    
    // 屏幕和键盘上移
    func moveUp(upHeight: CGFloat) {
        keyboardMoveStatus = true
        
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
        
    }
    // 屏幕和键盘下移
    func moveDown(upHeight: CGFloat) {
        keyboardMoveStatus = false
        println(upHeight)
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
    }
    
    // 隐藏键盘
    func handleTapGesture(sender: UITapGestureRecognizer) {
        if keyboardMoveStatus {
            moveDown(keyboardHeight)
        }
    }
    func keyboardShow(notification: NSNotification) {
        let userInfo = notification.userInfo!
        let keyObject = userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue
        keyboardHeight = keyObject.CGRectValue().size.height

        moveUp(keyObject.CGRectValue().size.height)
    }
    func keyboardHide(notification: NSNotification) {
        if keyboardMoveStatus {
            moveDown(keyboardHeight)
        }
        
    }
    
    // 重新加载视频评论
    func reloadVideoComment(notification: NSNotification) {
        println("重新加载视频评论")
        loadInit()
    }
    
    // 判断是否登入Google
    func isGoogleLogin() {
        var googleAccessToken = userDefaults.stringForKey("googleAccessToken")!

        if googleAccessToken.isEmpty {
            
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
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

        NSNotificationCenter.defaultCenter().removeObserver(UIKeyboardWillHideNotification)
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
        if keyboardMoveStatus {
            moveDown(keyboardHeight)
        }

        VideoBL.sharedSingleton.insertComment(videoId: videoData.videoId, channelId: videoData.ownerId, commentText: commentText.text, accessToken: userDefaults.stringForKey("googleAccessToken")!)
        commentText.text = ""
        
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

