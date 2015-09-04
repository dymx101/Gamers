//
//  StreamsPlayerController.swift
//  Gamers
//
//  Created by 虚空之翼 on 15/9/4.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

import UIKit
import Bolts
import KRVideoPlayer

class HitboxLiveController: UIViewController {
    
    var videoPlayerController: KrVideoPlayerController!
    
    @IBOutlet weak var chatView: UIWebView!
    
    var liveData: Live!
    var isLoadRequest = false

    override func viewDidLoad() {
        super.viewDidLoad()
        //去掉webview加载顶部空白,禁止滚屏滑动
        chatView.allowsInlineMediaPlayback = true
        chatView.scrollView.scrollEnabled = false
        
        // 设置顶部导航条样式，透明
        //self.navigationItem.title = videoData.videoTitle
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(),forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
        
        delay(seconds: 10) { () -> () in
            //MBProgressHUD.hideHUDForView(self.navigationController!.view, animated: true)
            //println("执行nil")
            //self.videoPlayerController = nil
            //self.videoPlayerController.dismiss()
        }
        
        let url = "http://api.hitbox.tv/player/hls/\(liveData.stream.id).m3u8"
        self.addVideoPlayerWithURL(NSURL(string: url)!)

        let chatRequest = NSURLRequest(URL: NSURL(string: liveData.stream.chatUrl)!)
        chatView.loadRequest(chatRequest)
        

       // toolbarHidden(false)
        
    }

    override func viewWillDisappear(animated: Bool) {
        // 切换到其它界面，销毁播放器
        self.videoPlayerController.dismiss()
        self.chatView.removeFromSuperview()
        NSURLCache.sharedURLCache().removeAllCachedResponses()
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
        }

        self.videoPlayerController.contentURL = videoURL
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

    func toolbarHidden(bool: Bool) {
        self.navigationController?.navigationBar.hidden = bool
        self.tabBarController?.tabBar.hidden = bool
        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.None)
    }
    
    
    // 隐藏系统状态栏，8.0+专用
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.Default
    }
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
