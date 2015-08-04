//
//  VideoRelateController.swift
//  Gamers
//
//  Created by 虚空之翼 on 15/8/3.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

import UIKit
import MJRefresh
import Bolts
import Kingfisher

class VideoRelateController: UITableViewController, UITableViewDataSource, UITableViewDelegate {

    let videoBL = VideoBL()
    
    var videoData: Video!
    var videoRelateData = [Video]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        videoBL.getVideoRelate(videoData.videoId, offset: 0, count: 20).continueWithSuccessBlock({ [weak self] (task: BFTask!) -> BFTask! in
            self!.videoRelateData = (task.result as? [Video])!
            self?.tableView.reloadData()
            
            return nil
        })

        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    // 设置分区
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    // 设置表格行数
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return videoRelateData.count
    }

    // 设置单元格
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("VideoRelateCell", forIndexPath: indexPath) as! VideoRelateCell
        
        let imageUrl = self.videoRelateData[indexPath.row].imageSource.stringByReplacingOccurrencesOfString(" ", withString: "%20", options: NSStringCompareOptions.LiteralSearch, range: nil)
        cell.videoImage.kf_setImageWithURL(NSURL(string: imageUrl)!)

        cell.videoTitle.text = videoRelateData[indexPath.row].videoTitle
        cell.videoViews.text = String(videoRelateData[indexPath.row].views)
        
        return cell
    }

    // 点击视频触发
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //
        println("选中了：\(indexPath.row)")
        
        //var playerView = self.storyboard!.instantiateViewControllerWithIdentifier("PlayerView") as? PlayerViewController
        //playerView?.viewWillAppear(true)
        
        //playerView!.reloadPlayerView()
        var dataDict = ["data": videoRelateData[indexPath.row]]
        NSNotificationCenter.defaultCenter().postNotificationName("reloadPlayerViewNotification", object: nil, userInfo: dataDict)
        NSNotificationCenter.defaultCenter().postNotificationName("reloadVideoCommentNotification", object: nil, userInfo: dataDict)
        NSNotificationCenter.defaultCenter().postNotificationName("reloadVideoInfoNotification", object: nil, userInfo: dataDict)
        
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
