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
import MBProgressHUD
import Haneke

class GameController: UICollectionViewController {

    var gameListData = [Game]()
    var gamePage = 1                // 页数,todo后期实现offset设定
    var gamePageCount = 20          //每页视频总数
    
    var isNoMoreData: Bool = false  //解决控件不能自己判断BUG
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 下拉上拉刷新数据
        self.collectionView!.header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: "loadNewData")
        self.collectionView!.footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: "loadMoreData")
        
        // 加载数据
        loadInitData()
        
    }
    
    /**
    初始化数据
    */
    func loadInitData() {
        let hub = MBProgressHUD.showHUDAddedTo(self.navigationController!.view, animated: true)
        hub.labelText = NSLocalizedString("Loading...", comment: "加載中...")
        
        GameBL.sharedSingleton.getAllGame(page: gamePage, limit: gamePageCount).continueWithSuccessBlock ({ [weak self] (task: BFTask!) -> BFTask! in
            self!.gameListData = (task.result as? [Game])!
            self!.gamePage += 1
            self?.collectionView!.reloadData()
            
            if self!.gameListData.count < self!.gamePageCount {
                self?.collectionView!.footer.noticeNoMoreData()
            }
            
            return nil
        }).continueWithBlock({ [weak self] (task: BFTask!) -> BFTask! in
            if task.error != nil { println(task.error) }
            MBProgressHUD.hideHUDForView(self!.navigationController!.view, animated: true)
            
            return nil
        })
    }

    /**
    下拉刷新数据
    */
    func loadNewData() {
        gamePage = 1
        GameBL.sharedSingleton.getAllGame(page: gamePage, limit: gamePageCount).continueWithSuccessBlock ({ [weak self] (task: BFTask!) -> BFTask! in
            self!.gameListData = (task.result as? [Game])!
            self!.gamePage += 1
            self?.collectionView!.reloadData()
            
            if self!.gameListData.count < self!.gamePageCount {
                self?.collectionView!.footer.noticeNoMoreData()
            } else {
                self?.collectionView!.footer.resetNoMoreData()
            }

            return nil
        }).continueWithBlock({ [weak self] (task: BFTask!) -> BFTask! in
            if task.error != nil { println(task.error) }
            self?.collectionView!.header.endRefreshing()
            self!.isNoMoreData = false
            
            return nil
        })
    }
    /**
    上拉加载更多数据
    */
    func loadMoreData() {
        GameBL.sharedSingleton.getAllGame(page: gamePage, limit: gamePageCount).continueWithSuccessBlock ({ [weak self] (task: BFTask!) -> BFTask! in
            let newData = (task.result as? [Game])!
            if newData.isEmpty {
                self?.collectionView?.footer.noticeNoMoreData()
                self!.isNoMoreData = true
            } else {
                if newData.count < self!.gamePageCount {
                    self!.isNoMoreData = true
                }
                
                self!.gameListData += newData
                self!.gamePage += 1
                self?.collectionView!.reloadData()
            }
            
            return nil
        }).continueWithBlock({ [weak self] (task: BFTask!) -> BFTask! in
            if task.error != nil { println(task.error) }
            if !self!.isNoMoreData {
                self?.collectionView?.footer.endRefreshing()
            }

            return nil
        })
    }
    
    // 跳转传值，当使用storyboard时候才可以使用该方法，要不然不会触发，纯代码可以使用didSelectItemAtIndexPath触发
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "GameVideoListSegue" {
            // 定义列表控制器
            var videoListController = segue.destinationViewController as! VideoListController
            // 提取选中的游戏，把值传给列表页面
            var cell = sender as! UICollectionViewCell
            var indexPath = self.collectionView!.indexPathForCell(cell)!
            var select = indexPath.section * 2 + indexPath.row
            
            videoListController.gameData = self.gameListData[select]
            
            // 子页面PlayerView的导航栏返回按钮文字，可为空（去掉按钮文字）
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil) //暂时去掉该功能
        } else {
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        // 播放页面返回后，重置导航条的透明属性，//todo:image_1.jpg需求更换下
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "navigation-bar1.png"),forBarMetrics: UIBarMetrics.CompactPrompt)
        self.navigationController?.navigationBar.shadowImage = UIImage(named: "navigation-bar1.png")
        self.navigationController?.navigationBar.translucent = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

// MARK: - 集合代理协议
extension GameController: UICollectionViewDataSource, UICollectionViewDelegate {
    // 设置行数
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        if Double(gameListData.count) % 2 > 0 {
            return gameListData.count / 2 + 1
        } else {
            return gameListData.count / 2
        }
    }
    // 设置列数
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if gameListData.count/2 == section {
            return gameListData.count % 2
        } else {
            return 2
        }
    }
    // 设置cell宽高
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        var frame = self.view.frame;
        var width = CGFloat(frame.width/2 - 15)
        
        //todo:设置高宽比例
//        return CGSize(width: width, height: width * 380 / 270 ) //+20 //twitch格式
        return CGSize(width: width, height: width * 480 / 864 ) //+20
    }
    // 设置cell的间距
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets{
        return UIEdgeInsets(top:10, left: 10, bottom: 0, right: 10)
    }
    // 设置单元格内容
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("GameCell", forIndexPath: indexPath) as! GameCell
        cell.setGameData(self.gameListData[indexPath.section * 2 + indexPath.row])

        return cell
    }
    
    //    // 点击触发事件
    //    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    //        NSLog("点击了第%ld个游戏", indexPath.section*2 + indexPath.row)    //行*2+列
    //        var view = self.storyboard!.instantiateViewControllerWithIdentifier("VideoListView") as? VideoListController
    //        self.navigationController?.pushViewController(view!, animated: true)
    //
    //    }
    
}
