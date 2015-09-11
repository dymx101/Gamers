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

    var videoData: Video!
    var channelData: Channel!
    let userDefaults = NSUserDefaults.standardUserDefaults()    //用户全局登入信息
    
    @IBOutlet weak var headerImage: UIImageView!
    @IBOutlet weak var channelName: UILabel!
    @IBOutlet weak var channelAutograph: UILabel!
    @IBOutlet weak var channelSubscribers: UILabel!
    @IBOutlet weak var videoDetails: UITextView!
    
    @IBOutlet weak var subscribeButton: UIButton!
    @IBAction func clickSubscribe(sender: AnyObject) {
        // 先判断是否登入
        let isLogin = userDefaults.boolForKey("isLogin")
        let userId = userDefaults.stringForKey("userId")
        
        if isLogin {
//            UserBL.sharedSingleton.setSubscribe(channelId: channelData.id).continueWithSuccessBlock({ [weak self] (task: BFTask!) -> BFTask! in
//                let response = (task.result as? Response)!
//                var message: String = response.code == "0" ? "订阅成功" : "订阅失败"
//                
//                var alertView: UIAlertView = UIAlertView(title: "", message: message, delegate: nil, cancelButtonTitle: "确定")
//                alertView.show()
//                
//                return nil
//            }).continueWithBlock({ [weak self] (task: BFTask!) -> BFTask! in
//
//                return nil
//            })
            println(channelData)
            UserBL.sharedSingleton.setFollow(channelId: channelData.id)
        } else {
            var alertView: UIAlertView = UIAlertView(title: "", message: "请先登入", delegate: nil, cancelButtonTitle: "确定")
            alertView.show()
        }
        
        
    }
    
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
        
        // 初始化数据
        loadInitData(videoData.ownerId)
        channelAutograph.text = FormatViewsTotal(videoData.views)
        
        // 重新加载视频评论监听器
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadVideoInfo:", name: "reloadVideoInfoNotification", object: nil)


    }

    func loadInitData(channelId: String) {
        // 设置属性
        ChannelBL.sharedSingleton.getChannelInfo(channelId: channelId).continueWithSuccessBlock({ [weak self] (task: BFTask!) -> BFTask! in
            self!.channelData = (task.result as? Channel)!
            
            self?.channelSubscribers.text = self!.FormatSubscribersTotal(self!.channelData.subscribers.toInt()!)
            //self?.channelAutograph.text = self!.FormatViewsTotal(self!.videoData.views)
            
            let imageUrl = self!.channelData.image.stringByReplacingOccurrencesOfString(" ", withString: "%20", options: NSStringCompareOptions.LiteralSearch, range: nil)
            self?.headerImage.hnk_setImageFromURL(NSURL(string: imageUrl)!)
            
            self?.videoDetails.text = self?.channelData.details
            self?.videoDetails.textColor = UIColor.blackColor()
            
            self?.channelName.text = self?.channelData.name

            return nil
        }).continueWithBlock({ [weak self] (task: BFTask!) -> BFTask! in

            return nil
        })
    }
    
    // 数量格式化, todo:扩展Int
    func FormatViewsTotal(theTotal: Int) -> String {
        var totalString = ""
        
        if theTotal < 1_000 {
            totalString = "\(theTotal)次观看"
        } else if theTotal < 10_000 {
            totalString = "\(theTotal / 1_000)千次观看"
        } else {
            totalString = "\(theTotal / 10_000)万次观看"
        }
        
        return totalString
    }
    func FormatSubscribersTotal(theTotal: Int) -> String {
        var totalString = ""
        
        if theTotal < 1_000 {
            totalString = "\(theTotal)人追随"
        } else if theTotal < 10_000 {
            totalString = "\(theTotal / 1_000)千人追随"
        } else {
            totalString = "\(theTotal / 10_000)万人追随"
        }
        
        return totalString
    }
    // 重新加载视频信息
    func reloadVideoInfo(notification: NSNotification) {
        let userInfo = notification.userInfo!
        let newVideoData = userInfo["data"] as! Video
        channelAutograph.text = FormatViewsTotal(newVideoData.views)
        
        //loadInitData(newVideoData.ownerId)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }


}
