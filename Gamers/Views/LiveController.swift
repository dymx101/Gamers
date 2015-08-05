//
//  LiveController.swift
//  Gamers
//
//  Created by 虚空之翼 on 15/7/20.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

import UIKit
import Bolts
import MJRefresh
import SwiftSpinner
import MBProgressHUD

class LiveController: UITableViewController, UITableViewDataSource, UITableViewDelegate {
    
    let videoBL = VideoBL()
    
    var liveVideoData = [Video]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 刷新插件
        self.tableView.header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: "loadNewData")
        self.tableView.header.autoChangeAlpha = true
        self.tableView.footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: "loadMoreData")
        self.tableView.footer.autoChangeAlpha = true
        
        
        //self.demoSpinner()

//        let hud = JGProgressHUD(style: JGProgressHUDStyle.Dark)
//        hud.textLabel.text = "加载中..."
//        hud.showInView(self.navigationController!.view)
//        hud.dismissAfterDelay(3)
        
        
        
        let hub = MBProgressHUD.showHUDAddedTo(self.navigationController!.view, animated: true)
        //hub.mode = MBProgressHUDMode.AnnularDeterminate
        hub.labelText = "加载中..."
            


        delay(seconds: 1.0, completion: {
            MBProgressHUD.hideHUDForView(self.navigationController!.view, animated: true)
        })
        
            
            
            
//        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
//            // Do something...
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [MBProgressHUD hideHUDForView:self.view animated:YES];
//                });
//            });
        
//        JGProgressHUD *HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
//        HUD.textLabel.text = @"Loading";
//        [HUD showInView:self.view];
//        [HUD dismissAfterDelay:3.0];
        
        
        
        // 子页面TwitchPlayerView的导航栏返回按钮文字，可为空（去掉按钮文字）
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func delay(#seconds: Double, completion:()->()) {
        let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64( Double(NSEC_PER_SEC) * seconds ))
        
        dispatch_after(popTime, dispatch_get_main_queue()) {
            completion()
        }
    }
    func demoSpinner() {
        
        SwiftSpinner.showWithDelay(2.0, title: "It's taking longer than expected")
        
        delay(seconds: 2.0, completion: {
            SwiftSpinner.show("Connecting \nto satellite...").addTapHandler({
                println("tapped")
                SwiftSpinner.hide()
                }, subtitle: "Tap to hide while connecting! This will affect only the current operation.")
        })
        
        delay(seconds: 6.0, completion: {
            SwiftSpinner.show("Authenticating user account")
        })
        
        delay(seconds: 10.0, completion: {
            SwiftSpinner.show("Failed to connect, waiting...", animated: false)
        })
        
        delay(seconds: 14.0, completion: {
            SwiftSpinner.setTitleFont(UIFont(name: "Futura", size: 22.0))
            SwiftSpinner.show("Retrying to authenticate")
        })
        
        delay(seconds: 18.0, completion: {
            SwiftSpinner.show("Connecting...")
        })
        
        delay(seconds: 21.0, completion: {
            SwiftSpinner.setTitleFont(nil)
            SwiftSpinner.show("Connected", animated: false)
        })
        
        delay(seconds: 22.0, completion: {
            SwiftSpinner.hide()
        })
        
        delay(seconds: 28.0, completion: {
           // self.demoSpinner()
        })
    }
    
    /**
    刷新数据
    */
    func loadNewData() {
        videoBL.getLiveVideo(0, count: 20).continueWithSuccessBlock({ [weak self] (task: BFTask!) -> BFTask! in
            self!.liveVideoData = (task.result as? [Video])!
            
            self?.tableView.reloadData()
            self?.tableView.header.endRefreshing()
            
            return nil
        })
    }
    /**
    加载更多数据
    */
    func loadMoreData() {
        videoBL.getLiveVideo(0, count: 20).continueWithSuccessBlock({ [weak self] (task: BFTask!) -> BFTask! in
            self!.liveVideoData = (task.result as? [Video])!
            
            self?.tableView.reloadData()
            //self?.videoTableView.footer.endRefreshing()
            self?.tableView.footer.noticeNoMoreData()
            return nil
        })
        
        NSLog("more data")
    }
    
    
    // 设置分区
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    // 设置表格行数
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return liveVideoData.count
    }
    // 设置行高
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row < 5 {
            return 140
        } else {
            return 64
        }
    }
    
    // 设置表格内容
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // 指定identify进行重用提高性能
        let liveCellIdentify: String = "LiveCell"
        
        var cell = tableView.cellForRowAtIndexPath(indexPath)
        // 分隔线右边距
        tableView.separatorInset.right = 20
        // 解决重影问题
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: liveCellIdentify)
            if indexPath.row < 5 {
                let image = UIImage(named: "1.jpg")
                let imageView = UIImageView(frame: CGRect(x: 10, y: 10, width: view.bounds.size.width-20, height: 120))
                imageView.image = image
                
                // 添加名称
                let name = UILabel(frame: CGRectMake(10, 100, view.bounds.size.width-20, 10))
                name.text = "老皮"
                name.textColor = UIColor.whiteColor()
                //cell.addSubview(name)
                
                // 添加在线人数
                let online = UILabel(frame: CGRectMake(10, 110, view.bounds.size.width-20, 10))
                online.text = "99人"
                online.textColor = UIColor.whiteColor()
                
                cell!.addSubview(imageView)

            } else {
                cell!.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                
                let imageView2 = UIView(frame: CGRectMake(10, 6, 100, 50))
                imageView2.backgroundColor = UIColor.grayColor()
                
                let name1 = UILabel(frame: CGRectMake(120, 6, view.bounds.size.width-130, 30))
                name1.text = "老皮"
                
                let name2 = UILabel(frame: CGRectMake(120, 30, view.bounds.size.width-130, 30))
                name2.text = "99人"
                
                cell!.addSubview(name1)
                cell!.addSubview(name2)

                cell!.addSubview(imageView2)
            }
        }
        
        return cell!

    }
    // 点击跳转到播放页面
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        NSLog("点击了第%ld个游戏", indexPath.row)
        var view = self.storyboard!.instantiateViewControllerWithIdentifier("TwitchPlayerVC") as? TwitchPlayerController
        view?.videoData = self.liveVideoData[indexPath.row]
        
        self.navigationController?.pushViewController(view!, animated: true)
    }

    
    override func viewWillAppear(animated: Bool) {
        // 播放页面返回后，重置导航条的透明属性，//todo:image_1.jpg需求更换下
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "image_1.jpg"),forBarMetrics: UIBarMetrics.CompactPrompt)
        self.navigationController?.navigationBar.shadowImage = UIImage(named: "image_1.jpg")
        self.navigationController?.navigationBar.translucent = false
    }
    
    
}