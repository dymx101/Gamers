//
//  SliderController.swift
//  Gamers
//
//  Created by 虚空之翼 on 15/7/23.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

import UIKit
import YouTubePlayer

class SliderController: UIViewController {

    @IBOutlet weak var playerView: YouTubePlayerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        NSLog("222222")

//        UIScrollView *scrollView = (UIScrollView *)[[webView subviews] objectAtIndex:0];
//        scrollView.bounces = NO;
        //禁止滚动
            

        
        playerView.playerVars = ["playsinline": "1"]
        playerView.loadVideoID("yRRABRn0JTc")
        
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