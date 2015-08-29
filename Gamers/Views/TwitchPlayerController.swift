//
//  TwitchPlayerViewController.swift
//  Gamers
//
//  Created by 虚空之翼 on 15/8/4.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

import UIKit
import MBProgressHUD

class TwitchPlayerController: UIViewController {
    
    @IBOutlet weak var twitchPlayerView: UIWebView!
    @IBOutlet weak var twitchChatView: UIWebView!
    
    var LiveData: Live!
    
    var isLoadRequest = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //去掉webview加载顶部空白,禁止滚屏滑动
        self.automaticallyAdjustsScrollViewInsets = false
        twitchPlayerView.allowsInlineMediaPlayback = true
        twitchPlayerView.scrollView.scrollEnabled = false
        twitchChatView.allowsInlineMediaPlayback = true
        twitchChatView.scrollView.scrollEnabled = false

        // 设置顶部导航条样式，透明
        //self.navigationItem.title = videoData.videoTitle
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(),forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true

        //if LiveData.type == "twitch" {
            let videoRequest = NSURLRequest(URL: NSURL(string: LiveData.stream.streamUrl)!) //popout、embed
            twitchPlayerView.loadRequest(videoRequest)
            
            let chatRequest = NSURLRequest(URL: NSURL(string: LiveData.stream.chatUrl)!)
            twitchChatView.loadRequest(chatRequest)
        //}
        
        // 隐藏系统状态栏
        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.None)
        
        // 播放全屏的监听事件
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "endFullScreen", name: UIWindowDidBecomeHiddenNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "begainFullScreen", name: UIWindowDidBecomeVisibleNotification, object: nil)
        
        // 延迟加载进度
        let hub = MBProgressHUD.showHUDAddedTo(self.navigationController!.view, animated: true)
        hub.labelText = "加载中..."
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        sharedApplication.setStatusBarOrientation(UIInterfaceOrientation.Portrait, animated: false)
        var mvc: UIViewController = UIViewController()
        self.presentViewController(mvc, animated: false, completion: nil)
        self.dismissViewControllerAnimated(false, completion: nil)
        
    }

}

// MARK: - 刷新时候显示加载界面，暂定使用http://api.twitch.tv/assets/判断
extension TwitchPlayerController: UIWebViewDelegate {
    func webViewDidFinishLoad(webView: UIWebView) {
        if isLoadRequest {
            MBProgressHUD.hideHUDForView(self.navigationController!.view, animated: true)
            
            isLoadRequest = false
        }
        
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        var backURLString = request.URL?.absoluteString
        if backURLString!.hasPrefix("http://api.twitch.tv/assets/") {
            isLoadRequest = true
        }

        return true
    }
    
}

