//
//  ViewController.swift
//  Gamers
//
//  Created by 虚空之翼 on 15/7/9.
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
import MBProgressHUD

class ViewController: UIViewController {
    
    var scrollView: UIScrollView!
    var contentView: UIView!
    
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
    
    
    func loadNewData() {
        
        newChannelView.reloadData()
        featuredChannelView.reloadData()
        hotGameView1.reloadData()
        hotGameView2.reloadData()
        hotGameView3.reloadData()
        hotGameView4.reloadData()
        newGameView1.reloadData()
        newGameView3.reloadData()
        newGameView2.reloadData()

        
        
        scrollView.header.endRefreshing()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        scrollView = UIScrollView(frame: self.view.bounds)
        scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 3852)
        
        contentView = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, 3852))
        contentView.backgroundColor = UIColor.grayColor()
        
        scrollView.addSubview(contentView)
        self.view.addSubview(scrollView)
        
        
        scrollView.header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: "loadNewData")
        
        
    
        // 0、顶部轮播
        cycleScrollView = SDCycleScrollView(frame: CGRectMake(0, 0, self.view.frame.width, 160), imagesGroup: nil)
        cycleScrollView.backgroundColor = UIColor.grayColor()
        // 轮播视图的基本属性
        cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight
        cycleScrollView.infiniteLoop = true;
        //cycleScrollView.delegate = self
        cycleScrollView.dotColor = UIColor.yellowColor() // 自定义分页控件小圆标颜色
        cycleScrollView.autoScrollTimeInterval = 4.0
        cycleScrollView.placeholderImage = UIImage(named: "sliders.png")
        
        contentView.addSubview(cycleScrollView)
        
        
        // 1、添加新手推荐部分
        newChannelView = UITableView(frame: CGRectMake(6, 166, self.view.frame.width, 400))
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
//        newChannelView.snp_makeConstraints { (make) -> Void in
//            make.top.equalTo(cycleScrollView.snp_bottom).offset(6)
//            make.left.equalTo(contentView).offset(6)
//            make.right.equalTo(contentView).offset(-6)
//            make.height.equalTo(400)
//        }

        // 2、添加大咖推荐部分
        // 创建表视图
        featuredChannelView = UITableView(frame: CGRectMake(6, 566, self.view.frame.width, 400))
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
//        featuredChannelView.snp_makeConstraints { (make) -> Void in
//            //make.top.equalTo(newChannelView.snp_bottom).offset(6)
//            make.top.equalTo(contentView).offset(572)
//            make.left.equalTo(contentView).offset(6)
//            make.right.equalTo(contentView).offset(-6)
//            make.height.equalTo(400)
//        }
        
        // 3、热门游戏1
        hotGameView1 = UITableView(frame: CGRectMake(6, 966, self.view.frame.width, 400))
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
//        hotGameView1.snp_makeConstraints { (make) -> Void in
//            //make.top.equalTo(featuredChannelView.snp_bottom).offset(6)
//            make.top.equalTo(contentView).offset(980)
//            make.left.equalTo(contentView).offset(6)
//            make.right.equalTo(contentView).offset(-6)
//            make.height.equalTo(400)
//        }

        // 4、热门游戏2
        hotGameView2 = UITableView(frame: CGRectMake(6, 1366, self.view.frame.width, 400))
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
//        hotGameView2.snp_makeConstraints { (make) -> Void in
//            //make.top.equalTo(hotGameView1.snp_bottom).offset(6)
//            make.top.equalTo(contentView).offset(1383)
//            make.left.equalTo(contentView).offset(6)
//            make.right.equalTo(contentView).offset(-6)
//            make.height.equalTo(400)
//        }
//        
        
        // 5、热门游戏3
        hotGameView3 = UITableView(frame: CGRectMake(6, 1766, self.view.frame.width, 400))
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
//        hotGameView3.snp_makeConstraints { (make) -> Void in
//            //make.top.equalTo(hotGameView2.snp_bottom).offset(6)
//            make.top.equalTo(contentView).offset(1790)
//            make.left.equalTo(contentView).offset(6)
//            make.right.equalTo(contentView).offset(-6)
//            make.height.equalTo(400)
//        }
        
        // 6、热门游戏4
        hotGameView4 = UITableView(frame: CGRectMake(6, 2166, self.view.frame.width, 400))
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
//        hotGameView4.snp_makeConstraints { (make) -> Void in
//            //make.top.equalTo(hotGameView3.snp_bottom).offset(6)
//            make.top.equalTo(contentView).offset(2196)
//            make.left.equalTo(contentView).offset(6)
//            make.right.equalTo(contentView).offset(-6)
//            make.height.equalTo(400)
//        }
        
        // 7、最新游戏1
        newGameView1 = UITableView(frame: CGRectMake(6, 2566, self.view.frame.width, 400))
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
//        newGameView1.snp_makeConstraints { (make) -> Void in
//            //make.top.equalTo(hotGameView4.snp_bottom).offset(6)
//            make.top.equalTo(contentView).offset(2602)
//            make.left.equalTo(contentView).offset(6)
//            make.right.equalTo(contentView).offset(-6)
//            make.height.equalTo(400)
//        }
        
        
        // 8、最新游戏2
        newGameView2 = UITableView(frame: CGRectMake(6, 2966, self.view.frame.width, 400))
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
//        newGameView2.snp_makeConstraints { (make) -> Void in
//            //make.top.equalTo(newGameView1.snp_bottom).offset(6)
//            make.top.equalTo(contentView).offset(3012)
//            make.left.equalTo(contentView).offset(6)
//            make.right.equalTo(contentView).offset(-6)
//            make.height.equalTo(400)
//        }
        
        
        // 9、最新游戏3
        newGameView3 = UITableView(frame: CGRectMake(6, 3366, self.view.frame.width, 400))
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
//        newGameView3.snp_makeConstraints { (make) -> Void in
//            //make.top.equalTo(newGameView2.snp_bottom).offset(6)
//            make.top.equalTo(contentView).offset(3414)
//            make.left.equalTo(contentView).offset(6)
//            make.right.equalTo(contentView).offset(-6)
//            make.height.equalTo(400)
//        }

    
    
    
    }


}

extension ViewController: UITableViewDelegate, UITableViewDataSource  {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("HomeVideoCell", forIndexPath: indexPath) as! HomeVideoCell
        
        
        
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("点击了：\(indexPath.row)")
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    
    
}

