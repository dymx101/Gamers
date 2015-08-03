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

class PlayerViewController: UIViewController {
    
    var videoData: Video!
    
    // 导航条默认隐藏
    var isflage = true

    @IBOutlet weak var pagesView: SwiftPages!
    @IBOutlet weak var playerView: YTPlayerView!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        //println(videoData)
        
        
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
        
        // 标签切换页面swiftpage
//        var VCIDs : [String] = ["VideoInfoVC", "VideoRelateVC", "VideoCommentVC"]
//        var buttonTitles : [String] = ["详情", "相关视频", "评论"]
//        //pagesView.initializeWithVCIDsArrayAndButtonTitlesArray(VCIDs, buttonTitlesArray: buttonTitles)
//        
//        pagesView.initializeWithVCIDsArrayAndButtonTitlesArray(VCIDs, buttonTitlesArray: buttonTitles)
//        
//        pagesView.setOriginY(0)
//        pagesView.enableAeroEffectInTopBar(false)
//        pagesView.setButtonsTextColor(UIColor.orangeColor())
//        pagesView.setAnimatedBarColor(UIColor.orangeColor())
//        pagesView.setTopBarHeight(32)
//        pagesView.setButtonsTextFontAndSize(UIFont.systemFontOfSize(16))
        
        // 标签切换页面
        let VideoInfoVC = self.storyboard?.instantiateViewControllerWithIdentifier("VideoInfoVC") as! VideoInfoController
        VideoInfoVC.title = "详情"
        VideoInfoVC.videoData = videoData
        let VideoRelateVC = self.storyboard?.instantiateViewControllerWithIdentifier("VideoRelateVC") as! VideoRelateController
        VideoRelateVC.title = "相关视频"
        
        let VideoCommentVC = self.storyboard?.instantiateViewControllerWithIdentifier("VideoCommentVC") as! VideoCommentController
        VideoCommentVC.title = "评论"
        
        let viewControllers = [VideoInfoVC, VideoRelateVC, VideoCommentVC]
        
        let options = PagingMenuOptions()
        options.menuHeight = 32
        options.menuDisplayMode = PagingMenuOptions.MenuDisplayMode.SegmentedControl
        //options.menuItemMargin = 5
        options.selectedTextColor = UIColor.orangeColor()
        options.menuItemMode = PagingMenuOptions.MenuItemMode.Underline(height: 2, color: UIColor.whiteColor(), selectedColor: UIColor.orangeColor())
        options.textColor = UIColor.blackColor()
        
        
        let pagingMenuController = self.childViewControllers.first as! PagingMenuController
        //pagingMenuController.delegate = self
        pagingMenuController.setup(viewControllers: viewControllers, options: options)
        

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

}
