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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 加载数据
        self.loadNewData()
        
        
        
        
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
        newChannelView = UITableView(frame: CGRectMake(6, 170, self.view.frame.width-12, 380), style: UITableViewStyle.Plain)
        newChannelView.scrollEnabled = false
        // 创建一个重用的单元格，减少内存消耗
        newChannelView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "newChannelCell")
        newChannelView.layer.borderWidth = 0.3
        newChannelView.layer.borderColor = UIColor.grayColor().CGColor
        newChannelView.separatorInset.right = 20    //分割线的右边边距
        // 继承代理和数据源协议
        newChannelView.delegate = self
        newChannelView.dataSource = self
        // 表格的头部
        // TODO: 后期添加图标和描述，高度再增高
        var newChannelHeaderView = UIView(frame: CGRectMake(20, 0, view.bounds.size.width, 50))
        newChannelHeaderView.backgroundColor = UIColor.whiteColor()
        // 表格头部的图标
        let newChannelHeaderImageView = UIView(frame: CGRectMake(10, 6, 38, 38))
        newChannelHeaderImageView.backgroundColor = UIColor.redColor()
        newChannelHeaderView.addSubview(newChannelHeaderImageView)
        // 表格头部的标题
        let newChannelHeaderTitle = UILabel(frame: CGRectMake(56, 6, 300, 38))
        newChannelHeaderTitle.text = "新秀推荐"
        newChannelHeaderView.addSubview(newChannelHeaderTitle)
        // 表格头部的分割线
        let newChannelHeaderLineVIew = UIView(frame: CGRectMake(0, 50, view.bounds.size.width, 1))
        newChannelHeaderLineVIew.backgroundColor = UIColor.lightGrayColor()
        newChannelHeaderView.addSubview(newChannelHeaderLineVIew)
        
        newChannelView.tableHeaderView = newChannelHeaderView
        
        // 表格底部
        var newChannelFootView = UIView(frame: CGRectMake(0, 0, view.bounds.size.width, 30))
        newChannelFootView.backgroundColor = UIColor.whiteColor()
        // 显示全部的按钮
        let newChannelFootButton = UIButton(frame: CGRectMake(0, 0, view.bounds.size.width, 25))
        newChannelFootButton.setTitle("显示全部", forState: UIControlState.allZeros)
        newChannelFootButton.setTitleColor(UIColor.greenColor(), forState: UIControlState.Normal)
        newChannelFootView.addSubview(newChannelFootButton)
        // 表格底部的分割线
        let newChannelFootLineVIew = UIView(frame: CGRectMake(0, 0, view.bounds.size.width, 1))
        newChannelFootLineVIew.backgroundColor = UIColor.lightGrayColor()
        newChannelFootView.addSubview(newChannelFootLineVIew)

        newChannelView.tableFooterView = newChannelFootView
        
        // 添加新手推荐视图
        contentView.addSubview(newChannelView)

        
        // 2、添加大咖推荐部分
        // 创建表视图
        featuredChannelView = UITableView(frame: CGRectMake(6, 560, self.view.frame.width-12, 380), style: UITableViewStyle.Plain)
        featuredChannelView.scrollEnabled = false
        // 创建一个重用的单元格，减少内存消耗
        featuredChannelView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "featuredChannelCell")
        featuredChannelView.layer.borderWidth = 0.3
        featuredChannelView.layer.borderColor = UIColor.grayColor().CGColor
        featuredChannelView.separatorInset.right = 20    //分割线的右边边距
        // 继承代理和数据源协议
        featuredChannelView.delegate = self
        featuredChannelView.dataSource = self
        // 表格的头部
        var featuredChannelHeaderView = UIView(frame: CGRectMake(20, 0, view.bounds.size.width, 50))
        featuredChannelHeaderView.backgroundColor = UIColor.whiteColor()
        // 表格头部的图标
        let featuredChannelHeaderImageView = UIView(frame: CGRectMake(10, 6, 38, 38))
        featuredChannelHeaderImageView.backgroundColor = UIColor.redColor()
        featuredChannelHeaderView.addSubview(featuredChannelHeaderImageView)
        // 表格头部的标题
        let featuredChannelHeaderTitle = UILabel(frame: CGRectMake(56, 6, 300, 38))
        featuredChannelHeaderTitle.text = "游戏大咖"
        featuredChannelHeaderView.addSubview(featuredChannelHeaderTitle)
        // 表格头部的分割线
        let featuredChannelHeaderLineVIew = UIView(frame: CGRectMake(0, 50, view.bounds.size.width, 1))
        featuredChannelHeaderLineVIew.backgroundColor = UIColor.lightGrayColor()
        featuredChannelHeaderView.addSubview(featuredChannelHeaderLineVIew)
        
        featuredChannelView.tableHeaderView = featuredChannelHeaderView
        
        // 表格底部
        var featuredChannelFootView = UIView(frame: CGRectMake(0, 0, view.bounds.size.width, 30))
        featuredChannelFootView.backgroundColor = UIColor.whiteColor()
        // 显示全部的按钮
        let featuredChannelFootButton = UIButton(frame: CGRectMake(0, 0, view.bounds.size.width, 25))
        featuredChannelFootButton.setTitle("显示全部", forState: UIControlState.allZeros)
        featuredChannelFootButton.setTitleColor(UIColor.greenColor(), forState: UIControlState.Normal)
        featuredChannelFootView.addSubview(featuredChannelFootButton)
        // 表格底部的分割线
        let featuredChannelFootLineVIew = UIView(frame: CGRectMake(0, 0, view.bounds.size.width, 1))
        featuredChannelFootLineVIew.backgroundColor = UIColor.lightGrayColor()
        featuredChannelFootView.addSubview(featuredChannelFootLineVIew)

        featuredChannelView.tableFooterView = featuredChannelFootView
        
        contentView.addSubview(featuredChannelView)
        

        // 3、热门游戏1
        hotGameView1 = UITableView(frame: CGRectMake(6, 950, self.view.frame.width-12, 380), style: UITableViewStyle.Plain)
        hotGameView1.scrollEnabled = false
        // 创建一个重用的单元格，减少内存消耗
        hotGameView1.registerClass(UITableViewCell.self, forCellReuseIdentifier: "hotGame1Cell")
        hotGameView1.layer.borderWidth = 0.3
        hotGameView1.layer.borderColor = UIColor.grayColor().CGColor
        hotGameView1.separatorInset.right = 20    //分割线的右边边距
        // 继承代理和数据源协议
        hotGameView1.delegate = self
        hotGameView1.dataSource = self
        // 表格的头部
        var hotGameView1HeaderView = UIView(frame: CGRectMake(20, 0, view.bounds.size.width, 50))
        hotGameView1HeaderView.backgroundColor = UIColor.whiteColor()
        // 表格头部的图标
        let hotGameView1HeaderImageView = UIView(frame: CGRectMake(10, 6, 38, 38))
        hotGameView1HeaderImageView.backgroundColor = UIColor.redColor()
        hotGameView1HeaderView.addSubview(hotGameView1HeaderImageView)
        // 表格头部的标题
        let hotGameView1HeaderTitle = UILabel(frame: CGRectMake(56, 6, 300, 38))
        if !self.hotGameData.isEmpty {
            hotGameView1HeaderTitle.text = self.hotGameData[0].nameZh
        }
        hotGameView1HeaderView.addSubview(hotGameView1HeaderTitle)
        // 表格头部的分割线
        let hotGameView1HeaderLineVIew = UIView(frame: CGRectMake(0, 50, view.bounds.size.width, 1))
        hotGameView1HeaderLineVIew.backgroundColor = UIColor.lightGrayColor()
        hotGameView1HeaderView.addSubview(hotGameView1HeaderLineVIew)
        
        hotGameView1.tableHeaderView = hotGameView1HeaderView
        
        // 表格底部
        var hotGameView1FootView = UIView(frame: CGRectMake(0, 0, view.bounds.size.width, 30))
        hotGameView1FootView.backgroundColor = UIColor.whiteColor()
        // 显示全部的按钮
        let hotGameView1FootButton = UIButton(frame: CGRectMake(0, 0, view.bounds.size.width, 25))
        hotGameView1FootButton.setTitle("显示全部", forState: UIControlState.allZeros)
        hotGameView1FootButton.setTitleColor(UIColor.greenColor(), forState: UIControlState.Normal)
        hotGameView1FootView.addSubview(hotGameView1FootButton)
        // 表格底部的分割线
        let hotGameView1FootLineVIew = UIView(frame: CGRectMake(0, 0, view.bounds.size.width, 1))
        hotGameView1FootLineVIew.backgroundColor = UIColor.lightGrayColor()
        hotGameView1FootView.addSubview(hotGameView1FootLineVIew)
        
        hotGameView1.tableFooterView = hotGameView1FootView
        
        contentView.addSubview(hotGameView1)
        
        


        
        // 4、热门游戏2
        hotGameView2 = UITableView(frame: CGRectMake(6, 1340, self.view.frame.width-12, 380), style: UITableViewStyle.Plain)
        hotGameView2.scrollEnabled = false
        // 创建一个重用的单元格，减少内存消耗
        hotGameView2.registerClass(UITableViewCell.self, forCellReuseIdentifier: "hotGame2Cell")
        hotGameView2.layer.borderWidth = 0.3
        hotGameView2.layer.borderColor = UIColor.grayColor().CGColor
        hotGameView2.separatorInset.right = 20    //分割线的右边边距
        // 继承代理和数据源协议
        hotGameView2.delegate = self
        hotGameView2.dataSource = self
        // 表格的头部
        var hotGameView2HeaderView = UIView(frame: CGRectMake(20, 0, view.bounds.size.width, 50))
        hotGameView2HeaderView.backgroundColor = UIColor.whiteColor()
        // 表格头部的图标
        let hotGameView2HeaderImageView = UIView(frame: CGRectMake(10, 6, 38, 38))
        hotGameView2HeaderImageView.backgroundColor = UIColor.redColor()
        hotGameView2HeaderView.addSubview(hotGameView2HeaderImageView)
        // 表格头部的标题
        let hotGameView2HeaderTitle = UILabel(frame: CGRectMake(56, 6, 300, 38))
        hotGameView2HeaderTitle.text = "热门游戏2"
        hotGameView2HeaderView.addSubview(hotGameView2HeaderTitle)
        // 表格头部的分割线
        let hotGameView2HeaderLineVIew = UIView(frame: CGRectMake(0, 50, view.bounds.size.width, 1))
        hotGameView2HeaderLineVIew.backgroundColor = UIColor.lightGrayColor()
        hotGameView2HeaderView.addSubview(hotGameView2HeaderLineVIew)
        
        hotGameView2.tableHeaderView = hotGameView2HeaderView
        
        // 表格底部
        var hotGameView2FootView = UIView(frame: CGRectMake(0, 0, view.bounds.size.width, 30))
        hotGameView2FootView.backgroundColor = UIColor.whiteColor()
        // 显示全部的按钮
        let hotGameView2FootButton = UIButton(frame: CGRectMake(0, 0, view.bounds.size.width, 25))
        hotGameView2FootButton.setTitle("显示全部", forState: UIControlState.allZeros)
        hotGameView2FootButton.setTitleColor(UIColor.greenColor(), forState: UIControlState.Normal)
        hotGameView2FootView.addSubview(hotGameView2FootButton)
        // 表格底部的分割线
        let hotGameView2FootLineVIew = UIView(frame: CGRectMake(0, 0, view.bounds.size.width, 1))
        hotGameView2FootLineVIew.backgroundColor = UIColor.lightGrayColor()
        hotGameView2FootView.addSubview(hotGameView2FootLineVIew)
        
        hotGameView2.tableFooterView = hotGameView2FootView

        contentView.addSubview(hotGameView2)
        
        // 5、热门游戏3
        hotGameView3 = UITableView(frame: CGRectMake(6, 1730, self.view.frame.width-12, 380), style: UITableViewStyle.Plain)
        hotGameView3.scrollEnabled = false
        // 创建一个重用的单元格，减少内存消耗
        hotGameView3.registerClass(UITableViewCell.self, forCellReuseIdentifier: "hotGame3Cell")
        hotGameView3.layer.borderWidth = 0.3
        hotGameView3.layer.borderColor = UIColor.grayColor().CGColor
        hotGameView3.separatorInset.right = 20    //分割线的右边边距
        // 继承代理和数据源协议
        hotGameView3.delegate = self
        hotGameView3.dataSource = self
        // 表格的头部
        var hotGameView3HeaderView = UIView(frame: CGRectMake(20, 0, view.bounds.size.width, 50))
        hotGameView3HeaderView.backgroundColor = UIColor.whiteColor()
        // 表格头部的图标
        let hotGameView3HeaderImageView = UIView(frame: CGRectMake(10, 6, 38, 38))
        hotGameView3HeaderImageView.backgroundColor = UIColor.redColor()
        hotGameView3HeaderView.addSubview(hotGameView3HeaderImageView)
        // 表格头部的标题
        let hotGameView3HeaderTitle = UILabel(frame: CGRectMake(56, 6, 300, 38))
        hotGameView3HeaderTitle.text = "热门游戏3"
        hotGameView3HeaderView.addSubview(hotGameView3HeaderTitle)
        // 表格头部的分割线
        let hotGameView3HeaderLineVIew = UIView(frame: CGRectMake(0, 50, view.bounds.size.width, 1))
        hotGameView3HeaderLineVIew.backgroundColor = UIColor.lightGrayColor()
        hotGameView3HeaderView.addSubview(hotGameView3HeaderLineVIew)
        
        hotGameView3.tableHeaderView = hotGameView3HeaderView
        
        // 表格底部
        var hotGameView3FootView = UIView(frame: CGRectMake(0, 0, view.bounds.size.width, 30))
        hotGameView3FootView.backgroundColor = UIColor.whiteColor()
        // 显示全部的按钮
        let hotGameView3FootButton = UIButton(frame: CGRectMake(0, 0, view.bounds.size.width, 25))
        hotGameView3FootButton.setTitle("显示全部", forState: UIControlState.allZeros)
        hotGameView3FootButton.setTitleColor(UIColor.greenColor(), forState: UIControlState.Normal)
        hotGameView3FootView.addSubview(hotGameView3FootButton)
        // 表格底部的分割线
        let hotGameView3FootLineVIew = UIView(frame: CGRectMake(0, 0, view.bounds.size.width, 1))
        hotGameView3FootLineVIew.backgroundColor = UIColor.lightGrayColor()
        hotGameView3FootView.addSubview(hotGameView3FootLineVIew)
        
        hotGameView3.tableFooterView = hotGameView3FootView
        
        contentView.addSubview(hotGameView3)
        
        // 6、热门游戏4
        hotGameView4 = UITableView(frame: CGRectMake(6, 2120, self.view.frame.width-12, 380), style: UITableViewStyle.Plain)
        hotGameView4.scrollEnabled = false
        // 创建一个重用的单元格，减少内存消耗
        hotGameView4.registerClass(UITableViewCell.self, forCellReuseIdentifier: "hotGame4Cell")
        hotGameView4.layer.borderWidth = 0.3
        hotGameView4.layer.borderColor = UIColor.grayColor().CGColor
        hotGameView4.separatorInset.right = 20    //分割线的右边边距
        // 继承代理和数据源协议
        hotGameView4.delegate = self
        hotGameView4.dataSource = self
        // 表格的头部
        var hotGameView4HeaderView = UIView(frame: CGRectMake(20, 0, view.bounds.size.width, 50))
        hotGameView4HeaderView.backgroundColor = UIColor.whiteColor()
        // 表格头部的图标
        let hotGameView4HeaderImageView = UIView(frame: CGRectMake(10, 6, 38, 38))
        hotGameView4HeaderImageView.backgroundColor = UIColor.redColor()
        hotGameView4HeaderView.addSubview(hotGameView4HeaderImageView)
        // 表格头部的标题
        let hotGameView4HeaderTitle = UILabel(frame: CGRectMake(56, 6, 300, 38))
        hotGameView4HeaderTitle.text = "热门游戏4"
        hotGameView4HeaderView.addSubview(hotGameView4HeaderTitle)
        // 表格头部的分割线
        let hotGameView4HeaderLineVIew = UIView(frame: CGRectMake(0, 50, view.bounds.size.width, 1))
        hotGameView4HeaderLineVIew.backgroundColor = UIColor.lightGrayColor()
        hotGameView4HeaderView.addSubview(hotGameView4HeaderLineVIew)
        
        hotGameView4.tableHeaderView = hotGameView4HeaderView
        
        // 表格底部
        var hotGameView4FootView = UIView(frame: CGRectMake(0, 0, view.bounds.size.width, 30))
        hotGameView4FootView.backgroundColor = UIColor.whiteColor()
        // 显示全部的按钮
        let hotGameView4FootButton = UIButton(frame: CGRectMake(0, 0, view.bounds.size.width, 25))
        hotGameView4FootButton.setTitle("显示全部", forState: UIControlState.allZeros)
        hotGameView4FootButton.setTitleColor(UIColor.greenColor(), forState: UIControlState.Normal)
        hotGameView4FootView.addSubview(hotGameView4FootButton)
        // 表格底部的分割线
        let hotGameView4FootLineVIew = UIView(frame: CGRectMake(0, 0, view.bounds.size.width, 1))
        hotGameView4FootLineVIew.backgroundColor = UIColor.lightGrayColor()
        hotGameView4FootView.addSubview(hotGameView4FootLineVIew)
        
        hotGameView4.tableFooterView = hotGameView4FootView
        
        contentView.addSubview(hotGameView4)
        
        // 7、最新游戏1
        newGameView1 = UITableView(frame: CGRectMake(6, 2510, self.view.frame.width-12, 380), style: UITableViewStyle.Plain)
        newGameView1.scrollEnabled = false
        // 创建一个重用的单元格，减少内存消耗
        newGameView1.registerClass(UITableViewCell.self, forCellReuseIdentifier: "newGame1Cell")
        newGameView1.layer.borderWidth = 0.3
        newGameView1.layer.borderColor = UIColor.grayColor().CGColor
        newGameView1.separatorInset.right = 20    //分割线的右边边距
        // 继承代理和数据源协议
        newGameView1.delegate = self
        newGameView1.dataSource = self
        // 表格的头部
        var newGameView1HeaderView = UIView(frame: CGRectMake(20, 0, view.bounds.size.width, 50))
        newGameView1HeaderView.backgroundColor = UIColor.whiteColor()
        // 表格头部的图标
        let newGameView1HeaderImageView = UIView(frame: CGRectMake(10, 6, 38, 38))
        newGameView1HeaderImageView.backgroundColor = UIColor.redColor()
        newGameView1HeaderView.addSubview(newGameView1HeaderImageView)
        // 表格头部的标题
        let newGameView1HeaderTitle = UILabel(frame: CGRectMake(56, 6, 300, 38))
        newGameView1HeaderTitle.text = "最新游戏1"
        newGameView1HeaderView.addSubview(newGameView1HeaderTitle)
        // 表格头部的分割线
        let newGameView1HeaderLineVIew = UIView(frame: CGRectMake(0, 50, view.bounds.size.width, 1))
        newGameView1HeaderLineVIew.backgroundColor = UIColor.lightGrayColor()
        newGameView1HeaderView.addSubview(newGameView1HeaderLineVIew)
        
        newGameView1.tableHeaderView = newGameView1HeaderView
        
        // 表格底部
        var newGameView1FootView = UIView(frame: CGRectMake(0, 0, view.bounds.size.width, 30))
        hotGameView1FootView.backgroundColor = UIColor.whiteColor()
        // 显示全部的按钮
        let newGameView1FootButton = UIButton(frame: CGRectMake(0, 0, view.bounds.size.width, 25))
        newGameView1FootButton.setTitle("显示全部", forState: UIControlState.allZeros)
        newGameView1FootButton.setTitleColor(UIColor.greenColor(), forState: UIControlState.Normal)
        newGameView1FootView.addSubview(newGameView1FootButton)
        // 表格底部的分割线
        let newGameView1FootLineVIew = UIView(frame: CGRectMake(0, 0, view.bounds.size.width, 1))
        newGameView1FootLineVIew.backgroundColor = UIColor.lightGrayColor()
        newGameView1FootView.addSubview(newGameView1FootLineVIew)
        
        newGameView1.tableFooterView = newGameView1FootView
        
        contentView.addSubview(newGameView1)
        
        // 8、最新游戏2
        newGameView2 = UITableView(frame: CGRectMake(6, 2900, self.view.frame.width-12, 380), style: UITableViewStyle.Plain)
        newGameView2.scrollEnabled = false
        // 创建一个重用的单元格，减少内存消耗
        newGameView2.registerClass(UITableViewCell.self, forCellReuseIdentifier: "newGame2Cell")
        newGameView2.layer.borderWidth = 0.3
        newGameView2.layer.borderColor = UIColor.grayColor().CGColor
        newGameView2.separatorInset.right = 20    //分割线的右边边距
        // 继承代理和数据源协议
        newGameView2.delegate = self
        newGameView2.dataSource = self
        // 表格的头部
        var newGameView2HeaderView = UIView(frame: CGRectMake(20, 0, view.bounds.size.width, 50))
        newGameView2HeaderView.backgroundColor = UIColor.whiteColor()
        // 表格头部的图标
        let newGameView2HeaderImageView = UIView(frame: CGRectMake(10, 6, 38, 38))
        newGameView2HeaderImageView.backgroundColor = UIColor.redColor()
        newGameView2HeaderView.addSubview(newGameView2HeaderImageView)
        // 表格头部的标题
        let newGameView2HeaderTitle = UILabel(frame: CGRectMake(56, 6, 300, 38))
        newGameView2HeaderTitle.text = "最新游戏2"
        newGameView2HeaderView.addSubview(newGameView2HeaderTitle)
        // 表格头部的分割线
        let newGameView2HeaderLineVIew = UIView(frame: CGRectMake(0, 50, view.bounds.size.width, 1))
        newGameView2HeaderLineVIew.backgroundColor = UIColor.lightGrayColor()
        newGameView2HeaderView.addSubview(newGameView2HeaderLineVIew)
        
        newGameView2.tableHeaderView = newGameView2HeaderView
        
        // 表格底部
        var newGameView2FootView = UIView(frame: CGRectMake(0, 0, view.bounds.size.width, 30))
        hotGameView2FootView.backgroundColor = UIColor.whiteColor()
        // 显示全部的按钮
        let newGameView2FootButton = UIButton(frame: CGRectMake(0, 0, view.bounds.size.width, 25))
        newGameView2FootButton.setTitle("显示全部", forState: UIControlState.allZeros)
        newGameView2FootButton.setTitleColor(UIColor.greenColor(), forState: UIControlState.Normal)
        newGameView2FootView.addSubview(newGameView2FootButton)
        // 表格底部的分割线
        let newGameView2FootLineVIew = UIView(frame: CGRectMake(0, 0, view.bounds.size.width, 1))
        newGameView2FootLineVIew.backgroundColor = UIColor.lightGrayColor()
        newGameView2FootView.addSubview(newGameView2FootLineVIew)
        
        newGameView2.tableFooterView = newGameView2FootView
        
        contentView.addSubview(newGameView2)
        
        // 9、最新游戏3
        newGameView3 = UITableView(frame: CGRectMake(6, 3290, self.view.frame.width-12, 380), style: UITableViewStyle.Plain)
        newGameView3.scrollEnabled = false
        // 创建一个重用的单元格，减少内存消耗
        newGameView3.registerClass(UITableViewCell.self, forCellReuseIdentifier: "newGame3Cell")
        newGameView3.layer.borderWidth = 0.3
        newGameView3.layer.borderColor = UIColor.grayColor().CGColor
        newGameView3.separatorInset.right = 20    //分割线的右边边距
        // 继承代理和数据源协议
        newGameView3.delegate = self
        newGameView3.dataSource = self
        // 表格的头部
        var newGameView3HeaderView = UIView(frame: CGRectMake(20, 0, view.bounds.size.width, 50))
        newGameView3HeaderView.backgroundColor = UIColor.whiteColor()
        // 表格头部的图标
        let newGameView3HeaderImageView = UIView(frame: CGRectMake(10, 6, 38, 38))
        newGameView3HeaderImageView.backgroundColor = UIColor.redColor()
        newGameView3HeaderView.addSubview(newGameView3HeaderImageView)
        // 表格头部的标题
        let newGameView3HeaderTitle = UILabel(frame: CGRectMake(56, 6, 300, 38))
        newGameView3HeaderTitle.text = "最新游戏3"
        newGameView3HeaderView.addSubview(newGameView3HeaderTitle)
        // 表格头部的分割线
        let newGameView3HeaderLineVIew = UIView(frame: CGRectMake(0, 50, view.bounds.size.width, 1))
        newGameView3HeaderLineVIew.backgroundColor = UIColor.lightGrayColor()
        newGameView3HeaderView.addSubview(newGameView3HeaderLineVIew)
        
        newGameView3.tableHeaderView = newGameView3HeaderView
        
        // 表格底部
        var newGameView3FootView = UIView(frame: CGRectMake(0, 0, view.bounds.size.width, 30))
        hotGameView3FootView.backgroundColor = UIColor.whiteColor()
        // 显示全部的按钮
        let newGameView3FootButton = UIButton(frame: CGRectMake(0, 0, view.bounds.size.width, 25))
        newGameView3FootButton.setTitle("显示全部", forState: UIControlState.allZeros)
        newGameView3FootButton.setTitleColor(UIColor.greenColor(), forState: UIControlState.Normal)
        newGameView3FootView.addSubview(newGameView3FootButton)
        // 表格底部的分割线
        let newGameView3FootLineVIew = UIView(frame: CGRectMake(0, 0, view.bounds.size.width, 1))
        newGameView3FootLineVIew.backgroundColor = UIColor.lightGrayColor()
        newGameView3FootView.addSubview(newGameView3FootLineVIew)
        
        newGameView3.tableFooterView = newGameView3FootView
        
        contentView.addSubview(newGameView3)
        
        
    
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
                
                println(self!.newGameData)
                
                if !self!.hotGameData.isEmpty {
                    hotGameView1HeaderTitle.text = self!.hotGameData[0].nameZh
                    var videoId = self!.hotGameData[0].videos.substringToIndex(advance(self!.hotGameData[0].videos.endIndex, -1)).componentsSeparatedByString(",")
                    var video = realm.objects(Video).filter("id in %@", videoId)
                    self!.hotGameVideo1Data.extend(video)
                    self!.hotGameView1.reloadData()
                    
                    hotGameView2HeaderTitle.text = self!.hotGameData[1].nameZh
                    videoId = self!.hotGameData[1].videos.substringToIndex(advance(self!.hotGameData[1].videos.endIndex, -1)).componentsSeparatedByString(",")
                    video = realm.objects(Video).filter("id in %@", videoId)
                    self!.hotGameVideo2Data.extend(video)
                    self!.hotGameView2.reloadData()
                    
                    hotGameView3HeaderTitle.text = self!.hotGameData[2].nameZh
                    videoId = self!.hotGameData[2].videos.substringToIndex(advance(self!.hotGameData[2].videos.endIndex, -1)).componentsSeparatedByString(",")
                    video = realm.objects(Video).filter("id in %@", videoId)
                    self!.hotGameVideo3Data.extend(video)
                    self!.hotGameView3.reloadData()
                    
                    hotGameView4HeaderTitle.text = self!.hotGameData[3].nameZh
                    videoId = self!.hotGameData[3].videos.substringToIndex(advance(self!.hotGameData[3].videos.endIndex, -1)).componentsSeparatedByString(",")
                    video = realm.objects(Video).filter("id in %@", videoId)
                    self!.hotGameVideo4Data.extend(video)
                    self!.hotGameView4.reloadData()
                    
                    newGameView1HeaderTitle.text = self!.newGameData[0].nameZh
                    videoId = self!.newGameData[0].videos.substringToIndex(advance(self!.newGameData[0].videos.endIndex, -1)).componentsSeparatedByString(",")
                    video = realm.objects(Video).filter("id in %@", videoId)
                    self!.newGameVideo1Data.extend(video)
                    self!.newGameView1.reloadData()
                    
                    newGameView2HeaderTitle.text = self!.newGameData[1].nameZh
                    videoId = self!.newGameData[1].videos.substringToIndex(advance(self!.newGameData[1].videos.endIndex, -1)).componentsSeparatedByString(",")
                    video = realm.objects(Video).filter("id in %@", videoId)
                    self!.newGameVideo2Data.extend(video)
                    self!.newGameView2.reloadData()
                    
                    newGameView3HeaderTitle.text = self!.newGameData[2].nameZh
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
            return self.newChannelData.count
        case featuredChannelView:
            return self.featuredChannelData.count
        case hotGameView1:
            return hotGameVideo1Data.count
        case hotGameView2:
            return hotGameVideo2Data.count
        case hotGameView3:
            return hotGameVideo3Data.count
        case hotGameView4:
            return hotGameVideo4Data.count
        case newGameView1:
            return newGameVideo1Data.count
        case newGameView2:
            return newGameVideo2Data.count
        case newGameView3:
            return newGameVideo3Data.count
        default :
            return 0
        }
    }
    // 设置行高
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    // 设置单元格的内容（创建参数indexPath指定的单元）
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch tableView {
        case newChannelView:
            // 指定identify进行重用提高性能
            let identify: String = "newChannelCell"
            //var cell = tableView.dequeueReusableCellWithIdentifier(identify, forIndexPath: indexPath) as! UITableViewCell //刷新重影bug
            var cell = tableView.cellForRowAtIndexPath(indexPath)
            
            if cell == nil {
                cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: identify)
                cell!.accessoryType = UITableViewCellAccessoryType.None
                
                var imageView = UIImageView(image: UIImage(named: "1.jpg")!)
                imageView.frame = CGRectMake(10, 10, 160, 80)
                cell!.addSubview(imageView)
                
                var titleLabel = UILabel(frame: CGRectMake(180, 10, view.bounds.size.width-222, 40))
                titleLabel.text = newChannelData[indexPath.row].name
                titleLabel.font = UIFont.systemFontOfSize(14)
                //titleLabel.adjustsFontSizeToFitWidth = true
                //titleLabel.lineBreakMode = NSLineBreakMode.ByTruncatingMiddle
                titleLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
                titleLabel.numberOfLines = 0
                //titleLabel.backgroundColor = UIColor.grayColor()
                
                var channelLabel = UILabel(frame: CGRectMake(180, 50, view.bounds.size.width-222, 20))
                channelLabel.text = newChannelData[indexPath.row].details
                channelLabel.font = UIFont.systemFontOfSize(14)
                channelLabel.textColor = UIColor.grayColor()
                
                var detailLabel = UILabel(frame: CGRectMake(180, 70, view.bounds.size.width-222, 20))
                detailLabel.text = String(newChannelData[indexPath.row].videos)
                detailLabel.font = UIFont.systemFontOfSize(14)
                detailLabel.textColor = UIColor.grayColor()
                
                cell!.addSubview(titleLabel)
                cell!.addSubview(channelLabel)
                cell!.addSubview(detailLabel)
                
                var shareButton = UIButton(frame: CGRectMake(view.bounds.size.width-30, 10, 10, 25))
                shareButton.backgroundColor = UIColor.redColor()
                cell!.addSubview(shareButton)
                
            }
            
            return cell!
        case featuredChannelView:
            // 指定identify进行重用提高性能
            let identify: String = "featuredChannelCell"
            //let cell = tableView.dequeueReusableCellWithIdentifier(identify, forIndexPath: indexPath) as! UITableViewCell
            var cell = tableView.cellForRowAtIndexPath(indexPath)
            
            if cell == nil {
                cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: identify)
                cell!.accessoryType = UITableViewCellAccessoryType.None
                
                var imageView = UIImageView(image: UIImage(named: "2.jpg")!)
                imageView.frame = CGRectMake(10, 10, 160, 80)
                cell!.addSubview(imageView)
                
                // TODO: 两行多余省略号
                var titleLabel = UILabel(frame: CGRectMake(180, 10, view.bounds.size.width-222, 40))
                titleLabel.text = featuredChannelData[indexPath.row].name
                titleLabel.font = UIFont.systemFontOfSize(14)
                //titleLabel.adjustsFontSizeToFitWidth = true
                //titleLabel.lineBreakMode = NSLineBreakMode.ByTruncatingMiddle
                titleLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
                titleLabel.numberOfLines = 0
                //titleLabel.backgroundColor = UIColor.grayColor()
                
                var channelLabel = UILabel(frame: CGRectMake(180, 50, view.bounds.size.width-222, 20))
                channelLabel.text = featuredChannelData[indexPath.row].details
                channelLabel.font = UIFont.systemFontOfSize(14)
                channelLabel.textColor = UIColor.grayColor()
                
                var detailLabel = UILabel(frame: CGRectMake(180, 70, view.bounds.size.width-222, 20))
                detailLabel.text = String(featuredChannelData[indexPath.row].videos)
                detailLabel.font = UIFont.systemFontOfSize(14)
                detailLabel.textColor = UIColor.grayColor()
                
                cell!.addSubview(titleLabel)
                cell!.addSubview(channelLabel)
                cell!.addSubview(detailLabel)
                
                var shareButton = UIButton(frame: CGRectMake(view.bounds.size.width-30, 10, 10, 25))
                shareButton.backgroundColor = UIColor.redColor()
                cell!.addSubview(shareButton)
                
            }
            
            return cell!
        case hotGameView1:
            // 指定identify进行重用提高性能
            let identify: String = "hotGame1Cell"
            let cell = tableView.dequeueReusableCellWithIdentifier(identify, forIndexPath: indexPath) as! UITableViewCell
            cell.accessoryType = UITableViewCellAccessoryType.None
            
            //cell.textLabel?.text = newChannelObjects[indexPath.row]["name"] as? String
            
            var imageView = UIImageView(image: UIImage(named: "1.jpg")!)
            imageView.frame = CGRectMake(10, 10, 160, 80)
            cell.addSubview(imageView)
            
            var titleLabel = UILabel(frame: CGRectMake(180, 10, view.bounds.size.width-222, 40))
            titleLabel.text = hotGameVideo1Data[indexPath.row].videoTitle
            titleLabel.font = UIFont.systemFontOfSize(14)
            //titleLabel.adjustsFontSizeToFitWidth = true
            //titleLabel.lineBreakMode = NSLineBreakMode.ByTruncatingMiddle
            titleLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
            titleLabel.numberOfLines = 0
            //titleLabel.backgroundColor = UIColor.grayColor()
            
            var channelLabel = UILabel(frame: CGRectMake(180, 50, view.bounds.size.width-222, 20))
            channelLabel.text = "星际青年笨哥"
            channelLabel.font = UIFont.systemFontOfSize(14)
            channelLabel.textColor = UIColor.grayColor()
            
            var detailLabel = UILabel(frame: CGRectMake(180, 70, view.bounds.size.width-222, 20))
            detailLabel.text = "40万观看.2周前"
            detailLabel.font = UIFont.systemFontOfSize(14)
            detailLabel.textColor = UIColor.grayColor()
            
            cell.addSubview(titleLabel)
            cell.addSubview(channelLabel)
            cell.addSubview(detailLabel)
            
            var shareButton = UIButton(frame: CGRectMake(view.bounds.size.width-30, 10, 10, 25))
            shareButton.backgroundColor = UIColor.redColor()
            cell.addSubview(shareButton)
            
            
            //println("第\(indexPath.row)的数据：\(newChannelObjects[indexPath.row])")
            
            return cell

        case hotGameView2:
            // 指定identify进行重用提高性能
            let identify: String = "hotGame2Cell"
            let cell = tableView.dequeueReusableCellWithIdentifier(identify, forIndexPath: indexPath) as! UITableViewCell
            cell.accessoryType = UITableViewCellAccessoryType.None
            
            //cell.textLabel?.text = newChannelObjects[indexPath.row]["name"] as? String
            
            var imageView = UIImageView(image: UIImage(named: "1.jpg")!)
            imageView.frame = CGRectMake(10, 10, 160, 80)
            cell.addSubview(imageView)
            
            var titleLabel = UILabel(frame: CGRectMake(180, 10, view.bounds.size.width-222, 40))
            titleLabel.text = hotGameVideo2Data[indexPath.row].videoTitle
            titleLabel.font = UIFont.systemFontOfSize(14)
            //titleLabel.adjustsFontSizeToFitWidth = true
            //titleLabel.lineBreakMode = NSLineBreakMode.ByTruncatingMiddle
            titleLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
            titleLabel.numberOfLines = 0
            //titleLabel.backgroundColor = UIColor.grayColor()
            
            var channelLabel = UILabel(frame: CGRectMake(180, 50, view.bounds.size.width-222, 20))
            channelLabel.text = "星际青年笨哥"
            channelLabel.font = UIFont.systemFontOfSize(14)
            channelLabel.textColor = UIColor.grayColor()
            
            var detailLabel = UILabel(frame: CGRectMake(180, 70, view.bounds.size.width-222, 20))
            detailLabel.text = "40万观看.2周前"
            detailLabel.font = UIFont.systemFontOfSize(14)
            detailLabel.textColor = UIColor.grayColor()
            
            cell.addSubview(titleLabel)
            cell.addSubview(channelLabel)
            cell.addSubview(detailLabel)
            
            var shareButton = UIButton(frame: CGRectMake(view.bounds.size.width-30, 10, 10, 25))
            shareButton.backgroundColor = UIColor.redColor()
            cell.addSubview(shareButton)
            
            
            //println("第\(indexPath.row)的数据：\(newChannelObjects[indexPath.row])")
            
            return cell

        case hotGameView3:
            // 指定identify进行重用提高性能
            let identify: String = "hotGame3Cell"
            let cell = tableView.dequeueReusableCellWithIdentifier(identify, forIndexPath: indexPath) as! UITableViewCell
            cell.accessoryType = UITableViewCellAccessoryType.None
            
            //cell.textLabel?.text = newChannelObjects[indexPath.row]["name"] as? String
            
            var imageView = UIImageView(image: UIImage(named: "2.jpg")!)
            imageView.frame = CGRectMake(10, 10, 160, 80)
            cell.addSubview(imageView)
            
            var titleLabel = UILabel(frame: CGRectMake(180, 10, view.bounds.size.width-222, 40))
            titleLabel.text = hotGameVideo3Data[indexPath.row].videoTitle
            titleLabel.font = UIFont.systemFontOfSize(14)
            //titleLabel.adjustsFontSizeToFitWidth = true
            //titleLabel.lineBreakMode = NSLineBreakMode.ByTruncatingMiddle
            titleLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
            titleLabel.numberOfLines = 0
            //titleLabel.backgroundColor = UIColor.grayColor()
            
            var channelLabel = UILabel(frame: CGRectMake(180, 50, view.bounds.size.width-222, 20))
            channelLabel.text = "星际青年笨哥"
            channelLabel.font = UIFont.systemFontOfSize(14)
            channelLabel.textColor = UIColor.grayColor()
            
            var detailLabel = UILabel(frame: CGRectMake(180, 70, view.bounds.size.width-222, 20))
            detailLabel.text = "40万观看.2周前"
            detailLabel.font = UIFont.systemFontOfSize(14)
            detailLabel.textColor = UIColor.grayColor()
            
            cell.addSubview(titleLabel)
            cell.addSubview(channelLabel)
            cell.addSubview(detailLabel)
            
            var shareButton = UIButton(frame: CGRectMake(view.bounds.size.width-30, 10, 10, 25))
            shareButton.backgroundColor = UIColor.redColor()
            cell.addSubview(shareButton)
            
            
            //println("第\(indexPath.row)的数据：\(newChannelObjects[indexPath.row])")
            
            return cell

        case hotGameView4:
            // 指定identify进行重用提高性能
            let identify: String = "hotGame4Cell"
            let cell = tableView.dequeueReusableCellWithIdentifier(identify, forIndexPath: indexPath) as! UITableViewCell
            cell.accessoryType = UITableViewCellAccessoryType.None
            
            //cell.textLabel?.text = newChannelObjects[indexPath.row]["name"] as? String
            
            var imageView = UIImageView(image: UIImage(named: "1.jpg")!)
            imageView.frame = CGRectMake(10, 10, 160, 80)
            cell.addSubview(imageView)
            
            var titleLabel = UILabel(frame: CGRectMake(180, 10, view.bounds.size.width-222, 40))
            titleLabel.text = hotGameVideo4Data[indexPath.row].videoTitle
            titleLabel.font = UIFont.systemFontOfSize(14)
            //titleLabel.adjustsFontSizeToFitWidth = true
            //titleLabel.lineBreakMode = NSLineBreakMode.ByTruncatingMiddle
            titleLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
            titleLabel.numberOfLines = 0
            //titleLabel.backgroundColor = UIColor.grayColor()
            
            var channelLabel = UILabel(frame: CGRectMake(180, 50, view.bounds.size.width-222, 20))
            channelLabel.text = "星际青年笨哥"
            channelLabel.font = UIFont.systemFontOfSize(14)
            channelLabel.textColor = UIColor.grayColor()
            
            var detailLabel = UILabel(frame: CGRectMake(180, 70, view.bounds.size.width-222, 20))
            detailLabel.text = "40万观看.2周前"
            detailLabel.font = UIFont.systemFontOfSize(14)
            detailLabel.textColor = UIColor.grayColor()
            
            cell.addSubview(titleLabel)
            cell.addSubview(channelLabel)
            cell.addSubview(detailLabel)
            
            var shareButton = UIButton(frame: CGRectMake(view.bounds.size.width-30, 10, 10, 25))
            shareButton.backgroundColor = UIColor.redColor()
            cell.addSubview(shareButton)
            
            
            //println("第\(indexPath.row)的数据：\(newChannelObjects[indexPath.row])")
            
            return cell

        case newGameView1:
            // 指定identify进行重用提高性能
            let identify: String = "newGame1Cell"
            let cell = tableView.dequeueReusableCellWithIdentifier(identify, forIndexPath: indexPath) as! UITableViewCell
            cell.accessoryType = UITableViewCellAccessoryType.None
            
            //cell.textLabel?.text = newChannelObjects[indexPath.row]["name"] as? String
            
            var imageView = UIImageView(image: UIImage(named: "2.jpg")!)
            imageView.frame = CGRectMake(10, 10, 160, 80)
            cell.addSubview(imageView)
            
            var titleLabel = UILabel(frame: CGRectMake(180, 10, view.bounds.size.width-222, 40))
            titleLabel.text = newGameVideo1Data[indexPath.row].videoTitle
            titleLabel.font = UIFont.systemFontOfSize(14)
            //titleLabel.adjustsFontSizeToFitWidth = true
            //titleLabel.lineBreakMode = NSLineBreakMode.ByTruncatingMiddle
            titleLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
            titleLabel.numberOfLines = 0
            //titleLabel.backgroundColor = UIColor.grayColor()
            
            var channelLabel = UILabel(frame: CGRectMake(180, 50, view.bounds.size.width-222, 20))
            channelLabel.text = "星际青年笨哥"
            channelLabel.font = UIFont.systemFontOfSize(14)
            channelLabel.textColor = UIColor.grayColor()
            
            var detailLabel = UILabel(frame: CGRectMake(180, 70, view.bounds.size.width-222, 20))
            detailLabel.text = "40万观看.2周前"
            detailLabel.font = UIFont.systemFontOfSize(14)
            detailLabel.textColor = UIColor.grayColor()
            
            cell.addSubview(titleLabel)
            cell.addSubview(channelLabel)
            cell.addSubview(detailLabel)
            
            var shareButton = UIButton(frame: CGRectMake(view.bounds.size.width-30, 10, 10, 25))
            shareButton.backgroundColor = UIColor.redColor()
            cell.addSubview(shareButton)
            
            
            //println("第\(indexPath.row)的数据：\(newChannelObjects[indexPath.row])")
            
            return cell

        case newGameView2:
            // 指定identify进行重用提高性能
            let identify: String = "newGame2Cell"
            let cell = tableView.dequeueReusableCellWithIdentifier(identify, forIndexPath: indexPath) as! UITableViewCell
            cell.accessoryType = UITableViewCellAccessoryType.None
            
            //cell.textLabel?.text = newChannelObjects[indexPath.row]["name"] as? String
            
            var imageView = UIImageView(image: UIImage(named: "1.jpg")!)
            imageView.frame = CGRectMake(10, 10, 160, 80)
            cell.addSubview(imageView)
            
            var titleLabel = UILabel(frame: CGRectMake(180, 10, view.bounds.size.width-222, 40))
            titleLabel.text = newGameVideo2Data[indexPath.row].videoTitle
            titleLabel.font = UIFont.systemFontOfSize(14)
            //titleLabel.adjustsFontSizeToFitWidth = true
            //titleLabel.lineBreakMode = NSLineBreakMode.ByTruncatingMiddle
            titleLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
            titleLabel.numberOfLines = 0
            //titleLabel.backgroundColor = UIColor.grayColor()
            
            var channelLabel = UILabel(frame: CGRectMake(180, 50, view.bounds.size.width-222, 20))
            channelLabel.text = "星际青年笨哥"
            channelLabel.font = UIFont.systemFontOfSize(14)
            channelLabel.textColor = UIColor.grayColor()
            
            var detailLabel = UILabel(frame: CGRectMake(180, 70, view.bounds.size.width-222, 20))
            detailLabel.text = "40万观看.2周前"
            detailLabel.font = UIFont.systemFontOfSize(14)
            detailLabel.textColor = UIColor.grayColor()
            
            cell.addSubview(titleLabel)
            cell.addSubview(channelLabel)
            cell.addSubview(detailLabel)
            
            var shareButton = UIButton(frame: CGRectMake(view.bounds.size.width-30, 10, 10, 25))
            shareButton.backgroundColor = UIColor.redColor()
            cell.addSubview(shareButton)
            
            
            //println("第\(indexPath.row)的数据：\(newChannelObjects[indexPath.row])")
            
            return cell
        case newGameView3:
            // 指定identify进行重用提高性能
            let identify: String = "newGame3Cell"
            let cell = tableView.dequeueReusableCellWithIdentifier(identify, forIndexPath: indexPath) as! UITableViewCell
            cell.accessoryType = UITableViewCellAccessoryType.None
            
            //cell.textLabel?.text = newChannelObjects[indexPath.row]["name"] as? String
            
            var imageView = UIImageView(image: UIImage(named: "2.jpg")!)
            imageView.frame = CGRectMake(10, 10, 160, 80)
            cell.addSubview(imageView)
            
            var titleLabel = UILabel(frame: CGRectMake(180, 10, view.bounds.size.width-222, 40))
            titleLabel.text = newGameVideo3Data[indexPath.row].videoTitle
            titleLabel.font = UIFont.systemFontOfSize(14)
            //titleLabel.adjustsFontSizeToFitWidth = true
            //titleLabel.lineBreakMode = NSLineBreakMode.ByTruncatingMiddle
            titleLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
            titleLabel.numberOfLines = 0
            //titleLabel.backgroundColor = UIColor.grayColor()
            
            var channelLabel = UILabel(frame: CGRectMake(180, 50, view.bounds.size.width-222, 20))
            channelLabel.text = "星际青年笨哥"
            channelLabel.font = UIFont.systemFontOfSize(14)
            channelLabel.textColor = UIColor.grayColor()
            
            var detailLabel = UILabel(frame: CGRectMake(180, 70, view.bounds.size.width-222, 20))
            detailLabel.text = "40万观看.2周前"
            detailLabel.font = UIFont.systemFontOfSize(14)
            detailLabel.textColor = UIColor.grayColor()
            
            cell.addSubview(titleLabel)
            cell.addSubview(channelLabel)
            cell.addSubview(detailLabel)
            
            var shareButton = UIButton(frame: CGRectMake(view.bounds.size.width-30, 10, 10, 25))
            shareButton.backgroundColor = UIColor.redColor()
            cell.addSubview(shareButton)
            
            
            //println("第\(indexPath.row)的数据：\(newChannelObjects[indexPath.row])")
            
            return cell

        default :
            // TODO: 默认值需要设计？
            let cell = tableView.dequeueReusableCellWithIdentifier("11") as! UITableViewCell
            return cell
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
        self.view.frame = CGRectMake(0, 0, self.view.frame.width, 3810)
        self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 3810)
        self.view.backgroundColor = UIColor.lightGrayColor()
    }
    /**
    点击触发
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //
        //var gameController = segue.destinationViewController as! GameController
        NSLog("点击了表格行");
        
        //NSLog(segue.identifier!)
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








