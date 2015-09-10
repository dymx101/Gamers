//
//  StreamsPlayerController.swift
//  Gamers
//
//  Created by 虚空之翼 on 15/9/4.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

import UIKit
import Bolts

class HitboxLiveController: UIViewController {
    
    var videoPlayerController: KrVideoPlayerController!
    
    @IBOutlet weak var playerBackgroundView: UIView!
    @IBOutlet weak var chatView: UIWebView!
    
    var liveData: Live!
    var isLoadRequest = false

    override func viewDidLoad() {
        super.viewDidLoad()
        //去掉webview加载顶部空白,禁止滚屏滑动
        self.automaticallyAdjustsScrollViewInsets = false
        chatView.allowsInlineMediaPlayback = true
        chatView.scrollView.scrollEnabled = false
        playerBackgroundView.hidden = true
        
        // 设置顶部导航条样式，透明
        //self.navigationItem.title = videoData.videoTitle
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(),forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
        
        // 延迟加载，解决视频横放不能在最前端错误
        delay(seconds: 1) { () -> () in
            let url = "http://api.hitbox.tv/player/hls/\(self.liveData.stream.id).m3u8"
            self.addVideoPlayerWithURL(NSURL(string: url)!)
        }

        let chatRequest = NSURLRequest(URL: NSURL(string: liveData.stream.chatUrl)!)
        chatView.loadRequest(chatRequest)
        

        
    }
    
    func addVideoPlayerWithURL(videoURL: NSURL) {
        if (self.videoPlayerController == nil) {
            let width = UIScreen.mainScreen().bounds.size.width
            self.videoPlayerController = KrVideoPlayerController(frame: CGRectMake(0, 0, width, width*(9.0/16.0)))
            
            self.videoPlayerController.dimissCompleteBlock = { [weak self] in
                if let weakSelf = self {
                    weakSelf.videoPlayerController = nil
                }
            }
            
            self.videoPlayerController.willBackOrientationPortrait = { [weak self] in
                if let weakSelf = self {
                    //weakSelf.toolbarHidden(false)
                }
            }
            
            self.videoPlayerController.willChangeToFullscreenMode = { [weak self] in
                if let weakSelf = self {
                    //weakSelf.toolbarHidden(false)
                }
            }
            
            self.view.addSubview(videoPlayerController.view)
            self.view.bringSubviewToFront(videoPlayerController.view)
        }
        
        self.videoPlayerController.contentURL = videoURL
    }
    
    // 隐藏系统状态栏，8.0+专用
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.Default
    }
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    /**
    延迟函数，delay(seconds: 3.0, completion: {  })
    */
    func delay(#seconds: Double, completion:()->()) {
        let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64( Double(NSEC_PER_SEC) * seconds ))
        
        dispatch_after(popTime, dispatch_get_main_queue()) {
            completion()
        }
    }

    override func viewWillDisappear(animated: Bool) {
        // 切换到其它界面，销毁播放器
        self.videoPlayerController.dismiss()
        //self.chatView.removeFromSuperview()
        NSURLCache.sharedURLCache().removeAllCachedResponses()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    

}
