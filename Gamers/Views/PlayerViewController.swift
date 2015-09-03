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

class PlayerViewController: UIViewController {

    var videoData: Video!
    
    let userDefaults = NSUserDefaults.standardUserDefaults()    //用户全局登入信息
    
    // 导航条默认隐藏
    var isflage = true

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var playerView: YTPlayerView!
    @IBOutlet weak var videoViews: UILabel!
    @IBOutlet weak var subscribeButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    
    // 跟随频道
    @IBAction func clickSubscribe(sender: AnyObject) {
        self.userSubscribe()
    }
    // 分享视频
    @IBAction func clickShare(sender: AnyObject) {
        // 退出
        var actionSheetController: UIAlertController = UIAlertController()
        actionSheetController.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel) { (alertAction) -> Void in
            //code
        })
        // 关注频道
//        actionSheetController.addAction(UIAlertAction(title: "跟随", style: UIAlertActionStyle.Destructive) { (alertAction) -> Void in
//            self.userSubscribe()
//        })
        // 分享到Facebook
        actionSheetController.addAction(UIAlertAction(title: "分享到Facebook", style: UIAlertActionStyle.Default) { (alertAction) -> Void in
            var slComposerSheet = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            slComposerSheet.setInitialText("share facebook")
            slComposerSheet.addImage(UIImage(named: "user.png"))
            slComposerSheet.addURL(NSURL(string: "http://www.facebook.com/"))
            self.presentViewController(slComposerSheet, animated: true, completion: nil)
            SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook)
            
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
            slComposerSheet.setInitialText("share facebook")
            slComposerSheet.addImage(UIImage(named: "user.png"))
            slComposerSheet.addURL(NSURL(string: "http://www.facebook.com/"))
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

    
    override func viewDidLoad() {
        super.viewDidLoad()
//        videoViews.text = String(videoData.views) + " 次"
//        
//        shareButton.layer.masksToBounds = true
//        shareButton.layer.cornerRadius = 6
//        shareButton.layer.borderWidth = 1
//        shareButton.layer.borderColor = UIColor.orangeColor().CGColor
//        
//        subscribeButton.layer.masksToBounds = true
//        subscribeButton.layer.cornerRadius = 6
//        subscribeButton.layer.borderWidth = 1
//        subscribeButton.layer.borderColor = UIColor.orangeColor().CGColor
        
        // 设置顶部导航条样式，透明
//        self.navigationItem.title = videoData.videoTitle
//        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont(name: "Heiti SC", size: 17.0)!]
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(),forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
        
        // 加载视频播放
        var playerVars = ["playsinline": 1, "showinfo": 1]
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
        VideoInfoVC.title = "详情"
        VideoInfoVC.videoData = videoData
        let VideoRelateVC = self.storyboard?.instantiateViewControllerWithIdentifier("VideoRelateVC") as! VideoRelateController
        VideoRelateVC.title = "相关视频"
        VideoRelateVC.videoData = videoData
        let VideoCommentVC = self.storyboard?.instantiateViewControllerWithIdentifier("VideoCommentVC") as! VideoCommentController
        VideoCommentVC.title = "评论"
        VideoCommentVC.videoData = videoData
        let viewControllers = [VideoInfoVC, VideoRelateVC, VideoCommentVC]
        
        let options = PagingMenuOptions()
        options.menuHeight = 32
        options.menuDisplayMode = PagingMenuOptions.MenuDisplayMode.SegmentedControl
        //options.menuItemMargin = 5
        options.selectedTextColor = UIColor.orangeColor()
        options.menuItemMode = PagingMenuOptions.MenuItemMode.Underline(height: 2, color: UIColor.orangeColor(), horizontalPadding: 0, verticalPadding: 0)
        //options.menuItemMode = PagingMenuOptions.MenuItemMode.RoundRect(radius: 0, horizontalScale: 0, verticalScale: 0, selectedColor: UIColor.orangeColor())
        
        options.textColor = UIColor.blackColor()
        options.defaultPage = 1
        
        let pagingMenuController = self.childViewControllers.first as! PagingMenuController
        pagingMenuController.delegate = self
        pagingMenuController.setup(viewControllers: viewControllers, options: options)
        
        // 隐藏系统状态栏
        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.None)

        
        // 保存数据
        VideoBL.sharedSingleton.setPlayHistory(videoData)
        
        playerView.delegate = self
        
        self.view.bringSubviewToFront(containerView)
        
    }
    
    func moveUpView() {
        println("屏幕上移")
//        UIView.animateWithDuration(1, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
//            self.playerView.frame.size.height = 100
//            //self.containerView.frame.size.height += 50
//            
//            self.containerView.snp_updateConstraints(closure: { (make) -> Void in
//                make.top.equalTo(self.playerView.snp_bottom).offset(6)
//            })
//        }, completion: nil)
        //设置动画结束
        
        //UIView.commitAnimations()
    }
    
    // 用户订阅
    func userSubscribe() {
        // 先判断是否登入
        let isLogin = userDefaults.boolForKey("isLogin")
        let userId = userDefaults.stringForKey("userId")
        
        if isLogin {
            UserBL.sharedSingleton.setSubscribe(userToken: userId, channelId: videoData.ownerId).continueWithSuccessBlock({ [weak self] (task: BFTask!) -> BFTask! in
                let response = (task.result as? Response)!
                
                println(task.result)
                var message: String = response.code == "0" ? "跟随成功" : "跟随失败"
                
                var alertView: UIAlertView = UIAlertView(title: "", message: message, delegate: nil, cancelButtonTitle: "确定")
                alertView.show()
                
                return nil
            }).continueWithBlock({ [weak self] (task: BFTask!) -> BFTask! in
                if task.error != nil {
                    
                }
                return nil
            })
        } else {
            var alertView: UIAlertView = UIAlertView(title: "", message: "请先登入", delegate: nil, cancelButtonTitle: "确定")
            alertView.show()
        }
    }
    
    
    override func viewWillAppear(animated: Bool) {
    
    }
    
    // 重新加载视频
    func reloadPlayerView(notification: NSNotification) {
        let userInfo = notification.userInfo!
        let newVideoData = userInfo["data"] as! Video
        
        var playerVars = ["playsinline": 1, "showinfo": 1]
        //playerView.loadVideoID("Zm8wVHL9KEg")
        playerView.loadWithVideoId(newVideoData.videoId, playerVars: playerVars)
        
        //videoViews.text = String(newVideoData.views) + " 次"
        
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: - 标签导航代理
extension PlayerViewController: PagingMenuControllerDelegate {
    
    func willMoveToMenuPage(page: Int) {
        //println(page)
        //println("触发willMoveToMenuPage事件")
    }
    
    func didMoveToMenuPage(page: Int) {
        //println(page)
        //println("触发didMoveToMenuPage事件")
    }
}

// MARK: - youtube播放代理
extension PlayerViewController: YTPlayerViewDelegate {
    // 加载完成立即播放
    func playerViewDidBecomeReady(playerView: YTPlayerView!) {
        playerView.playVideo()
    }
}

extension PlayerViewController: UIWebViewDelegate {
    func webViewDidFinishLoad(webView: UIWebView) {
        NSUserDefaults.standardUserDefaults().setInteger(0, forKey: "WebKitCacheModelPreferenceKey")
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "WebKitDiskImageCacheEnabled")
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "WebKitOfflineWebApplicationCacheEnabled")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
}
