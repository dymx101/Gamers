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
    
    func loadNewData() {
        // 新手频道推荐数据
        let channelBL = ChannelBL()
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
        let sliderBL = SliderBL()
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
    
    func pushChannel(sender: AnyObject) {
        NSLog("跳转")
//        var view = self.storyboard!.instantiateViewControllerWithIdentifier("sliderView") as? SliderController
//        self.navigationController?.pushViewController(view!, animated: true)
        newChannelData = newChannelData+newChannelData
        
        newChannelView.reloadData()
        
        // 移动动画
        UIView.animateWithDuration(2, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.newChannelView.frame.size.height = 760                             //重设高度
            //self.newChannelView.transform = CGAffineTransformMakeTranslation(0, 50) //位置下移


        }, completion: nil)

        

        
        
        println(sender.tag)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 加载数据
        self.loadNewData()
        
        // 子页面PlayerView的导航栏返回按钮文字，可为空（去掉按钮文字）
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        
        
        let gameBL = GameBL()


        // 下拉刷新数据
        scrollView.header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: "loadNewData")
        scrollView.header.autoChangeAlpha = true;
        
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
        // 创建一个重用的单元格，减少内存消耗
        newChannelView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "newChannelCell")
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
        newChannelView.tag = 1
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
        // 创建一个重用的单元格，减少内存消耗
        featuredChannelView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "featuredChannelCell")
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
        contentView.addSubview(featuredChannelView)
        // 位置布局
        featuredChannelView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(newChannelView.snp_bottom).offset(6)
            make.left.equalTo(contentView).offset(6)
            make.right.equalTo(contentView).offset(-32)
            make.height.equalTo(400)
        }

        // 3、热门游戏1
        hotGameView1 = UITableView()
        hotGameView1.scrollEnabled = false
        // 创建一个重用的单元格，减少内存消耗
        hotGameView1.registerClass(UITableViewCell.self, forCellReuseIdentifier: "hotGame1Cell")
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
        hotGameView1.registerNib(UINib(nibName: "ChannelHeaderCell", bundle:nil), forCellReuseIdentifier: "ChannelHeaderCell")
        hotGameView1.registerNib(UINib(nibName: "TableFooterCell", bundle:nil), forCellReuseIdentifier: "TableFooterCell")

        //
        contentView.addSubview(hotGameView1)
        // 位置布局
        hotGameView1.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(featuredChannelView.snp_bottom).offset(6)
            make.left.equalTo(contentView).offset(6)
            make.right.equalTo(contentView).offset(-32)
            make.height.equalTo(400)
        }
        
        // 4、热门游戏2
        hotGameView2 = UITableView()
        hotGameView2.scrollEnabled = false
        // 创建一个重用的单元格，减少内存消耗
        hotGameView2.registerClass(UITableViewCell.self, forCellReuseIdentifier: "hotGame2Cell")
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
        hotGameView2.registerNib(UINib(nibName: "ChannelHeaderCell", bundle:nil), forCellReuseIdentifier: "ChannelHeaderCell")
        hotGameView2.registerNib(UINib(nibName: "TableFooterCell", bundle:nil), forCellReuseIdentifier: "TableFooterCell")

        contentView.addSubview(hotGameView2)
        // 位置布局
        hotGameView2.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(hotGameView1.snp_bottom).offset(6)
            make.left.equalTo(contentView).offset(6)
            make.right.equalTo(contentView).offset(-32)
            make.height.equalTo(400)
        }
        
        
        // 5、热门游戏3
        hotGameView3 = UITableView()
        hotGameView3.scrollEnabled = false
        // 创建一个重用的单元格，减少内存消耗
        hotGameView3.registerClass(UITableViewCell.self, forCellReuseIdentifier: "hotGame3Cell")
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
        hotGameView3.registerNib(UINib(nibName: "ChannelHeaderCell", bundle:nil), forCellReuseIdentifier: "ChannelHeaderCell")
        hotGameView3.registerNib(UINib(nibName: "TableFooterCell", bundle:nil), forCellReuseIdentifier: "TableFooterCell")

        contentView.addSubview(hotGameView3)
        // 位置布局
        hotGameView3.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(hotGameView2.snp_bottom).offset(6)
            make.left.equalTo(contentView).offset(6)
            make.right.equalTo(contentView).offset(-32)
            make.height.equalTo(400)
        }
        
        // 6、热门游戏4
        hotGameView4 = UITableView()
        hotGameView4.scrollEnabled = false
        // 创建一个重用的单元格，减少内存消耗
        hotGameView4.registerClass(UITableViewCell.self, forCellReuseIdentifier: "hotGame4Cell")
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
        hotGameView4.registerNib(UINib(nibName: "ChannelHeaderCell", bundle:nil), forCellReuseIdentifier: "ChannelHeaderCell")
        hotGameView4.registerNib(UINib(nibName: "TableFooterCell", bundle:nil), forCellReuseIdentifier: "TableFooterCell")
        
        contentView.addSubview(hotGameView4)
        // 位置布局
        hotGameView4.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(hotGameView3.snp_bottom).offset(6)
            make.left.equalTo(contentView).offset(6)
            make.right.equalTo(contentView).offset(-32)
            make.height.equalTo(400)
        }
        
        // 7、最新游戏1
        newGameView1 = UITableView()
        newGameView1.scrollEnabled = false
        // 创建一个重用的单元格，减少内存消耗
        newGameView1.registerClass(UITableViewCell.self, forCellReuseIdentifier: "newGame1Cell")
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
        newGameView1.registerNib(UINib(nibName: "ChannelHeaderCell", bundle:nil), forCellReuseIdentifier: "ChannelHeaderCell")
        newGameView1.registerNib(UINib(nibName: "TableFooterCell", bundle:nil), forCellReuseIdentifier: "TableFooterCell")

        contentView.addSubview(newGameView1)
        // 位置布局
        newGameView1.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(hotGameView4.snp_bottom).offset(6)
            make.left.equalTo(contentView).offset(6)
            make.right.equalTo(contentView).offset(-32)
            make.height.equalTo(400)
        }
        
        
        // 8、最新游戏2
        newGameView2 = UITableView()
        newGameView2.scrollEnabled = false
        // 创建一个重用的单元格，减少内存消耗
        newGameView2.registerClass(UITableViewCell.self, forCellReuseIdentifier: "newGame2Cell")
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
        newGameView2.registerNib(UINib(nibName: "ChannelHeaderCell", bundle:nil), forCellReuseIdentifier: "ChannelHeaderCell")
        newGameView2.registerNib(UINib(nibName: "TableFooterCell", bundle:nil), forCellReuseIdentifier: "TableFooterCell")
        
        contentView.addSubview(newGameView2)
        // 位置布局
        newGameView2.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(newGameView1.snp_bottom).offset(6)
            make.left.equalTo(contentView).offset(6)
            make.right.equalTo(contentView).offset(-32)
            make.height.equalTo(400)
        }

        
        // 9、最新游戏3
        newGameView3 = UITableView()
        newGameView3.scrollEnabled = false
        // 创建一个重用的单元格，减少内存消耗
        newGameView3.registerClass(UITableViewCell.self, forCellReuseIdentifier: "newGame3Cell")
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
        newGameView3.registerNib(UINib(nibName: "ChannelHeaderCell", bundle:nil), forCellReuseIdentifier: "ChannelHeaderCell")
        newGameView3.registerNib(UINib(nibName: "TableFooterCell", bundle:nil), forCellReuseIdentifier: "TableFooterCell")
        
        contentView.addSubview(newGameView3)
        // 位置布局
        newGameView3.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(newGameView2.snp_bottom).offset(6)
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
    // 设置表格行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case newChannelView:
            return self.newChannelData.count + 2
        case featuredChannelView:
            return self.featuredChannelData.count + 2
        case hotGameView1:
            return hotGameVideo1Data.count + 2
        case hotGameView2:
            return hotGameVideo2Data.count + 2
        case hotGameView3:
            return hotGameVideo3Data.count + 2
        case hotGameView4:
            return hotGameVideo4Data.count + 2
        case newGameView1:
            return newGameVideo1Data.count + 2
        case newGameView2:
            return newGameVideo2Data.count + 2
        case newGameView3:
            return newGameVideo3Data.count + 2
        default :
            return 0
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
        switch tableView {
        case newChannelView:
            // 表格头部
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier("ChannelHeaderCell", forIndexPath: indexPath) as! ChannelHeaderCell

                return cell
            // 表格底部
            } else if indexPath.row == newChannelData.count + 1 {
                let cell = tableView.dequeueReusableCellWithIdentifier("TableFooterCell", forIndexPath: indexPath) as! TableFooterCell
                
                return cell
            // 中间视频列表
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier("HomeVideoCell", forIndexPath: indexPath) as! HomeVideoCell
                
                return cell
            }
        case featuredChannelView:
            // 表格头部
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier("ChannelHeaderCell", forIndexPath: indexPath) as! ChannelHeaderCell
                
                return cell
                // 表格底部
            } else if indexPath.row == newChannelData.count + 1 {
                let cell = tableView.dequeueReusableCellWithIdentifier("TableFooterCell", forIndexPath: indexPath) as! TableFooterCell
                
                return cell
                // 中间视频列表
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier("HomeVideoCell", forIndexPath: indexPath) as! HomeVideoCell
                
                return cell
            }
        case hotGameView1:
            // 表格头部
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier("ChannelHeaderCell", forIndexPath: indexPath) as! ChannelHeaderCell
                
                return cell
                // 表格底部
            } else if indexPath.row == newChannelData.count + 1 {
                let cell = tableView.dequeueReusableCellWithIdentifier("TableFooterCell", forIndexPath: indexPath) as! TableFooterCell
                
                return cell
                // 中间视频列表
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier("HomeVideoCell", forIndexPath: indexPath) as! HomeVideoCell
                
                return cell
            }

        case hotGameView2:
            // 表格头部
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier("ChannelHeaderCell", forIndexPath: indexPath) as! ChannelHeaderCell
                
                return cell
                // 表格底部
            } else if indexPath.row == newChannelData.count + 1 {
                let cell = tableView.dequeueReusableCellWithIdentifier("TableFooterCell", forIndexPath: indexPath) as! TableFooterCell
                
                return cell
                // 中间视频列表
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier("HomeVideoCell", forIndexPath: indexPath) as! HomeVideoCell
                
                return cell
            }
        case hotGameView3:
            // 表格头部
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier("ChannelHeaderCell", forIndexPath: indexPath) as! ChannelHeaderCell
                
                return cell
                // 表格底部
            } else if indexPath.row == newChannelData.count + 1 {
                let cell = tableView.dequeueReusableCellWithIdentifier("TableFooterCell", forIndexPath: indexPath) as! TableFooterCell
                
                return cell
                // 中间视频列表
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier("HomeVideoCell", forIndexPath: indexPath) as! HomeVideoCell
                
                return cell
            }
        case hotGameView4:
            // 表格头部
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier("ChannelHeaderCell", forIndexPath: indexPath) as! ChannelHeaderCell
                
                return cell
                // 表格底部
            } else if indexPath.row == newChannelData.count + 1 {
                let cell = tableView.dequeueReusableCellWithIdentifier("TableFooterCell", forIndexPath: indexPath) as! TableFooterCell
                
                return cell
                // 中间视频列表
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier("HomeVideoCell", forIndexPath: indexPath) as! HomeVideoCell
                
                return cell
            }

        case newGameView1:
            // 表格头部
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier("ChannelHeaderCell", forIndexPath: indexPath) as! ChannelHeaderCell
                
                return cell
                // 表格底部
            } else if indexPath.row == newChannelData.count + 1 {
                let cell = tableView.dequeueReusableCellWithIdentifier("TableFooterCell", forIndexPath: indexPath) as! TableFooterCell
                
                return cell
                // 中间视频列表
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier("HomeVideoCell", forIndexPath: indexPath) as! HomeVideoCell
                
                return cell
            }
        case newGameView2:
            // 表格头部
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier("ChannelHeaderCell", forIndexPath: indexPath) as! ChannelHeaderCell
                
                return cell
                // 表格底部
            } else if indexPath.row == newChannelData.count + 1 {
                let cell = tableView.dequeueReusableCellWithIdentifier("TableFooterCell", forIndexPath: indexPath) as! TableFooterCell
                
                return cell
                // 中间视频列表
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier("HomeVideoCell", forIndexPath: indexPath) as! HomeVideoCell
                
                return cell
            }
        case newGameView3:
            // 表格头部
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier("ChannelHeaderCell", forIndexPath: indexPath) as! ChannelHeaderCell
                
                return cell
                // 表格底部
            } else if indexPath.row == newChannelData.count + 1 {
                let cell = tableView.dequeueReusableCellWithIdentifier("TableFooterCell", forIndexPath: indexPath) as! TableFooterCell
                
                return cell
                // 中间视频列表
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier("HomeVideoCell", forIndexPath: indexPath) as! HomeVideoCell
                
                return cell
            }

        default :
            // TODO: 默认值需要设计？
            let cell = tableView.dequeueReusableCellWithIdentifier("11") as! UITableViewCell
            return cell
        }
        

    }
    
    /**
    点击触发
    */
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        
        
        
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
        // iphone4s:3820，iphone5s:3730，iphone6:3630，iphone6p:3560   +180
        self.contentView.frame = CGRectMake(0, 0, self.view.frame.size.width, 4020)
        self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 4020)
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








