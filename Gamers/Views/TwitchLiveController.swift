//
//  TwitchPlayerViewController.swift
//  Gamers
//
//  Created by 虚空之翼 on 15/8/4.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

import UIKit
import Bolts

class TwitchLiveController: UIViewController {
    
    @IBOutlet weak var twitchPlayerView: UIWebView!
    @IBOutlet weak var twitchChatView: UIWebView!
    
    var videoPlayerController: KrVideoPlayerController!
    
    var liveData: Live!
    var isLoadRequest = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //去掉webview加载顶部空白,禁止滚屏滑动
        self.automaticallyAdjustsScrollViewInsets = false
        twitchChatView.allowsInlineMediaPlayback = true
        twitchChatView.scrollView.scrollEnabled = false

        // 设置顶部导航条样式，透明
        //self.navigationItem.title = videoData.videoTitle
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(),forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true

        
        
        LiveBL.sharedSingleton.getTwitchStreamsURL(channelId: liveData.stream.id.lowercaseString).continueWithSuccessBlock({ [weak self] (task: BFTask!) -> BFTask! in
            if var url = task.result as? String {
                self!.addVideoPlayerWithURL(NSURL(string: url)!)
            }
            
            return nil
        }).continueWithBlock({ [weak self] (task: BFTask!) -> BFTask! in
                return nil
        })
        
            
        let chatRequest = NSURLRequest(URL: NSURL(string: liveData.stream.chatUrl)!)
        twitchChatView.loadRequest(chatRequest)
        

        // 播放全屏的监听事件
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: "endFullScreen", name: UIWindowDidBecomeHiddenNotification, object: nil)
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: "begainFullScreen", name: UIWindowDidBecomeVisibleNotification, object: nil)
//        

        
        
        
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

    // 隐藏系统状态栏
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.Default
    }
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewWillDisappear(animated: Bool) {
        // 切换到其它界面，销毁播放器
        self.videoPlayerController.dismiss()
        self.twitchChatView.removeFromSuperview()
        NSURLCache.sharedURLCache().removeAllCachedResponses()
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
    
    /**
    延迟函数，delay(seconds: 3.0, completion: {  })
    */
    func delay(#seconds: Double, completion:()->()) {
        let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64( Double(NSEC_PER_SEC) * seconds ))
        
        dispatch_after(popTime, dispatch_get_main_queue()) {
            completion()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

// MARK: - 刷新时候显示加载界面，暂定使用http://api.twitch.tv/assets/判断
extension TwitchLiveController: UIWebViewDelegate {
    func webViewDidFinishLoad(webView: UIWebView) {
        // 设置uiwebview内存参数，减少内存使用量（待测试）
        NSUserDefaults.standardUserDefaults().setInteger(0, forKey: "WebKitCacheModelPreferenceKey")
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "WebKitDiskImageCacheEnabled")
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "WebKitOfflineWebApplicationCacheEnabled")
        NSUserDefaults.standardUserDefaults().synchronize()

    }

    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {

        return true
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError) {
        println("UIWebView.......error")

    }
}

