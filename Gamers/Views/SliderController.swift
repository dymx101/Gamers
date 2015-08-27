//
//  SliderController.swift
//  Gamers
//
//  Created by 虚空之翼 on 15/7/23.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

import UIKit
import youtube_ios_player_helper

class SliderController: UIViewController {

    @IBOutlet weak var playerView: YTPlayerView!
    @IBOutlet weak var descriptionView: UITextView!
    
    var sliderData: Slider!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.setBackgroundImage(UIImage(),forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
        
        
        
        // 播放设置
        playerView.delegate = self
        var playerVars = ["playsinline": 1, "showinfo": 1]

        // 不能实现bug，暂时截取ID出来
        //playerView.loadVideoByURL("https://www.youtube.com/watch?v=owRjJdlWTls", startSeconds: 0, suggestedQuality: YTPlaybackQuality.Auto)
        //var videoURLString = "https://www.youtube.com/watch?v=owRjJdlWTls"
        
        var videoURLString = sliderData.youtubeVideo
        var range: NSRange = NSMakeRange(32, NSString(string: videoURLString).length-32)
        var videoId = NSString(string: videoURLString).substringWithRange(range)
        playerView.loadWithVideoId(videoId, playerVars: playerVars)
        
        // 内容介绍
        descriptionView.text = sliderData.itemDescription
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}

// MARK: - youtube播放代理
extension SliderController: YTPlayerViewDelegate {
    // 加载完成立即播放
    func playerViewDidBecomeReady(playerView: YTPlayerView!) {
        playerView.playVideo()
    }
}
