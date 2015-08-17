//
//  PlayerViewController.swift
//  Gamers
//
//  Created by 虚空之翼 on 15/7/27.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

import UIKit
import youtube_ios_player_helper
//import YouTubePlayer
import PagingMenuController

class PlayerViewController: UIViewController {
    
    var videoData: Video!
    
    // 导航条默认隐藏
    var isflage = true

    @IBOutlet weak var playerView: YTPlayerView!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        //println(videoData)
        println("在viewDidLoad中触发了")
        
        // 设置顶部导航条样式，透明
        //self.navigationItem.title = videoData.videoTitle
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(),forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
        
        // 加载视频播放
        //plaverView.playerVars = ["playsinline": "1"]
        //plaverView.loadVideoID(videoData.videoId)
        var playerVars = ["playsinline": 1, "showinfo": 1]

        playerView.loadWithVideoId(videoData.videoId, playerVars: playerVars)
        //playerView.loadWithVideoId("2rj2dIXrXW8")
        
        //playerView.playerVars = ["playsinline": "1"]
        //playerView.loadVideoID("2rj2dIXrXW8")
        
        // 添加加载新视频数据的监听器
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadPlayerView:", name: "reloadPlayerViewNotification", object: nil)
        
        
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
        options.menuItemMode = PagingMenuOptions.MenuItemMode.Underline(height: 2, color: UIColor.whiteColor(), selectedColor: UIColor.orangeColor())
        options.textColor = UIColor.blackColor()
        options.defaultPage = 1
        
        let pagingMenuController = self.childViewControllers.first as! PagingMenuController
        pagingMenuController.delegate = self
        pagingMenuController.setup(viewControllers: viewControllers, options: options)
        
        
        
        //UIApplication.sharedApplication().setStatusBarHidden:true, withAnimation: UIStatusBarAnimation.None)

        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.None)
        
        
    
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "endFullScreen", name: UIWindowDidBecomeHiddenNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "begainFullScreen", name: UIWindowDidBecomeVisibleNotification, object: nil)
    }

    override func viewWillAppear(animated: Bool) {
        // 播放页面返回后，重置导航条的透明属性，//todo:image_1.jpg需求更换下
        println("在viewWillAppear中触发了")
        //playerView.loadVideoID("Zm8wVHL9KEg")

        //self.view.removeFromSuperview()
    
    }
    
    func reloadPlayerView(notification: NSNotification) {
        let userInfo = notification.userInfo!
        let newVideoData = userInfo["data"] as! Video

        //playerView.loadVideoID("Zm8wVHL9KEg")
        playerView.loadWithVideoId(newVideoData.videoId)
    }
    
    /**
    点击屏幕触发
    
    :param: touches touches description
    :param: event   event description
    */
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
//        if isflage {
//            super.navigationController?.navigationBarHidden = true
//        } else {
//            super.navigationController?.navigationBarHidden = false
//        }
//        
//        isflage = !isflage
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    // 隐藏系统状态栏
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.Default
    }
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func begainFullScreen() {
        var appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.allowRotation = true
    }
    
    func endFullScreen() {
        var appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.allowRotation = false
        
        //强制归正：
//        if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
//            SEL selector = NSSelectorFromString(@"setOrientation:");
//            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
//            [invocation setSelector:selector];
//            [invocation setTarget:[UIDevice currentDevice]];
//            int val =UIInterfaceOrientationPortrait;
//            [invocation setArgument:&val atIndex:2];
//            [invocation invoke];
//        }
        
//        var currentDevice = UIDevice.respondsToSelector("setOrientation:")
//        var selector = NSSelectorFromString("setOrientation:")
////        var invocation = NSInvoca
//        if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
//            [[UIDevice currentDevice] performSelector:@selector(setOrientation:)
//            withObject:(id)UIInterfaceOrientationLandscapeRight];
//        }
//
//        
        
        
    }

}

extension PlayerViewController: PagingMenuControllerDelegate {
    
    func willMoveToMenuPage(page: Int) {
        //println("触发willMoveToMenuPage事件")
    }
    
    func didMoveToMenuPage(page: Int) {
        //println("触发didMoveToMenuPage事件")
    }
}
