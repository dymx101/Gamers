//
//  TwitchPlayerViewController.swift
//  Gamers
//
//  Created by 虚空之翼 on 15/8/4.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

import UIKit

class TwitchPlayerController: UIViewController {
    
    @IBOutlet weak var twitchPlayerView: UIWebView!
    @IBOutlet weak var twitchChatView: UIWebView!
    
    var videoData: Video!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        println(videoData)

        //去掉webview加载顶部空白
        self.automaticallyAdjustsScrollViewInsets = false;

        
        let videoRequest = NSURLRequest(URL: NSURL(string: "http://www.twitch.tv/asiagodtonegg3be0/embed")!)
        twitchPlayerView.loadRequest(videoRequest)
       
        let chatRequest = NSURLRequest(URL: NSURL(string: "http://www.twitch.tv/asiagodtonegg3be0/chat")!)
        twitchChatView.loadRequest(chatRequest)
        //twitchChatView.backgroundColor = UIColor.redColor()


        // 设置顶部导航条样式，透明
        //self.navigationItem.title = videoData.videoTitle
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(),forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
        
        
//        JGProgressHUD *HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
//        HUD.textLabel.text = @"Loading";
//        [HUD showInView:self.view];
//        [HUD dismissAfterDelay:3.0];
        
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
