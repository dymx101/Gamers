//
//  GameController.swift
//  Gamers
//
//  Created by 虚空之翼 on 15/7/20.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

import UIKit
import Bolts
import MJRefresh
import Kingfisher

class GameController: UICollectionViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var gameData = [Game]()
    
    @IBOutlet var gameView: UICollectionView!
    
    func loadNewData() {
        let gameBL = GameBL()
        gameBL.getAllGame().continueWithSuccessBlock ({ [weak self] (task: BFTask!) -> BFTask! in
            self!.gameData = (task.result as? [Game])!
            self?.collectionView!.reloadData()
            self?.collectionView?.header.endRefreshing()
            //println(self!.gameData)
            return nil
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 下拉刷新数据
        self.collectionView!.header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: "loadNewData")
        self.collectionView!.header.autoChangeAlpha = true;
        
        self.loadNewData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // 设置行数
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        if Double(gameData.count) % 2 > 0 {
            return gameData.count / 2 + 1
        } else {
            return gameData.count / 2
        }
    }
    // 设置列数
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if gameData.count/2 == section {
            return gameData.count % 2
        } else {
            return 2
        }
    }
    // 设置cell宽高
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        var frame  = self.view.frame;
        var width = frame.width
        width = CGFloat(width/2 - 15)
        //todo:设置高宽比例
        return CGSize(width: width, height: width * 380 / 270 + 20)
    }
    // 设置cell的间距
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets{
        return UIEdgeInsets(top:5, left: 10, bottom: 5, right: 10)
    }

    // 设置单元格内容
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("GameCell", forIndexPath: indexPath) as! GameCell

        let imageUrl = self.gameData[indexPath.section * 2 + indexPath.row].image.stringByReplacingOccurrencesOfString(" ", withString: "%20", options: NSStringCompareOptions.LiteralSearch, range: nil)
        cell.imageView.kf_setImageWithURL(NSURL(string: imageUrl)!)
        cell.textLabel.text = gameData[indexPath.section * 2 + indexPath.row].nameZh
        
        return cell
    }
    
    // 点击触发事件
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
//        NSLog("点击了第%ld个游戏", indexPath.section*2 + indexPath.row)    //行*2+列
//        var view = self.storyboard!.instantiateViewControllerWithIdentifier("VideoListView") as? VideoListController
//        self.navigationController?.pushViewController(view!, animated: true)
        
    }
    
    // 跳转传值
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //
        var videoListController = segue.destinationViewController as! VideoListController
        
        var cell = sender as! UICollectionViewCell
        var indexPath = self.gameView.indexPathForCell(cell)!
        var select = indexPath.section * 2 + indexPath.row
        videoListController.gameData = self.gameData[select]

    }
    
    
}
