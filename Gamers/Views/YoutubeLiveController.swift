//
//  YoutubeLiveController.swift
//  Gamers
//
//  Created by 虚空之翼 on 15/9/4.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

import UIKit
import youtube_ios_player_helper

class YoutubeLiveController: UIViewController {

    @IBOutlet weak var playerView: YTPlayerView!
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
        
        // 加载视频播放
        var playerVars = ["playsinline": 1, "showinfo": 1]
        playerView.loadWithVideoId("VzoxtcHIsQo", playerVars: playerVars)
        
        
        println("youtubelive")
        
        
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
