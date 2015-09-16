//
//  PlayerViewController.swift
//  Gamers
//
//  Created by 虚空之翼 on 15/7/27.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

import UIKit
import youtube_ios_player_helper
import PagingMenuController
import Social
import Bolts
import RealmSwift
import MBProgressHUD

class PlayerViewController: UIViewController {

    var videoData: Video!
    let userDefaults = NSUserDefaults.standardUserDefaults()    //用户全局登入信息
    // 导航条默认隐藏
    var isflage = true
    var isPlay = 0

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var playerView: YTPlayerView!

    // 键盘属性,输入框
    var keyboardMoveStatus: Bool = false
    var keyboardHeight: CGFloat = 0
    var chatToolViewMoveStatus: Bool = false
    
    @IBOutlet weak var chatToolView: UIView!
    @IBOutlet weak var commentTextView: UITextField!
    @IBAction func clickSend(sender: AnyObject) {
        moveDown(keyboardHeight)
        
        // 插入数据
        if commentTextView.text != "" {
            var dataDict = ["data": commentTextView.text]
            NSNotificationCenter.defaultCenter().postNotificationName("insertCommentNotification", object: nil, userInfo: dataDict)
        } else {
            println("评论内容空")
        }
        commentTextView.text = "" //清空输入
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 设置顶部导航条样式，透明，另外一种方式，先备注预留
//        self.navigationItem.title = videoData.videoTitle
//        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont(name: "Heiti SC", size: 17.0)!]
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(),forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
        
        // 加载视频播放
        var playerVars = ["playsinline": 1, "showinfo": 1, "origin": "http://www.gamers.tm"]
        playerView.loadWithVideoId(videoData.videoId, playerVars: playerVars)
        
        // 添加加载新视频数据的监听器
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadPlayerView:", name: "reloadPlayerViewNotification", object: nil)
        // 播放全屏的监听事件
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "endFullScreen", name: UIWindowDidBecomeHiddenNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "begainFullScreen", name: UIWindowDidBecomeVisibleNotification, object: nil)
        // 评论界面上移事件
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "moveUpView", name: "moveUpViewNotification", object: nil)
        
        // 标签切换页面
        let VideoInfoVC = self.storyboard?.instantiateViewControllerWithIdentifier("VideoInfoVC") as! VideoInfoController
        VideoInfoVC.title = "詳情"
        VideoInfoVC.videoData = videoData
        let VideoRelateVC = self.storyboard?.instantiateViewControllerWithIdentifier("VideoRelateVC") as! VideoRelateController
        VideoRelateVC.title = "相關影片"
        VideoRelateVC.videoData = videoData
        let VideoCommentVC = self.storyboard?.instantiateViewControllerWithIdentifier("VideoCommentVC") as! VideoCommentController
        VideoCommentVC.title = "留言"
        VideoCommentVC.videoData = videoData
        let viewControllers = [VideoInfoVC, VideoRelateVC, VideoCommentVC]
        
        let options = PagingMenuOptions()
        options.menuHeight = 32
        options.menuDisplayMode = PagingMenuOptions.MenuDisplayMode.SegmentedControl
        //options.menuItemMargin = 5
        options.selectedTextColor = UIColor.orangeColor()
        options.menuItemMode = PagingMenuOptions.MenuItemMode.Underline(height: 2, color: UIColor.orangeColor(), horizontalPadding: 0, verticalPadding: 0)
        //options.menuItemMode = PagingMenuOptions.MenuItemMode.RoundRect(radius: 0, horizontalScale: 0, verticalScale: 0, selectedColor: UIColor.orangeColor())
        //options.menuPosition = PagingMenuOptions.MenuPosition.Top
        
        options.textColor = UIColor.blackColor()
        options.defaultPage = 2
        
        let pagingMenuController = self.childViewControllers.first as! PagingMenuController
        pagingMenuController.delegate = self
        pagingMenuController.setup(viewControllers: viewControllers, options: options)

        // 保存数据
        VideoBL.sharedSingleton.setPlayHistory(videoData)
        playerView.delegate = self

        // 重新加载视频评论监听器，键盘收起监听器
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardHide:", name: UIKeyboardWillHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardChange:", name: UIKeyboardWillChangeFrameNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleTapGesture:", name: "handleTapGestureNotification", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "MBProgressHUDHide", name: "MBProgressHUDHideNotification", object: nil)

        let hub = MBProgressHUD.showHUDAddedTo(self.navigationController!.view, animated: true)
        hub.labelText = NSLocalizedString("Loading...", comment: "加載中...")

    }
    func MBProgressHUDHide() {
        MBProgressHUD.hideHUDForView(navigationController!.view, animated: true)
        isPlay += 1
        if isPlay >= 2 {
            playerView.playVideo()
            isPlay = 0
        }
        
    }
    
    // 用户订阅
    func userSubscribe() {
        // 先判断是否登入
        let isLogin = userDefaults.boolForKey("isLogin")
        let userId = userDefaults.stringForKey("userId")
        
        if isLogin {
            UserBL.sharedSingleton.setSubscribe(channelId: videoData.ownerId).continueWithSuccessBlock({ [weak self] (task: BFTask!) -> BFTask! in
                let response = (task.result as? Response)!
                var message: String = response.code == "0" ? "追隨成功" : "追隨失败"
                var alertView: UIAlertView = UIAlertView(title: "", message: message, delegate: nil, cancelButtonTitle: "确定")
                alertView.show()
                
                return nil
            }).continueWithBlock({ [weak self] (task: BFTask!) -> BFTask! in
                return nil
            })
        } else {
            var alertView: UIAlertView = UIAlertView(title: "", message: "请先登入", delegate: nil, cancelButtonTitle: "确定")
            alertView.show()
        }
    }
    
    // 重新加载视频
    func reloadPlayerView(notification: NSNotification) {
        let userInfo = notification.userInfo!
        let newVideoData = userInfo["data"] as! Video
        
        var playerVars = ["playsinline": 1, "showinfo": 1, "origin": "http://www.gamers.tm"]
        playerView.loadWithVideoId(newVideoData.videoId, playerVars: playerVars)
        
        //videoViews.text = String(newVideoData.views) + " 次"

        // 保存数据
        VideoBL.sharedSingleton.setPlayHistory(newVideoData)
        
    }

    // 隐藏系统状态栏
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.Default
    }
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    // 横屏切换
    func begainFullScreen() {
        var appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.allowRotation = true

    }
    func endFullScreen() {
        var appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.allowRotation = false

        //强制归正：
        var sharedApplication: UIApplication = UIApplication.sharedApplication()
        sharedApplication.setStatusBarOrientation(UIInterfaceOrientation.Portrait, animated: true)
        var mvc: UIViewController = UIViewController()
        self.presentViewController(mvc, animated: true, completion: nil)
        self.dismissViewControllerAnimated(true, completion: nil)

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(),forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
        
        
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        //println("视图加载完成")

    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //println("加载完成")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 屏幕和键盘上移
    func moveUp(upHeight: CGFloat) {
        if !keyboardMoveStatus {
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
        //println("触发了点击事件")
    }
    
    // 第一步监听键盘弹出，获取键盘的高度
    func keyboardShow(notification: NSNotification) {
        let userInfo = notification.userInfo!
        let keyObject = userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue
        keyboardHeight = keyObject.CGRectValue().size.height
        
        moveUp(keyObject.CGRectValue().size.height)
    }
    func keyboardHide(notification: NSNotification) {
        moveDown(keyboardHeight)
    }
    // 输入法更换时，处理键盘高度发送变化情况
    func keyboardChange(notification: NSNotification) {
        if keyboardMoveStatus {
            let userInfo = notification.userInfo!
            let keyObject = userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue
            let newKeyboardHeight = keyObject.CGRectValue().size.height
            //println("高度差：\(newKeyboardHeight - keyboardHeight)")
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
}

// MARK: - 标签导航代理
extension PlayerViewController: PagingMenuControllerDelegate {
    func willMoveToMenuPage(page: Int) {
        //println(page)
        //println("触发willMoveToMenuPage事件")
    }
    func didMoveToMenuPage(page: Int) {
        if page == 2 {
            let animation = CATransition()
            animation.duration = 0.4
            animation.type = kCATransitionFade
            chatToolView.layer.addAnimation(animation, forKey: nil)
            chatToolView.hidden = false
        } else {
            let animation = CATransition()
            animation.duration = 0.4
            animation.type = kCATransitionFade
            chatToolView.layer.addAnimation(animation, forKey: nil)
            chatToolView.hidden = true

            moveDown(keyboardHeight)
        }
    }
}

// MARK: - youtube播放代理
extension PlayerViewController: YTPlayerViewDelegate {
    // 加载完成立即播放
    func playerViewDidBecomeReady(playerView: YTPlayerView!) {
        isPlay += 1
        if isPlay >= 2 {
            playerView.playVideo()
            isPlay = 0
        }
    }
}
// MARK: 网络Web代理
extension PlayerViewController: UIWebViewDelegate {
    func webViewDidFinishLoad(webView: UIWebView) {
        NSUserDefaults.standardUserDefaults().setInteger(0, forKey: "WebKitCacheModelPreferenceKey")
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "WebKitDiskImageCacheEnabled")
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "WebKitOfflineWebApplicationCacheEnabled")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
}

// MARK: - 文本框代理协议，键盘的收起和输入上下移动
extension PlayerViewController: UITextFieldDelegate, UITextViewDelegate {
    // 键盘和文本框输入事件
    func textFieldDidBeginEditing(textField: UITextField) {
        //moveUp(keyboardHeight)
        isGoogleLogin()
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        moveDown(keyboardHeight)
        
        // 插入数据
        if commentTextView.text != "" {
            var dataDict = ["data": commentTextView.text]
            NSNotificationCenter.defaultCenter().postNotificationName("insertCommentNotification", object: nil, userInfo: dataDict)
        } else {
            println("评论内容空")
        }
        commentTextView.text = "" //清空输入
        
        return true
    }
    func textFieldDidEndEditing(textField: UITextField) {
        
        
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
}
