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
        
        // 隐藏系统状态栏
        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.None)
        
        // 播放全屏的监听事件
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "endFullScreen", name: UIWindowDidBecomeHiddenNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "begainFullScreen", name: UIWindowDidBecomeVisibleNotification, object: nil)
        

        
    }

    override func viewWillAppear(animated: Bool) {
    
    }
    
    func reloadPlayerView(notification: NSNotification) {
        let userInfo = notification.userInfo!
        let newVideoData = userInfo["data"] as! Video

        //playerView.loadVideoID("Zm8wVHL9KEg")
        playerView.loadWithVideoId(newVideoData.videoId)
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
        sharedApplication.setStatusBarOrientation(UIInterfaceOrientation.Portrait, animated: false)
        var mvc: UIViewController = UIViewController()
        self.presentViewController(mvc, animated: false, completion: nil)
        self.dismissViewControllerAnimated(false, completion: nil)

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
