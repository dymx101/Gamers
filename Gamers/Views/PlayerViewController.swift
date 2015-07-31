//
//  PlayerViewController.swift
//  Gamers
//
//  Created by 虚空之翼 on 15/7/27.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

import UIKit
import YouTubePlayer


class PlayerViewController: UIViewController {
    
    var videoData: Video!
    
    // 导航条默认隐藏
    var isflage = true

    @IBOutlet weak var plaverView: YouTubePlayerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        println(videoData)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        self.navigationItem.title = videoData.videoTitle
        
        // 加载视频播放
        plaverView.playerVars = ["playsinline": "1"]
        plaverView.loadVideoID(videoData.videoId)
        
        //super.navigationController?.navigationBarHidden = true
        
        
        
    }

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
