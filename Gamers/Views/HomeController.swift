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
    var newChannelData = [Channel]()
    var featuredChannelData = [Channel]()
    var hotGameData = [Game]()
    var newGameData = [Game]()
    var hotGameVideo1Data = [Video]()
    var hotGameVideo2Data = [Video]()
    var hotGameVideo3Data = [Video]()
    var hotGameVideo4Data = [Video]()
    var newGameVideo1Data = [Video]()
    var newGameVideo2Data = [Video]()
    var newGameVideo3Data = [Video]()
    
 
    var videoData = [Int: [Object]]()
    
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

        channelBL.getChannel("new").continueWithSuccessBlock({ [weak self] (task: BFTask!) -> BFTask! in
            self!.videoData[101] = (task.result as? [Channel])
            self!.newChannelView.reloadData()

            return nil
        })
        channelBL.getChannel("featured").continueWithSuccessBlock({ [weak self] (task: BFTask!) -> BFTask! in
            self!.videoData[102] = (task.result as? [Channel])
            self!.featuredChannelView.reloadData()
            
            return nil
        })
    }
    
    
    func loadNewData() {
        
        // 新手频道推荐数据
        channelBL.getChannel("new").continueWithSuccessBlock({ [weak self] (task: BFTask!) -> BFTask! in
            self!.newChannelData = (task.result as? [Channel])!
            self!.newChannelView.reloadData()
            self!.stopRefensh()
            
            return nil
        })
        // 游戏大咖频道推荐数据
        channelBL.getChannel("featured").continueWithSuccessBlock({ [weak self] (task: BFTask!) -> BFTask! in
            self!.featuredChannelData = (task.result as? [Channel])!
            self!.featuredChannelView.reloadData()
            self!.stopRefensh()
            
            return nil
        })
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
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 加载数据
        self.loadInitData()
        
        // 子页面PlayerView的导航栏返回按钮文字，可为空（去掉按钮文字）
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)

        // 下拉刷新数据
        scrollView.header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: "loadNewData")
        
        videoData[101] = [Channel]()
        videoData[102] = [Channel]()
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
        cycleScrollView.placeholderImage = UIImage(named: "1.jgp")

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
        
        // 添加新手推荐视图
        newChannelView.tag = 101
        contentView.addSubview(newChannelView)
        // 位置布局
        newChannelView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(cycleScrollView.snp_bottom).offset(6)
            make.left.equalTo(contentView).offset(6)
            make.right.equalTo(contentView).offset(-32)
            make.height.equalTo(400)
        }

        
        // 2、添加大咖推荐部分
        // 创建表视图
        featuredChannelView = UITableView()
        featuredChannelView.scrollEnabled = false
        featuredChannelView.layer.borderWidth = 0.3
        featuredChannelView.layer.borderColor = UIColor.grayColor().CGColor
        // cell分割线边距，ios8处理
        if newChannelView.respondsToSelector("setSeparatorInset:") {
            newChannelView.separatorInset = UIEdgeInsetsMake(0, 5, 0, 5)
        }
        if newChannelView.respondsToSelector("setLayoutMargins:") {
            newChannelView.layoutMargins = UIEdgeInsetsMake(0, 5, 0, 5)
        }
        
        // 继承代理和数据源协议
        featuredChannelView.delegate = self
        featuredChannelView.dataSource = self
        
        // 注册自定义的Cell
        featuredChannelView.registerNib(UINib(nibName: "HomeVideoCell", bundle:nil), forCellReuseIdentifier: "HomeVideoCell")
        featuredChannelView.registerNib(UINib(nibName: "ChannelHeaderCell", bundle:nil), forCellReuseIdentifier: "ChannelHeaderCell")
        featuredChannelView.registerNib(UINib(nibName: "TableFooterCell", bundle:nil), forCellReuseIdentifier: "TableFooterCell")
        
        // 添加大咖推荐视图
        featuredChannelView.tag = 102
        contentView.addSubview(featuredChannelView)
        // 位置布局
        featuredChannelView.snp_makeConstraints { (make) -> Void in
            //make.top.equalTo(newChannelView.snp_bottom).offset(6)
            make.top.equalTo(contentView).offset(576)
            make.left.equalTo(contentView).offset(6)
            make.right.equalTo(contentView).offset(-32)
            make.height.equalTo(400)
        }

        // 3、热门游戏1
        hotGameView1 = UITableView()
        hotGameView1.scrollEnabled = false
        hotGameView1.layer.borderWidth = 0.3
        hotGameView1.layer.borderColor = UIColor.grayColor().CGColor
        // cell分割线边距，ios8处理
        if newChannelView.respondsToSelector("setSeparatorInset:") {
            newChannelView.separatorInset = UIEdgeInsetsMake(0, 5, 0, 5)
        }
        if newChannelView.respondsToSelector("setLayoutMargins:") {
            newChannelView.layoutMargins = UIEdgeInsetsMake(0, 5, 0, 5)
        }
        
        // 继承代理和数据源协议
        hotGameView1.delegate = self
        hotGameView1.dataSource = self
        
        // 注册自定义的Cell
        hotGameView1.registerNib(UINib(nibName: "HomeVideoCell", bundle:nil), forCellReuseIdentifier: "HomeVideoCell")
        hotGameView1.registerNib(UINib(nibName: "GameHeaderCell", bundle:nil), forCellReuseIdentifier: "GameHeaderCell")
        hotGameView1.registerNib(UINib(nibName: "TableFooterCell", bundle:nil), forCellReuseIdentifier: "TableFooterCell")

        // 添加热门游戏1视频
        hotGameView1.tag = 103
        contentView.addSubview(hotGameView1)
        // 位置布局
        hotGameView1.snp_makeConstraints { (make) -> Void in
            //make.top.equalTo(featuredChannelView.snp_bottom).offset(6)
            make.top.equalTo(contentView).offset(982)
            make.left.equalTo(contentView).offset(6)
            make.right.equalTo(contentView).offset(-32)
            make.height.equalTo(400)
        }
        
        // 4、热门游戏2
        hotGameView2 = UITableView()
        hotGameView2.scrollEnabled = false
        hotGameView2.layer.borderWidth = 0.3
        hotGameView2.layer.borderColor = UIColor.grayColor().CGColor
        // cell分割线边距，ios8处理
        if newChannelView.respondsToSelector("setSeparatorInset:") {
            newChannelView.separatorInset = UIEdgeInsetsMake(0, 5, 0, 5)
        }
        if newChannelView.respondsToSelector("setLayoutMargins:") {
            newChannelView.layoutMargins = UIEdgeInsetsMake(0, 5, 0, 5)
        }
        
        // 继承代理和数据源协议
        hotGameView2.delegate = self
        hotGameView2.dataSource = self
        
        // 注册自定义的Cell
        hotGameView2.registerNib(UINib(nibName: "HomeVideoCell", bundle:nil), forCellReuseIdentifier: "HomeVideoCell")
        hotGameView2.registerNib(UINib(nibName: "GameHeaderCell", bundle:nil), forCellReuseIdentifier: "GameHeaderCell")
        hotGameView2.registerNib(UINib(nibName: "TableFooterCell", bundle:nil), forCellReuseIdentifier: "TableFooterCell")

        hotGameView2.tag = 104
        contentView.addSubview(hotGameView2)
        // 位置布局
        hotGameView2.snp_makeConstraints { (make) -> Void in
            //make.top.equalTo(hotGameView1.snp_bottom).offset(6)
            make.top.equalTo(contentView).offset(1388)
            make.left.equalTo(contentView).offset(6)
            make.right.equalTo(contentView).offset(-32)
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

        hotGameView3.tag = 105
        contentView.addSubview(hotGameView3)
        // 位置布局
        hotGameView3.snp_makeConstraints { (make) -> Void in
            //make.top.equalTo(hotGameView2.snp_bottom).offset(6)
            make.top.equalTo(contentView).offset(1794)
            make.left.equalTo(contentView).offset(6)
            make.right.equalTo(contentView).offset(-32)
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
        
        hotGameView4.tag = 106
        contentView.addSubview(hotGameView4)
        // 位置布局
        hotGameView4.snp_makeConstraints { (make) -> Void in
            //make.top.equalTo(hotGameView3.snp_bottom).offset(6)
            make.top.equalTo(contentView).offset(2200)
            make.left.equalTo(contentView).offset(6)
            make.right.equalTo(contentView).offset(-32)
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

        newGameView1.tag = 107
        contentView.addSubview(newGameView1)
        // 位置布局
        newGameView1.snp_makeConstraints { (make) -> Void in
            //make.top.equalTo(hotGameView4.snp_bottom).offset(6)
            make.top.equalTo(contentView).offset(2606)
            make.left.equalTo(contentView).offset(6)
            make.right.equalTo(contentView).offset(-32)
            make.height.equalTo(400)
        }
        
        
        // 8、最新游戏2
        newGameView2 = UITableView()
        newGameView2.scrollEnabled = false
        newGameView2.layer.borderWidth = 0.3
        newGameView2.layer.borderColor = UIColor.grayColor().CGColor
        // cell分割线边距，ios8处理
        if hotGameView4.respondsToSelector("setSeparatorInset:") {
            hotGameView4.separatorInset = UIEdgeInsetsMake(0, 5, 0, 5)
        }
        if hotGameView4.respondsToSelector("setLayoutMargins:") {
            hotGameView4.layoutMargins = UIEdgeInsetsMake(0, 5, 0, 5)
        }
        
        // 继承代理和数据源协议
        newGameView2.delegate = self
        newGameView2.dataSource = self
        // 注册自定义的Cell
        newGameView2.registerNib(UINib(nibName: "HomeVideoCell", bundle:nil), forCellReuseIdentifier: "HomeVideoCell")
        newGameView2.registerNib(UINib(nibName: "GameHeaderCell", bundle:nil), forCellReuseIdentifier: "GameHeaderCell")
        newGameView2.registerNib(UINib(nibName: "TableFooterCell", bundle:nil), forCellReuseIdentifier: "TableFooterCell")
        
        newGameView2.tag = 108
        contentView.addSubview(newGameView2)
        // 位置布局
        newGameView2.snp_makeConstraints { (make) -> Void in
            //make.top.equalTo(newGameView1.snp_bottom).offset(6)
            make.top.equalTo(contentView).offset(3012)
            make.left.equalTo(contentView).offset(6)
            make.right.equalTo(contentView).offset(-32)
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
        
        newGameView3.tag = 109
        contentView.addSubview(newGameView3)
        // 位置布局
        newGameView3.snp_makeConstraints { (make) -> Void in
            //make.top.equalTo(newGameView2.snp_bottom).offset(6)
            make.top.equalTo(contentView).offset(3418)
            make.left.equalTo(contentView).offset(6)
            make.right.equalTo(contentView).offset(-32)
            make.height.equalTo(400)
        }


        
    
        let realm = Realm()
        gameBL.getRecommendGame().continueWithSuccessBlock ({ [weak self] (task: BFTask!) -> BFTask! in
            if let games = task.result as? [Game] {

                for game in games {
                    if game.type == 1 {
                        self!.hotGameData.append(game)
                    } else {
                        self!.newGameData.append(game)
                    }
                }
                
                //println(self!.newGameData)
                
                if !self!.hotGameData.isEmpty {
                    //hotGameView1HeaderTitle.text = self!.hotGameData[0].nameZh
                    var videoId = self!.hotGameData[0].videos.substringToIndex(advance(self!.hotGameData[0].videos.endIndex, -1)).componentsSeparatedByString(",")
                    var video = realm.objects(Video).filter("id in %@", videoId)
                    self!.hotGameVideo1Data.extend(video)
                    self!.hotGameView1.reloadData()
                    
                    //hotGameView2HeaderTitle.text = self!.hotGameData[1].nameZh
                    videoId = self!.hotGameData[1].videos.substringToIndex(advance(self!.hotGameData[1].videos.endIndex, -1)).componentsSeparatedByString(",")
                    video = realm.objects(Video).filter("id in %@", videoId)
                    self!.hotGameVideo2Data.extend(video)
                    self!.hotGameView2.reloadData()
                    
                    //hotGameView3HeaderTitle.text = self!.hotGameData[2].nameZh
                    videoId = self!.hotGameData[2].videos.substringToIndex(advance(self!.hotGameData[2].videos.endIndex, -1)).componentsSeparatedByString(",")
                    video = realm.objects(Video).filter("id in %@", videoId)
                    self!.hotGameVideo3Data.extend(video)
                    self!.hotGameView3.reloadData()
                    
                    //hotGameView4HeaderTitle.text = self!.hotGameData[3].nameZh
                    videoId = self!.hotGameData[3].videos.substringToIndex(advance(self!.hotGameData[3].videos.endIndex, -1)).componentsSeparatedByString(",")
                    video = realm.objects(Video).filter("id in %@", videoId)
                    self!.hotGameVideo4Data.extend(video)
                    self!.hotGameView4.reloadData()
                    
                    //newGameView1HeaderTitle.text = self!.newGameData[0].nameZh
                    videoId = self!.newGameData[0].videos.substringToIndex(advance(self!.newGameData[0].videos.endIndex, -1)).componentsSeparatedByString(",")
                    video = realm.objects(Video).filter("id in %@", videoId)
                    self!.newGameVideo1Data.extend(video)
                    self!.newGameView1.reloadData()
                    
                    //newGameView2HeaderTitle.text = self!.newGameData[1].nameZh
                    videoId = self!.newGameData[1].videos.substringToIndex(advance(self!.newGameData[1].videos.endIndex, -1)).componentsSeparatedByString(",")
                    video = realm.objects(Video).filter("id in %@", videoId)
                    self!.newGameVideo2Data.extend(video)
                    self!.newGameView2.reloadData()
                    
                    //newGameView3HeaderTitle.text = self!.newGameData[2].nameZh
                    videoId = self!.newGameData[2].videos.substringToIndex(advance(self!.newGameData[2].videos.endIndex, -1)).componentsSeparatedByString(",")
                    video = realm.objects(Video).filter("id in %@", videoId)
                    self!.newGameVideo3Data.extend(video)
                    self!.newGameView3.reloadData()
                }
                
                //println(self!.gameVideoData)
            }
            return nil
        })
        
        
        


    }
    
    // 一个分区
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    // 设置表格行数，展开和不展开两种情况
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
        } else {
            return 100
        }
    }

    
    // 设置单元格的内容（创建参数indexPath指定的单元）
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let viewTag = tableView.tag
        
        // 表格头部
        if indexPath.row == 0 {
            if tableView.isEqual(newChannelView) {
                let cell = tableView.dequeueReusableCellWithIdentifier("ChannelHeaderCell", forIndexPath: indexPath) as! ChannelHeaderCell
                cell.hearderTitle.text = "新手推荐"
                
                return cell
            } else if tableView.isEqual(featuredChannelView) {
                let cell = tableView.dequeueReusableCellWithIdentifier("ChannelHeaderCell", forIndexPath: indexPath) as! ChannelHeaderCell
                cell.hearderTitle.text = "实况大咖"
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier("GameHeaderCell", forIndexPath: indexPath) as! GameHeaderCell
                //cell.hearderTitle.text = "实况大咖"
                
                return cell
            }
        }
        
        // 表格底部
        if indexPath.row == 4 && !expansionStatus[viewTag]! {
            let cell = tableView.dequeueReusableCellWithIdentifier("TableFooterCell", forIndexPath: indexPath) as! TableFooterCell
            
            return cell
        } else if indexPath.row == videoData[viewTag]!.count+1 && expansionStatus[viewTag]! {
            let cell = tableView.dequeueReusableCellWithIdentifier("TableFooterCell", forIndexPath: indexPath) as! TableFooterCell
            
            return cell
        }

        // 中间部分
        if tableView.isEqual(newChannelView) || tableView.isEqual(featuredChannelView)  {
            let cell = tableView.dequeueReusableCellWithIdentifier("HomeVideoCell", forIndexPath: indexPath) as! HomeVideoCell
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("HomeVideoCell", forIndexPath: indexPath) as! HomeVideoCell
            
            return cell
        }
        
        
    

    }
    
    /**
    点击触发，第1个无反应，中间跳转到播放页面，最后一个展开或者跳转到全部视频
    */
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let viewTag = tableView.tag
        
        if indexPath.row == 0 {
             println("无反应")
        } else if indexPath.row == 4 && !expansionStatus[viewTag]! {
            // 移动动画
            moveView(tableView)
            let dataView = self.view.viewWithTag(viewTag) as! UITableView
            dataView.reloadData()
        } else if indexPath.row == videoData[viewTag]!.count + 1 && expansionStatus[viewTag]!{
             println("跳转到全部列表页面")
        } else {
             println("播放页面")
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

        println("尺寸变化\(total)")
        
        let height = 4040 + total * 300
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


// 顶部轮播的代理方法
extension HomeController: SDCycleScrollViewDelegate {
    func cycleScrollView(cycleScrollView: SDCycleScrollView!, didSelectItemAtIndex index: Int) {
        NSLog("---点击了第%ld张图片", index);
        var view = self.storyboard!.instantiateViewControllerWithIdentifier("sliderView") as? SliderController
        self.navigationController?.pushViewController(view!, animated: true)
        
    }
}








