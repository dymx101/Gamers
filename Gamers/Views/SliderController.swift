//
//  SliderController.swift
//  Gamers
//
//  Created by 虚空之翼 on 15/7/23.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

import UIKit
import YouTubePlayer
import youtube_ios_player_helper

class SliderController: UIViewController {

    @IBOutlet weak var playerView: YTPlayerView!

    override func viewDidLoad() {
        super.viewDidLoad()

//        UIScrollView *scrollView = (UIScrollView *)[[webView subviews] objectAtIndex:0];
//        scrollView.bounces = NO;
        //禁止滚动
            
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(),forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
        
        var playerVars = ["playsinline": 1, "showinfo": 1]
        //playerView.loadWithVideoId("https://www.youtube.com/watch?v=owRjJdlWTls", playerVars: playerVars)
        playerView.loadVideoByURL("https://www.youtube.com/watch?v=owRjJdlWTls", startSeconds: 10, suggestedQuality: YTPlaybackQuality.Default)
        //playerView.loadWithVideoId("2rj2dIXrXW8")
        
        // Do any additional setup after loading the view.
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
