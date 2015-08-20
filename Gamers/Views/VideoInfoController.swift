//
//  VideoInfoController.swift
//  Gamers
//
//  Created by 虚空之翼 on 15/8/3.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

import UIKit
import Bolts
import SnapKit

class VideoInfoController: UIViewController {

    @IBOutlet weak var headerImage: UIImageView!
    @IBOutlet weak var channelName: UILabel!
    @IBOutlet weak var channelAutograph: UILabel!
    @IBOutlet weak var channelSubscribers: UILabel!
    @IBOutlet weak var videoDetails: UITextView!
    
    @IBOutlet weak var subscribeButton: UIButton!
    @IBAction func clickSubscribe(sender: AnyObject) {
        userBL.setSubscribe(userId: "", channelId: "").continueWithSuccessBlock({ [weak self] (task: BFTask!) -> BFTask! in
            let response = (task.result as? Response)!
            var message: String = response.code == "0" ? "订阅成功" : "订阅失败"
            
            var alertView: UIAlertView = UIAlertView(title: "", message: message, delegate: nil, cancelButtonTitle: "确定")
            alertView.show()
            
            return nil
        }).continueWithBlock({ [weak self] (task: BFTask!) -> BFTask! in
            if task.error != nil {
                
            }
            
            return nil
        })
    }

    let userBL = UserBL()
    let channelBL = ChannelBL()
    
    var videoData: Video!
    var channelData: Channel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        subscribeButton.layer.masksToBounds = true
        subscribeButton.layer.cornerRadius = 6
        subscribeButton.layer.borderWidth = 1
        subscribeButton.layer.borderColor = UIColor.orangeColor().CGColor
        
        //设置圆角
        headerImage.clipsToBounds = true
        headerImage.layer.cornerRadius = 10
        //边框
        headerImage.layer.borderWidth = 1
        headerImage.layer.borderColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.7).CGColor
        
        // 设置属性
        channelBL.getChannelInfo(channelId: "").continueWithSuccessBlock({ [weak self] (task: BFTask!) -> BFTask! in
            self!.channelData = (task.result as? Channel)!
            
            self?.channelSubscribers.text = String(self!.channelData.subscribes) + " 次"
            self?.channelAutograph.text = String(self!.channelData.details)

            let imageUrl = self!.channelData.image.stringByReplacingOccurrencesOfString(" ", withString: "%20", options: NSStringCompareOptions.LiteralSearch, range: nil)
            self?.headerImage.kf_setImageWithURL(NSURL(string: imageUrl)!)
            
            return nil
        }).continueWithBlock({ [weak self] (task: BFTask!) -> BFTask! in
            if task.error != nil {
                println(task.error)
            }
            
            return nil
        })
        
        
        // 重新加载视频评论监听器
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadVideoInfo:", name: "reloadVideoInfoNotification", object: nil)

    }

    func reloadVideoInfo(notification: NSNotification) {
        println("刷新视频信息")
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
