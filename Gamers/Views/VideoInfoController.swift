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
            UserBL.sharedSingleton.setFollow(channelId: channelData.id)
        } else {
            var actionSheetController: UIAlertController = UIAlertController(title: "", message: "需要登入Freedom，是否登入？", preferredStyle: UIAlertControllerStyle.Alert)
            actionSheetController.addAction(UIAlertAction(title: "否", style: UIAlertActionStyle.Cancel, handler: { (alertAction) -> Void in
                //
            }))
            actionSheetController.addAction(UIAlertAction(title: "是", style: UIAlertActionStyle.Default, handler: { (alertAction) -> Void in
                let userInfoView = self.storyboard!.instantiateViewControllerWithIdentifier("FreedomLoginVC") as? FreedomLoginController
                
                self.navigationController?.pushViewController(userInfoView!, animated: true)
            }))
            
            // 显示Sheet
            self.presentViewController(actionSheetController, animated: true, completion: nil)
        }
        
        
    }
    
    @IBOutlet weak var subscribeYoutubeButton: UIButton!
    @IBAction func clickSubscribeYoutube(sender: AnyObject) {
        // 先判断是否登入
        let googleAccessToken = userDefaults.stringForKey("googleAccessToken")
        
        if googleAccessToken == nil {
            var actionSheetController: UIAlertController = UIAlertController(title: "", message: "需要登入YouTube，是否登入？", preferredStyle: UIAlertControllerStyle.Alert)
            actionSheetController.addAction(UIAlertAction(title: "否", style: UIAlertActionStyle.Cancel, handler: { (alertAction) -> Void in
                //
            }))
            actionSheetController.addAction(UIAlertAction(title: "是", style: UIAlertActionStyle.Default, handler: { (alertAction) -> Void in
                let userInfoView = self.storyboard!.instantiateViewControllerWithIdentifier("GoogleLoginVC") as? GoogleLoginController
                
                self.navigationController?.pushViewController(userInfoView!, animated: true)
            }))
            
            // 显示Sheet
            self.presentViewController(actionSheetController, animated: true, completion: nil)
        } else {
            UserBL.sharedSingleton.Subscriptions(channelId: "UCoXRFunEMD4Bzec_3yK7NTQ").continueWithSuccessBlock({ [weak self] (task: BFTask!) -> BFTask! in
                if let responseData = (task.result as? YTError) {
                    switch responseData.code {
                    case 400 where responseData.message == "The subscription that you are trying to create already exists." :
                        var alertView: UIAlertView = UIAlertView(title: "", message: "不用重复订阅", delegate: nil, cancelButtonTitle: "确定")
                        alertView.show()
                    case 401:
                        var actionSheetController: UIAlertController = UIAlertController(title: "", message: "需要登入YouTube，是否登入？", preferredStyle: UIAlertControllerStyle.Alert)
                        actionSheetController.addAction(UIAlertAction(title: "否", style: UIAlertActionStyle.Cancel, handler: { (alertAction) -> Void in
                            //
                        }))
                        actionSheetController.addAction(UIAlertAction(title: "是", style: UIAlertActionStyle.Default, handler: { (alertAction) -> Void in
                            let userInfoView = self!.storyboard!.instantiateViewControllerWithIdentifier("GoogleLoginVC") as? GoogleLoginController
                            
                            self!.navigationController?.pushViewController(userInfoView!, animated: true)
                        }))
                        
                        // 显示Sheet
                        self!.presentViewController(actionSheetController, animated: true, completion: nil)
                    default:
                        var alertView: UIAlertView = UIAlertView(title: "", message: "订阅失败", delegate: nil, cancelButtonTitle: "确定")
                        alertView.show()
                        
                    }
                    
                    if responseData.code == 400 && responseData.message != "The subscription that you are trying to create already exists." {
                        var alertView: UIAlertView = UIAlertView(title: "", message: "不用重复登入", delegate: nil, cancelButtonTitle: "确定")
                        alertView.show()
                    } else {
                        
                    }
                } else {
                    var alertView: UIAlertView = UIAlertView(title: "", message: "订阅成功", delegate: nil, cancelButtonTitle: "确定")
                    alertView.show()
                }
                
                return nil
            }).continueWithBlock({ [weak self] (task: BFTask!) -> BFTask! in
                
                return nil
            })
        }
        
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 按钮圆角
        subscribeButton.layer.masksToBounds = true
        subscribeButton.layer.cornerRadius = 6
        subscribeButton.layer.borderWidth = 1
        subscribeButton.layer.borderColor = UIColor.orangeColor().CGColor
        
        subscribeYoutubeButton.layer.masksToBounds = true
        subscribeYoutubeButton.layer.cornerRadius = 6
        subscribeYoutubeButton.layer.borderWidth = 1
        subscribeYoutubeButton.layer.borderColor = UIColor.orangeColor().CGColor
        
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
            totalString = "\(theTotal)人跟随"
        } else if theTotal < 10_000 {
            totalString = "\(theTotal / 1_000)千人跟随"
        } else {
            totalString = "\(theTotal / 10_000)万人跟随"
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
