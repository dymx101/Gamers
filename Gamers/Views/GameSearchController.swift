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
// TODO: 整合到GameController中，点击从右边滑进一个搜索栏
class GameSearchController: UICollectionViewController {
    
    var searchContentView: UIView!
    var searchBackgroundView: UIView!
    var autocompleteView: UITableView!
    var searchBarView: UIView!
    var searchBar: UISearchBar!
    var tapGesture: UITapGestureRecognizer!
    
    var gameListData = [Game]()
    var gamePage = 1                //页数,todo后期实现offset设定
    var gamePageCount = 20          //每页视频总数
    var keyword = ""                //搜索关键字
    
    var isNoMoreData: Bool = false  //解决控件不能自己判断BUG
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 下拉上拉刷新数据
        //self.collectionView!.header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: "loadNewData")
        self.collectionView!.footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: "loadMoreData")
        
        // 导航栏添加搜索框
        searchBarView = UIView(frame: CGRectMake(45, 0, self.view.frame.size.width, 44))
        searchBarView.backgroundColor = UIColor.whiteColor()
        
        searchBar = UISearchBar(frame: CGRectMake(0, 0, self.view.frame.size.width-85, 44))
        searchBar.searchBarStyle = UISearchBarStyle.Minimal
        searchBar.tintColor = self.navigationController?.navigationBar.barTintColor
        searchBar.showsBookmarkButton = false
        //searchBar.showsCancelButton = true
        searchBar.delegate = self
        searchBar.tag = 601
        //searchBar.becomeFirstResponder()
        searchBarView.addSubview(searchBar)
        
        //self.navigationController?.view.addSubview(searchBarView)
        self.navigationItem.titleView = searchBarView
        self.navigationItem.titleView?.sizeToFit()

        
        // 设置tableview顶部不在导航栏下
        self.edgesForExtendedLayout = UIRectEdge.None

        
        // 子页面PlayerView的导航栏返回按钮文字，可为空（去掉按钮文字）
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        
        self.collectionView?.footer.noticeNoMoreData()
    }
    
    /**
    下拉刷新数据
    */
    func loadNewData() {
        gamePage = 1
        keyword = searchBar.text
        GameBL.sharedSingleton.getSearchGame(gameName: keyword, page: gamePage, limit: gamePageCount).continueWithSuccessBlock ({ [weak self] (task: BFTask!) -> BFTask! in
            self!.gameListData = (task.result as? [Game])!
            self!.gamePage += 1
            
            self?.collectionView!.reloadData()
            
            return nil
        }).continueWithBlock({ [weak self] (task: BFTask!) -> BFTask! in
            if task.error != nil {
                println(task.error)
            }
            //self?.collectionView!.header.endRefreshing()
            self?.collectionView!.footer.resetNoMoreData()
            MBProgressHUD.hideHUDForView(self?.navigationController!.view, animated: true)
            
            return nil
        })
    }
    /**
    上拉加载更多数据
    */
    func loadMoreData() {
        keyword = searchBar.text
        if keyword == "" {
            self.collectionView?.footer.noticeNoMoreData()
        } else {
            GameBL.sharedSingleton.getSearchGame(gameName: keyword, page: gamePage, limit: gamePageCount).continueWithSuccessBlock ({ [weak self] (task: BFTask!) -> BFTask! in
                let newData = (task.result as? [Game])!
                
                if newData.isEmpty {
                    self?.collectionView?.footer.noticeNoMoreData()
                    self!.isNoMoreData = true
                } else {
                    self!.gameListData += newData
                    self!.gamePage += 1
                    
                    self?.collectionView?.footer.endRefreshing()
                    self?.collectionView!.reloadData()
                }
                
                return nil
            }).continueWithBlock({ [weak self] (task: BFTask!) -> BFTask! in
                if task.error != nil {
                    println(task.error)
                }
                if !self!.isNoMoreData {
                    self?.collectionView?.footer.endRefreshing()
                }
                
                return nil
            })
        }
        
    }
    
    // 跳转传值，当使用storyboard时候才可以使用该方法，要不然不会触发，纯代码可以使用didSelectItemAtIndexPath触发
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "GameSearchVideoListSegue" {
            // 定义列表控制器
            var videoListController = segue.destinationViewController as! VideoListController
            // 提取选中的游戏，把值传给列表页面
            var cell = sender as! UICollectionViewCell
            var indexPath = self.collectionView!.indexPathForCell(cell)!
            var select = indexPath.section * 2 + indexPath.row
            
            videoListController.gameData = self.gameListData[select]
            
            // 子页面PlayerView的导航栏返回按钮文字，可为空（去掉按钮文字）
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "游戏搜索", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        } else {
            // 子页面PlayerView的导航栏返回按钮文字，可为空（去掉按钮文字）
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

// MARK: - 集合代理协议
extension GameSearchController: UICollectionViewDataSource, UICollectionViewDelegate {
    // 设置行数
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        if gameListData.isEmpty {
            return 1
        } else {
            if Double(gameListData.count) % 2 > 0 {
                return gameListData.count / 2 + 1
            } else {
                return gameListData.count / 2
            }
        }
    }
    // 设置列数
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if gameListData.isEmpty {
            return 1
        } else {
            if gameListData.count/2 == section {
                return gameListData.count % 2
            } else {
                return 2
            }
        }
    }
    // 设置cell宽高
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if gameListData.isEmpty {
            return CGSize(width: self.view.frame.size.width-20, height: 71 )
        } else {
            var frame = self.view.frame;
            var width = CGFloat(frame.width/2 - 15)
            
            //todo:设置高宽比例
            //return CGSize(width: width, height: width * 380 / 270 ) //+20 //twitch格式
            return CGSize(width: width, height: width * 480 / 864 ) //+20
        }
    }
    // 设置cell的间距
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets{
        return UIEdgeInsets(top:10, left: 10, bottom: 0, right: 10)
    }
    // 设置单元格内容
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if gameListData.isEmpty {
            var cell = collectionView.dequeueReusableCellWithReuseIdentifier("GameSeachNoDataCell", forIndexPath: indexPath) as! UICollectionViewCell

            return cell
        } else {
            var cell = collectionView.dequeueReusableCellWithReuseIdentifier("GameSeachCell", forIndexPath: indexPath) as! GameCell
            cell.setGameData(self.gameListData[indexPath.section * 2 + indexPath.row])
            
            return cell
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        // 播放页面返回后，重置导航条的透明属性，//todo:image_1.jpg需求更换下
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "navigation-bar.png"),forBarMetrics: UIBarMetrics.CompactPrompt)
        self.navigationController?.navigationBar.shadowImage = UIImage(named: "navigation-bar.png")
        self.navigationController?.navigationBar.translucent = false
    }
}

// MARK: - 搜索代理
extension GameSearchController: UISearchBarDelegate {
    // 第一响应者时触发
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        // 显示搜索界面
        //self.tableView.addGestureRecognizer(tapGesture)
        
        return true
    }
    // 点击搜索
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        let hub = MBProgressHUD.showHUDAddedTo(self.navigationController!.view, animated: true)
        hub.labelText = "加载中..."
        // 搜索数据
        loadNewData()
        
        // 搜索提交后，收起键盘
        searchBar.resignFirstResponder()
    }
    // 点击取消时触发事件
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        println("canncel")
        
    }
    // 搜索内容发生变化时触发事件
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        // 显示搜索界面
    }
    // 搜索范围标签变化时
    func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        
    }
    
}