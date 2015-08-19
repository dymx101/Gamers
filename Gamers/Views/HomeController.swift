//
//  HomeController.swift
//  Gamers
//
//  Created by 虚空之翼 on 15/7/13.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

import UIKit
import SDCycleScrollView
import MJRefresh
import Alamofire
import SwiftyJSON
import Bolts
import RealmSwift
import SnapKit
import Social

class HomeController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!    //滚动视图
    @IBOutlet weak var contentView: UIView!         //滚动试图内容
    
    let channelBL = ChannelBL()
    let gameBL = GameBL()
    let sliderBL = SliderBL()
    
    // 轮播视图
    var cycleScrollView: SDCycleScrollView!
    var cycleTitles: [String] = []
    var cycleImagesURLStrings: [String]  = [];
    //新手推荐视图
    var newChannelView: UITableView!
    //游戏大咖视图
    var featuredChannelView: UITableView!
    // 4个热门游戏视图
    var hotGameView1: UITableView!
    var hotGameView2: UITableView!
    var hotGameView3: UITableView!
    var hotGameView4: UITableView!
    // 3个新游戏视图
    var newGameView1: UITableView!
    var newGameView2: UITableView!
    var newGameView3: UITableView!
    
    // 全局数据 //todo 整合在一起
    var hotGameData = [Game]()
    var newGameData = [Game]()
    
    var videoData = [Int: [Video]]()
    var gamesName  = [ 101: "", 102: "", 103: "", 104: "", 105: "", 106: "", 107: "", 108: "", 109: "" ]

    // 表格展开状态标记
    var expansionStatus = [ 101: false, 102: false, 103: false, 104: false, 105: false, 106: false, 107: false, 108: false, 109: false ]
    // 表格移动状态标记
    var moveStatus = [ 101: 0, 102: 0, 103: 0, 104: 0, 105: 0, 106: 0, 107: 0, 108: 0, 109: 0 ]
    
    
    // 刷新数据计数
    var refresh = 0
    // 停止刷新状态
    func stopRefensh(){
        self.refresh++
        if self.refresh >= 3 {
            self.scrollView.header.endRefreshing()
            refresh = 0
        }
    }
    
    func loadInitData() {
        sliderBL.getSliders(channel: "Home").continueWithSuccessBlock({ [weak self] (task: BFTask!) -> BFTask! in
            if let sliders = task.result as? [Slider] {
                for slider in sliders {
                    self!.cycleTitles.append(slider.title)
                    self!.cycleImagesURLStrings.append(slider.imageSmall)
                }
            }
            self!.cycleScrollView.titlesGroup = self!.cycleTitles
            self!.cycleScrollView.imageURLStringsGroup = self!.cycleImagesURLStrings
            self!.cycleTitles = []
            self!.cycleImagesURLStrings = [];

            return nil
        })
        
        
        channelBL.getRecommendChannel(channelType: "new", offset: 0, count: 6, order: "data").continueWithSuccessBlock({ [weak self] (task: BFTask!) -> BFTask! in
            self!.videoData[101] = (task.result as? [Video])
            self!.newChannelView.reloadData()
            
            return nil
        })
        
        channelBL.getRecommendChannel(channelType: "featured", offset: 0, count: 6, order: "data").continueWithSuccessBlock({ [weak self] (task: BFTask!) -> BFTask! in
            self!.videoData[102] = (task.result as? [Video])
            self!.featuredChannelView.reloadData()
            
            return nil
        })

    }
    
    
    func loadNewData() {
        //刷新插件BUG，临时方案，没解决
        scrollView.bringSubviewToFront(featuredChannelView)
        scrollView.bringSubviewToFront(newChannelView)
        scrollView.bringSubviewToFront(hotGameView1)
        scrollView.bringSubviewToFront(hotGameView2)
        scrollView.bringSubviewToFront(hotGameView3)
        scrollView.bringSubviewToFront(hotGameView4)
        scrollView.bringSubviewToFront(newGameView1)
        scrollView.bringSubviewToFront(newGameView2)
        scrollView.bringSubviewToFront(newGameView3)
        
//        for index in 101...109 {
//            scrollView.bringSubviewToFront(self.view.viewWithTag(index)!)
//        }
        
        // 后台进程获取数据
        sliderBL.getSliders(channel: "Home").continueWithSuccessBlock({ [weak self] (task: BFTask!) -> BFTask! in
            if let sliders = task.result as? [Slider] {
                for slider in sliders {
                    self!.cycleTitles.append(slider.title)
                    self!.cycleImagesURLStrings.append(slider.imageSmall)
                }
            }
            self!.cycleScrollView.titlesGroup = self!.cycleTitles
            self!.cycleScrollView.imageURLStringsGroup = self!.cycleImagesURLStrings
            self!.cycleTitles = []
            self!.cycleImagesURLStrings = [];
            
            self!.stopRefensh()
            
            return nil
        })
        
        // 新手频道推荐数据
        channelBL.getRecommendChannel(channelType: "new", offset: 0, count: 6, order: "data").continueWithSuccessBlock({ [weak self] (task: BFTask!) -> BFTask! in
            self!.videoData[101] = (task.result as? [Video])
            self!.newChannelView.reloadData()
            self!.stopRefensh()

            return nil
        })
        // 游戏大咖频道推荐数据
        channelBL.getRecommendChannel(channelType: "featured", offset: 0, count: 6, order: "data").continueWithSuccessBlock({ [weak self] (task: BFTask!) -> BFTask! in
            self!.videoData[102] = (task.result as? [Video])
            self!.newChannelView.reloadData()
            self!.stopRefensh()
 
            return nil
        })
        
        // 推荐游戏数据
        gameBL.getRecommendGame().continueWithSuccessBlock ({ [weak self] (task: BFTask!) -> BFTask! in
            if let games = task.result as? [Game] {
                
                for game in games {
                    if game.type == 1 {
                        self!.hotGameData.append(game)
                    } else {
                        self!.newGameData.append(game)
                    }
                }
                
                // 热门游戏
                for index in 103...106 {
                    self!.videoData[index]? = games[index-103].videos
                    self!.gamesName[index] = self!.hotGameData[index-103].nameZh

                    let view = self!.view.viewWithTag(index) as! UITableView
                    view.reloadData()
                }
                // 新游戏
                for index in 107...109 {
                    self!.videoData[index]? = games[index-103].videos
                    self!.gamesName[index] = self!.newGameData[index-107].nameZh
                    
                    let view = self!.view.viewWithTag(index) as! UITableView
                    view.reloadData()
                }
                
                
                //println("数据：\(self?.videoData)")
            }
            return nil
        })
        

        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 加载数据
        self.loadInitData()
        // 设定启动界面时间
        NSThread.sleepForTimeInterval(1.0)//延长3秒
        // 子页面PlayerView的导航栏返回按钮文字，可为空（去掉按钮文字）
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)

        // 下拉刷新数据
        scrollView.header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: "loadNewData")
        //scrollView.footer.hidden = true
        
        videoData[101] = [Video]()
        videoData[102] = [Video]()
        videoData[103] = [Video]()
        videoData[104] = [Video]()
        videoData[105] = [Video]()
        videoData[106] = [Video]()
        videoData[107] = [Video]()
        videoData[108] = [Video]()
        videoData[109] = [Video]()
        
        // 0、顶部轮播
        cycleScrollView = SDCycleScrollView(frame: CGRectMake(0, 0, self.view.frame.width, 160), imagesGroup: nil)
        cycleScrollView.backgroundColor = UIColor.grayColor()
        // 轮播视图的基本属性
        cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight
        cycleScrollView.infiniteLoop = true;
        cycleScrollView.delegate = self
        cycleScrollView.dotColor = UIColor.yellowColor() // 自定义分页控件小圆标颜色
        cycleScrollView.autoScrollTimeInterval = 4.0
        cycleScrollView.placeholderImage = UIImage(named: "sliders.png")

        contentView.addSubview(cycleScrollView)
        
        // MARK: 9个Table的视图界面布局
        
        // 1、添加新手推荐部分
        newChannelView = UITableView()
        newChannelView.scrollEnabled = false
        // 设置边框
        newChannelView.layer.borderWidth = 0.3
        newChannelView.layer.borderColor = UIColor.grayColor().CGColor
        // cell分割线边距，ios8处理
        if newChannelView.respondsToSelector("setSeparatorInset:") {
            newChannelView.separatorInset = UIEdgeInsetsMake(0, 5, 0, 5)
        }
        if newChannelView.respondsToSelector("setLayoutMargins:") {
            newChannelView.layoutMargins = UIEdgeInsetsMake(0, 5, 0, 5)
        }

        // 继承代理和数据源协议
        newChannelView.delegate = self
        newChannelView.dataSource = self

        // 注册自定义的Cell
        newChannelView.registerNib(UINib(nibName: "HomeVideoCell", bundle:nil), forCellReuseIdentifier: "HomeVideoCell")
        newChannelView.registerNib(UINib(nibName: "ChannelHeaderCell", bundle:nil), forCellReuseIdentifier: "ChannelHeaderCell")
        newChannelView.registerNib(UINib(nibName: "TableFooterCell", bundle:nil), forCellReuseIdentifier: "TableFooterCell")
        newChannelView.registerNib(UINib(nibName: "TableFooterAllCell", bundle:nil), forCellReuseIdentifier: "TableFooterAllCell")
        
        // 添加新手推荐视图
        newChannelView.tag = 101
        contentView.addSubview(newChannelView)
        // 位置布局
        newChannelView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(cycleScrollView.snp_bottom).offset(6)
            make.left.equalTo(contentView).offset(6)
            make.right.equalTo(contentView).offset(-6)
            make.height.equalTo(400)
        }
        
        
//        let footView = UIView()
//        newChannelView.tableFooterView = footView
//        footView.snp_makeConstraints { (make) -> Void in
//            make.top.equalTo(contentView).offset(6)
//            make.left.equalTo(contentView).offset(6)
//            make.right.equalTo(contentView).offset(-6)
//            make.height.equalTo(20)
//        }

        
        // 2、添加大咖推荐部分
        // 创建表视图
        featuredChannelView = UITableView()
        featuredChannelView.scrollEnabled = false
        featuredChannelView.layer.borderWidth = 0.3
        featuredChannelView.layer.borderColor = UIColor.grayColor().CGColor
        // cell分割线边距，ios8处理
        if featuredChannelView.respondsToSelector("setSeparatorInset:") {
            featuredChannelView.separatorInset = UIEdgeInsetsMake(0, 5, 0, 5)
        }
        if featuredChannelView.respondsToSelector("setLayoutMargins:") {
            featuredChannelView.layoutMargins = UIEdgeInsetsMake(0, 5, 0, 5)
        }
        
        // 继承代理和数据源协议
        featuredChannelView.delegate = self
        featuredChannelView.dataSource = self
        
        // 注册自定义的Cell
        featuredChannelView.registerNib(UINib(nibName: "HomeVideoCell", bundle:nil), forCellReuseIdentifier: "HomeVideoCell")
        featuredChannelView.registerNib(UINib(nibName: "ChannelHeaderCell", bundle:nil), forCellReuseIdentifier: "ChannelHeaderCell")
        featuredChannelView.registerNib(UINib(nibName: "TableFooterCell", bundle:nil), forCellReuseIdentifier: "TableFooterCell")
        featuredChannelView.registerNib(UINib(nibName: "TableFooterAllCell", bundle:nil), forCellReuseIdentifier: "TableFooterAllCell")
        
        // 添加大咖推荐视图
        featuredChannelView.tag = 102
        contentView.addSubview(featuredChannelView)
        // 位置布局
        featuredChannelView.snp_makeConstraints { (make) -> Void in
            //make.top.equalTo(newChannelView.snp_bottom).offset(6)
            make.top.equalTo(contentView).offset(576)
            make.left.equalTo(contentView).offset(6)
            make.right.equalTo(contentView).offset(-6)
            make.height.equalTo(400)
        }

        // 3、热门游戏1
        hotGameView1 = UITableView()
        hotGameView1.scrollEnabled = false
        hotGameView1.layer.borderWidth = 0.3
        hotGameView1.layer.borderColor = UIColor.grayColor().CGColor
        // cell分割线边距，ios8处理
        if hotGameView1.respondsToSelector("setSeparatorInset:") {
            hotGameView1.separatorInset = UIEdgeInsetsMake(0, 5, 0, 5)
        }
        if hotGameView1.respondsToSelector("setLayoutMargins:") {
            hotGameView1.layoutMargins = UIEdgeInsetsMake(0, 5, 0, 5)
        }
        
        // 继承代理和数据源协议
        hotGameView1.delegate = self
        hotGameView1.dataSource = self
        
        // 注册自定义的Cell
        hotGameView1.registerNib(UINib(nibName: "HomeVideoCell", bundle:nil), forCellReuseIdentifier: "HomeVideoCell")
        hotGameView1.registerNib(UINib(nibName: "GameHeaderCell", bundle:nil), forCellReuseIdentifier: "GameHeaderCell")
        hotGameView1.registerNib(UINib(nibName: "TableFooterCell", bundle:nil), forCellReuseIdentifier: "TableFooterCell")
        hotGameView1.registerNib(UINib(nibName: "TableFooterAllCell", bundle:nil), forCellReuseIdentifier: "TableFooterAllCell")

        // 添加热门游戏1视频
        hotGameView1.tag = 103
        contentView.addSubview(hotGameView1)
        // 位置布局
        hotGameView1.snp_makeConstraints { (make) -> Void in
            //make.top.equalTo(featuredChannelView.snp_bottom).offset(6)
            make.top.equalTo(contentView).offset(982)
            make.left.equalTo(contentView).offset(6)
            make.right.equalTo(contentView).offset(-6)
            make.height.equalTo(400)
        }
        
        // 4、热门游戏2
        hotGameView2 = UITableView()
        hotGameView2.scrollEnabled = false
        hotGameView2.layer.borderWidth = 0.3
        hotGameView2.layer.borderColor = UIColor.grayColor().CGColor
        // cell分割线边距，ios8处理
        if hotGameView2.respondsToSelector("setSeparatorInset:") {
            hotGameView2.separatorInset = UIEdgeInsetsMake(0, 5, 0, 5)
        }
        if hotGameView2.respondsToSelector("setLayoutMargins:") {
            hotGameView2.layoutMargins = UIEdgeInsetsMake(0, 5, 0, 5)
        }
        
        // 继承代理和数据源协议
        hotGameView2.delegate = self
        hotGameView2.dataSource = self
        
        // 注册自定义的Cell
        hotGameView2.registerNib(UINib(nibName: "HomeVideoCell", bundle:nil), forCellReuseIdentifier: "HomeVideoCell")
        hotGameView2.registerNib(UINib(nibName: "GameHeaderCell", bundle:nil), forCellReuseIdentifier: "GameHeaderCell")
        hotGameView2.registerNib(UINib(nibName: "TableFooterCell", bundle:nil), forCellReuseIdentifier: "TableFooterCell")
        hotGameView2.registerNib(UINib(nibName: "TableFooterAllCell", bundle:nil), forCellReuseIdentifier: "TableFooterAllCell")

        hotGameView2.tag = 104
        contentView.addSubview(hotGameView2)
        // 位置布局
        hotGameView2.snp_makeConstraints { (make) -> Void in
            //make.top.equalTo(hotGameView1.snp_bottom).offset(6)
            make.top.equalTo(contentView).offset(1388)
            make.left.equalTo(contentView).offset(6)
            make.right.equalTo(contentView).offset(-6)
            make.height.equalTo(400)
        }
        
        
        // 5、热门游戏3
        hotGameView3 = UITableView()
        hotGameView3.scrollEnabled = false
        hotGameView3.layer.borderWidth = 0.3
        hotGameView3.layer.borderColor = UIColor.grayColor().CGColor
        // cell分割线边距，ios8处理
        if hotGameView3.respondsToSelector("setSeparatorInset:") {
            hotGameView3.separatorInset = UIEdgeInsetsMake(0, 5, 0, 5)
        }
        if hotGameView3.respondsToSelector("setLayoutMargins:") {
            hotGameView3.layoutMargins = UIEdgeInsetsMake(0, 5, 0, 5)
        }
        
        // 继承代理和数据源协议
        hotGameView3.delegate = self
        hotGameView3.dataSource = self
        
        // 注册自定义的Cell
        hotGameView3.registerNib(UINib(nibName: "HomeVideoCell", bundle:nil), forCellReuseIdentifier: "HomeVideoCell")
        hotGameView3.registerNib(UINib(nibName: "GameHeaderCell", bundle:nil), forCellReuseIdentifier: "GameHeaderCell")
        hotGameView3.registerNib(UINib(nibName: "TableFooterCell", bundle:nil), forCellReuseIdentifier: "TableFooterCell")
        hotGameView3.registerNib(UINib(nibName: "TableFooterAllCell", bundle:nil), forCellReuseIdentifier: "TableFooterAllCell")

        hotGameView3.tag = 105
        contentView.addSubview(hotGameView3)
        // 位置布局
        hotGameView3.snp_makeConstraints { (make) -> Void in
            //make.top.equalTo(hotGameView2.snp_bottom).offset(6)
            make.top.equalTo(contentView).offset(1794)
            make.left.equalTo(contentView).offset(6)
            make.right.equalTo(contentView).offset(-6)
            make.height.equalTo(400)
        }
        
        // 6、热门游戏4
        hotGameView4 = UITableView()
        hotGameView4.scrollEnabled = false
        hotGameView4.layer.borderWidth = 0.3
        hotGameView4.layer.borderColor = UIColor.grayColor().CGColor
        // cell分割线边距，ios8处理
        if hotGameView4.respondsToSelector("setSeparatorInset:") {
            hotGameView4.separatorInset = UIEdgeInsetsMake(0, 5, 0, 5)
        }
        if hotGameView4.respondsToSelector("setLayoutMargins:") {
            hotGameView4.layoutMargins = UIEdgeInsetsMake(0, 5, 0, 5)
        }
        
        // 继承代理和数据源协议
        hotGameView4.delegate = self
        hotGameView4.dataSource = self
        
        // 注册自定义的Cell
        hotGameView4.registerNib(UINib(nibName: "HomeVideoCell", bundle:nil), forCellReuseIdentifier: "HomeVideoCell")
        hotGameView4.registerNib(UINib(nibName: "GameHeaderCell", bundle:nil), forCellReuseIdentifier: "GameHeaderCell")
        hotGameView4.registerNib(UINib(nibName: "TableFooterCell", bundle:nil), forCellReuseIdentifier: "TableFooterCell")
        hotGameView4.registerNib(UINib(nibName: "TableFooterAllCell", bundle:nil), forCellReuseIdentifier: "TableFooterAllCell")
        
        hotGameView4.tag = 106
        contentView.addSubview(hotGameView4)
        // 位置布局
        hotGameView4.snp_makeConstraints { (make) -> Void in
            //make.top.equalTo(hotGameView3.snp_bottom).offset(6)
            make.top.equalTo(contentView).offset(2200)
            make.left.equalTo(contentView).offset(6)
            make.right.equalTo(contentView).offset(-6)
            make.height.equalTo(400)
        }
        
        // 7、最新游戏1
        newGameView1 = UITableView()
        newGameView1.scrollEnabled = false
        newGameView1.layer.borderWidth = 0.3
        newGameView1.layer.borderColor = UIColor.grayColor().CGColor
        // cell分割线边距，ios8处理
        if newGameView1.respondsToSelector("setSeparatorInset:") {
            newGameView1.separatorInset = UIEdgeInsetsMake(0, 5, 0, 5)
        }
        if newGameView1.respondsToSelector("setLayoutMargins:") {
            newGameView1.layoutMargins = UIEdgeInsetsMake(0, 5, 0, 5)
        }
        
        // 继承代理和数据源协议
        newGameView1.delegate = self
        newGameView1.dataSource = self
        
        // 注册自定义的Cell
        newGameView1.registerNib(UINib(nibName: "HomeVideoCell", bundle:nil), forCellReuseIdentifier: "HomeVideoCell")
        newGameView1.registerNib(UINib(nibName: "GameHeaderCell", bundle:nil), forCellReuseIdentifier: "GameHeaderCell")
        newGameView1.registerNib(UINib(nibName: "TableFooterCell", bundle:nil), forCellReuseIdentifier: "TableFooterCell")
        newGameView1.registerNib(UINib(nibName: "TableFooterAllCell", bundle:nil), forCellReuseIdentifier: "TableFooterAllCell")

        newGameView1.tag = 107
        contentView.addSubview(newGameView1)
        // 位置布局
        newGameView1.snp_makeConstraints { (make) -> Void in
            //make.top.equalTo(hotGameView4.snp_bottom).offset(6)
            make.top.equalTo(contentView).offset(2606)
            make.left.equalTo(contentView).offset(6)
            make.right.equalTo(contentView).offset(-6)
            make.height.equalTo(400)
        }
        
        
        // 8、最新游戏2
        newGameView2 = UITableView()
        newGameView2.scrollEnabled = false
        newGameView2.layer.borderWidth = 0.3
        newGameView2.layer.borderColor = UIColor.grayColor().CGColor
        // cell分割线边距，ios8处理
        if newGameView2.respondsToSelector("setSeparatorInset:") {
            newGameView2.separatorInset = UIEdgeInsetsMake(0, 5, 0, 5)
        }
        if newGameView2.respondsToSelector("setLayoutMargins:") {
            newGameView2.layoutMargins = UIEdgeInsetsMake(0, 5, 0, 5)
        }
        
        // 继承代理和数据源协议
        newGameView2.delegate = self
        newGameView2.dataSource = self
        // 注册自定义的Cell
        newGameView2.registerNib(UINib(nibName: "HomeVideoCell", bundle:nil), forCellReuseIdentifier: "HomeVideoCell")
        newGameView2.registerNib(UINib(nibName: "GameHeaderCell", bundle:nil), forCellReuseIdentifier: "GameHeaderCell")
        newGameView2.registerNib(UINib(nibName: "TableFooterCell", bundle:nil), forCellReuseIdentifier: "TableFooterCell")
        newGameView2.registerNib(UINib(nibName: "TableFooterAllCell", bundle:nil), forCellReuseIdentifier: "TableFooterAllCell")
        
        newGameView2.tag = 108
        contentView.addSubview(newGameView2)
        // 位置布局
        newGameView2.snp_makeConstraints { (make) -> Void in
            //make.top.equalTo(newGameView1.snp_bottom).offset(6)
            make.top.equalTo(contentView).offset(3012)
            make.left.equalTo(contentView).offset(6)
            make.right.equalTo(contentView).offset(-6)
            make.height.equalTo(400)
        }

        
        // 9、最新游戏3
        newGameView3 = UITableView()
        newGameView3.scrollEnabled = false
        newGameView3.layer.borderWidth = 0.3
        newGameView3.layer.borderColor = UIColor.grayColor().CGColor
        // cell分割线边距，ios8处理
        if newGameView3.respondsToSelector("setSeparatorInset:") {
            newGameView3.separatorInset = UIEdgeInsetsMake(0, 5, 0, 5)
        }
        if newGameView3.respondsToSelector("setLayoutMargins:") {
            newGameView3.layoutMargins = UIEdgeInsetsMake(0, 5, 0, 5)
        }
        
        // 继承代理和数据源协议
        newGameView3.delegate = self
        newGameView3.dataSource = self
        
        // 注册自定义的Cell
        newGameView3.registerNib(UINib(nibName: "HomeVideoCell", bundle:nil), forCellReuseIdentifier: "HomeVideoCell")
        newGameView3.registerNib(UINib(nibName: "GameHeaderCell", bundle:nil), forCellReuseIdentifier: "GameHeaderCell")
        newGameView3.registerNib(UINib(nibName: "TableFooterCell", bundle:nil), forCellReuseIdentifier: "TableFooterCell")
        newGameView3.registerNib(UINib(nibName: "TableFooterAllCell", bundle:nil), forCellReuseIdentifier: "TableFooterAllCell")
        
        newGameView3.tag = 109
        contentView.addSubview(newGameView3)
        // 位置布局
        newGameView3.snp_makeConstraints { (make) -> Void in
            //make.top.equalTo(newGameView2.snp_bottom).offset(6)
            make.top.equalTo(contentView).offset(3418)
            make.left.equalTo(contentView).offset(6)
            make.right.equalTo(contentView).offset(-6)
            make.height.equalTo(400)
        }

        // 底部标签栏显示数字
        var items = self.tabBarController?.tabBar.items as! [UITabBarItem]
        items[2].badgeValue = "2"
        
        



    }
    
    // 一个分区
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    // 设置表格行数，展开和不展开两种情况
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.videoData[tableView.tag]!.count == 0 {
            return 0
        }
        
        if expansionStatus[tableView.tag]! {
            return self.videoData[tableView.tag]!.count + 2
        } else {
            return 5
        }

    }
    // 设置行高
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 50
        } else if indexPath.row == 4 && !expansionStatus[tableView.tag]! {
            return 50
        } else if indexPath.row == videoData[tableView.tag]!.count+1 && expansionStatus[tableView.tag]! {
            return 50
        } else {
            return 100
        }
    }

    
    // 设置单元格的内容（创建参数indexPath指定的单元）
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let viewTag = tableView.tag

        switch indexPath.row {
        // 表格头0行处理
        case 0 where tableView.isEqual(newChannelView):
            let cell = tableView.dequeueReusableCellWithIdentifier("ChannelHeaderCell", forIndexPath: indexPath) as! ChannelHeaderCell
            cell.imageView?.image = UIImage(named: "Icon-recommend")
            cell.hearderTitle.text = "新手推荐"
            
            return cell
        case 0 where tableView.isEqual(featuredChannelView):
            let cell = tableView.dequeueReusableCellWithIdentifier("ChannelHeaderCell", forIndexPath: indexPath) as! ChannelHeaderCell
            cell.imageView?.image = UIImage(named: "icon-great")
            cell.hearderTitle.text = "实况大咖"
            
            return cell
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier("GameHeaderCell", forIndexPath: indexPath) as! GameHeaderCell
            cell.gameName.text = gamesName[viewTag]
            cell.gameDetail.text = "游戏推荐"
            
            return cell
        // 表格底部最后行处理
        case 4 where !expansionStatus[viewTag]!:
            let cell = tableView.dequeueReusableCellWithIdentifier("TableFooterCell", forIndexPath: indexPath) as! TableFooterCell
            
            return cell
        case videoData[viewTag]!.count+1 where expansionStatus[viewTag]!:
            let cell = tableView.dequeueReusableCellWithIdentifier("TableFooterAllCell", forIndexPath: indexPath) as! TableFooterAllCell
            
            return cell
        // 中间部分
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier("HomeVideoCell", forIndexPath: indexPath) as! HomeVideoCell
            cell.channelName.text = self.videoData[viewTag]![indexPath.row-1].owner
            cell.videoTitle.text = self.videoData[viewTag]![indexPath.row-1].videoTitle
            
            let imageUrl = self.videoData[viewTag]![indexPath.row-1].imageSource.stringByReplacingOccurrencesOfString(" ", withString: "%20", options: NSStringCompareOptions.LiteralSearch, range: nil)
            cell.videoImage.kf_setImageWithURL(NSURL(string: imageUrl)!)
            
            cell.delegate = self
            cell.tag = viewTag + indexPath.row + 100
            
            return cell
        }
        
     }
    
    /**
    点击触发，第1个无反应，中间跳转到播放页面，最后一个展开或者跳转到全部视频
    */
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let viewTag = tableView.tag
        println("点击触发")
        if indexPath.row == 0 {
             println("无反应")
        } else if indexPath.row == 4 && !expansionStatus[viewTag]! {
            // 移动动画
            moveView(tableView)
            let dataView = self.view.viewWithTag(viewTag) as! UITableView
            dataView.reloadData()
        } else if indexPath.row == videoData[viewTag]!.count + 1 && expansionStatus[viewTag]!{
            // 跳转到不同的全部界面
            if viewTag == 101 || viewTag == 102 {
                let viewVC = self.storyboard!.instantiateViewControllerWithIdentifier("ChannelListVC") as? ChannelListController
                //view?.videoData = self.videoData[viewTag]![indexPath.row-1]
                
                self.navigationController?.pushViewController(viewVC!, animated: true)
            } else if viewTag >= 103 && viewTag <= 106 {
                let viewVC = self.storyboard!.instantiateViewControllerWithIdentifier("VideoListVC") as? VideoListController
                viewVC?.gameData = hotGameData[viewTag - 103]

                self.navigationController?.pushViewController(viewVC!, animated: true)
            } else {
                let viewVC = self.storyboard!.instantiateViewControllerWithIdentifier("VideoListVC") as? VideoListController
                viewVC?.gameData = newGameData[viewTag - 107]
                
                self.navigationController?.pushViewController(viewVC!, animated: true)
            }
        } else {
            let view = self.storyboard!.instantiateViewControllerWithIdentifier("PlayerViewVC") as? PlayerViewController
            view?.videoData = self.videoData[viewTag]![indexPath.row-1]
            
            self.navigationController?.pushViewController(view!, animated: true)
        }

    }
    
    func moveView(tableView: UITableView) {
        let viewTag = tableView.tag
        // 该tableView以及扩展
        expansionStatus[viewTag] = true

        // 扩展动画
        UIView.animateWithDuration(1, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self.view.viewWithTag(viewTag)?.frame.size.height = 700
            // 后面tableview都下移
            for var index = viewTag + 1; index <= 109; index++ {
                var moveHeight = (self.moveStatus[index]! + 1) * 300
                self.moveStatus[index]! += 1
                
                self.view.viewWithTag(index)?.transform = CGAffineTransformMakeTranslation(0, CGFloat(moveHeight))
            }
            
            self.view.viewWithTag(viewTag)!.snp_updateConstraints(closure: { (make) -> Void in
                make.height.equalTo(700)
            })
        }, completion: nil)
    }
    
    // cell分割线的边距
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if cell.respondsToSelector("setSeparatorInset:") {
            cell.separatorInset = UIEdgeInsetsMake(0, 5, 0, 5)
        }
        if cell.respondsToSelector("setLayoutMargins:") {
            cell.layoutMargins = UIEdgeInsetsMake(0, 5, 0, 5)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
    初始化全局尺寸
    */
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        var total = 0
        for (_, item) in expansionStatus {
            if item { total = total + 1 }
        }
        
        let height = 3825 + total * 300
        // iphone4s:3820，iphone5s:3730，iphone6:3630，iphone6p:3560   +180
        self.contentView.frame = CGRectMake(0, 0, self.view.frame.size.width, CGFloat(height) )
        self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, CGFloat(height))
        self.view.backgroundColor = UIColor.lightGrayColor()

    }
    
    override func viewWillAppear(animated: Bool) {
        // 播放页面返回后，重置导航条的透明属性，//todo:image_1.jpg需求更换下
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "image_1.jpg"),forBarMetrics: UIBarMetrics.CompactPrompt)
        self.navigationController?.navigationBar.shadowImage = UIImage(named: "image_1.jpg")
        self.navigationController?.navigationBar.translucent = false
        
    }
    
    
}


// MARK: - 顶部轮播的代理方法
extension HomeController: SDCycleScrollViewDelegate {
    func cycleScrollView(cycleScrollView: SDCycleScrollView!, didSelectItemAtIndex index: Int) {
        var view = self.storyboard!.instantiateViewControllerWithIdentifier("SliderVC") as? SliderController
        self.navigationController?.pushViewController(view!, animated: true)
    }
}
// MARK: - 表格行Cell代理
extension HomeController: MyCellDelegate {
    // 触发分享按钮事件
    func clickCellButton(sender: UITableViewCell) {
        let table = self.view.viewWithTag(sender.superview!.superview!.tag) as! UITableView
        var index: NSIndexPath = table.indexPathForCell(sender)!
        
        println("表格：\(sender.tag - index.row - 100)，行：\(index.row)")

        // 退出
        var actionSheetController: UIAlertController = UIAlertController()
        actionSheetController.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel) { (alertAction) -> Void in
            //code
        })
        // 关注频道
        actionSheetController.addAction(UIAlertAction(title: "关注", style: UIAlertActionStyle.Destructive) { (alertAction) -> Void in

            
            
        })
        // 分享到Facebook
        actionSheetController.addAction(UIAlertAction(title: "分享到Facebook", style: UIAlertActionStyle.Default) { (alertAction) -> Void in
            var slComposerSheet = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            slComposerSheet.setInitialText("share facebook")
            slComposerSheet.addImage(UIImage(named: "user.png"))
            slComposerSheet.addURL(NSURL(string: "http://www.facebook.com/"))
            self.presentViewController(slComposerSheet, animated: true, completion: nil)
            SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook)
            
            slComposerSheet.completionHandler = { (result: SLComposeViewControllerResult) in
                if result == .Done {
                    var alertView: UIAlertView = UIAlertView(title: "", message: "分享完成", delegate: nil, cancelButtonTitle: "确定")
                    alertView.show()
                }
            }
            
//            [SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook
            
        })
        // 分享到Twitter
        actionSheetController.addAction(UIAlertAction(title: "分享到Twitter", style: UIAlertActionStyle.Default) { (alertAction) -> Void in
            var slComposerSheet = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            slComposerSheet.setInitialText("share facebook")
            slComposerSheet.addImage(UIImage(named: "user.png"))
            slComposerSheet.addURL(NSURL(string: "http://www.facebook.com/"))
            self.presentViewController(slComposerSheet, animated: true, completion: nil)
            
            slComposerSheet.completionHandler = { (result: SLComposeViewControllerResult) in
                if result == .Done {
                    var alertView: UIAlertView = UIAlertView(title: "", message: "分享完成", delegate: nil, cancelButtonTitle: "确定")
                    alertView.show()
                }
            }
        })
        
        // 显示Sheet
        self.presentViewController(actionSheetController, animated: true, completion: nil)

    }
}



