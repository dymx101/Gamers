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


class HomeController: UIViewController, SDCycleScrollViewDelegate, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var scrollView: UIScrollView!    //滚动视图
    @IBOutlet weak var contentView: UIView!         //滚动试图内容
    
    var newChannelView: UITableView!        //新手推荐视图
    var featuredChannelView: UITableView!   //游戏大咖视图
//
//    //4个热门游戏视图
//    var hotGameView1: UITableView!
//    var hotGameView2: UITableView!
//    var hotGameView3: UITableView!
//    var hotGameView4: UITableView!
//    //4个新游戏视图
//    var newGameView1: UITableView!
//    var newGameView2: UITableView!
//    var newGameView3: UITableView!
    
    var newChannelObjects = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // 下拉刷新界面
//        scrollView.header = MJRefreshNormalHeader(refreshingBlock: { () -> Void in
//            //NSLog("1111111")
//        })
//        
//        scrollView.header.autoChangeAlpha = true;
//        scrollView.header.beginRefreshing()
//        
//        NSOperationQueue().addOperationWithBlock {
//            sleep(2)
//            NSOperationQueue.mainQueue().addOperationWithBlock {
//                self.scrollView.header.endRefreshing()
//            }
//        }
        
        // 顶部轮播
        let cycleScrollView = SDCycleScrollView(frame: CGRectMake(0, 0, self.view.frame.width, 160), imagesGroup: nil)

        var titles: [String] = []
        var imagesURLStrings: [String]  = [];
        // 轮播视图的基本属性
        cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight
        cycleScrollView.infiniteLoop = true;
        cycleScrollView.delegate = self
        cycleScrollView.dotColor = UIColor.yellowColor() // 自定义分页控件小圆标颜色
        cycleScrollView.autoScrollTimeInterval = 4.0

        let BL = SliderBL()
        BL.getSliders(channel: "Home").continueWithSuccessBlock({ [weak self] (task: BFTask!) -> BFTask! in
            for (index, value) in JSON(task.result) {
                titles.append(value["title"].string!)
                imagesURLStrings.append(value["image_small"].string!)
            }
            
            cycleScrollView.titlesGroup = titles
            cycleScrollView.imageURLStringsGroup = imagesURLStrings
            
            return nil
        })

        contentView.addSubview(cycleScrollView)
        
        
        // 添加新手推荐部分
        // 创建表视图
        newChannelView = UITableView(frame: CGRectMake(6, 170, self.view.frame.width-12, 200), style: UITableViewStyle.Plain)
        newChannelView.scrollEnabled = false
        
        newChannelView.delegate = self
        newChannelView.dataSource = self
        // 创建一个重用的单元格，重点了解重用机制
        newChannelView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "newChannelCell")
        
        newChannelView.layer.borderWidth = 0.3
        newChannelView.layer.borderColor = UIColor.grayColor().CGColor
        
        var headerView = UIView(frame: CGRectMake(20, 0, view.bounds.size.width, 30))
        headerView.backgroundColor = UIColor.whiteColor()
        let l1 = UIView(frame: CGRectMake(6, 6, 6, 20))
        l1.backgroundColor = UIColor.redColor()
        headerView.addSubview(l1)
        
        let t1 = UILabel(frame: CGRectMake(20, 6, 300, 20))
        t1.text = "新秀推荐"
        headerView.addSubview(t1)
        
        let lineVIew = UIView(frame: CGRectMake(0, 30, view.bounds.size.width, 1))
        lineVIew.backgroundColor = UIColor.lightGrayColor()
        headerView.addSubview(lineVIew)
        newChannelView.tableHeaderView = headerView
        
        newChannelView.separatorInset.right = 20    //分割线的右边边距
        
        contentView.addSubview(newChannelView)

        
        // 添加大咖推荐部分
        // 创建表视图
        featuredChannelView = UITableView(frame: CGRectMake(6, 390, self.view.frame.width-12, 200), style: UITableViewStyle.Plain)
        featuredChannelView.scrollEnabled = false
        
        featuredChannelView.delegate = self
        featuredChannelView.dataSource = self
        // 创建一个重用的单元格，重点了解重用机制
        featuredChannelView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "featuredChannelCell")
        
        featuredChannelView.layer.borderWidth = 0.3
        featuredChannelView.layer.borderColor = UIColor.grayColor().CGColor
        
        var headerView2 = UIView(frame: CGRectMake(20, 0, view.bounds.size.width, 30))
        headerView2.backgroundColor = UIColor.whiteColor()
        let l12 = UIView(frame: CGRectMake(6, 6, 6, 20))
        l12.backgroundColor = UIColor.redColor()
        headerView2.addSubview(l12)
        
        let t12 = UILabel(frame: CGRectMake(20, 6, 300, 20))
        t12.text = "游戏大咖"
        headerView2.addSubview(t12)
        
        let lineVIew2 = UIView(frame: CGRectMake(0, 30, view.bounds.size.width, 1))
        lineVIew2.backgroundColor = UIColor.lightGrayColor()
        headerView2.addSubview(lineVIew2)
        featuredChannelView.tableHeaderView = headerView2

        featuredChannelView.separatorInset.right = 20    //分割线的右边边距
        
        contentView.addSubview(featuredChannelView)
        

        
        
//        // 添加新手推荐部分
//        let l1 = UIView(frame: CGRectMake(6, 170, 6, 20))
//        l1.backgroundColor = UIColor.redColor()
//        contentView.addSubview(l1)
//        
//        let t1 = UILabel(frame: CGRectMake(14, 170, 300, 20))
//        t1.text = "新秀推荐"
//        contentView.addSubview(t1)
//        
//        let v1 = UIView(frame: CGRectMake(0, 195, self.view.frame.width, 100))
//        v1.backgroundColor = UIColor.grayColor()
//        contentView.addSubview(v1)
//        
//        
//        let l2 = UIView(frame: CGRectMake(6, 305, 6, 20))
//        l2.backgroundColor = UIColor.redColor()
//        contentView.addSubview(l2)
//        
//        let t2 = UILabel(frame: CGRectMake(14, 305, 300, 20))
//        t2.text = "实况大咖"
//        contentView.addSubview(t2)
//        
//        let v2 = UIView(frame: CGRectMake(0, 330, self.view.frame.width, 100))
//        v2.backgroundColor = UIColor.grayColor()
//        contentView.addSubview(v2)
//        
//        
//        let more = UIView(frame: CGRectMake(self.view.frame.width-26, 170, 20, 20))
//        more.backgroundColor = UIColor.redColor()
//        contentView.addSubview(more)
        
        
        
        //新手频道推荐数据
        let channelBL = ChannelBL()
        channelBL.findChannel("new").continueWithSuccessBlock({ [weak self] (task: BFTask!) -> BFTask! in
            
            //self?.newChannelObjects = JSON(task.result) as? [Channel]

//println(JSON(task.result))
            
            for (index, value) in JSON(task.result) {
                var item = [String: String]()
                item["id"] = value["id"].string!
                item["name"] = value["name"].string!

                self!.newChannelObjects.addObject(item)
            }

            self!.newChannelView.reloadData()
            return nil
        })

        
        
    }
    
    // 一个分区
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    // 设置表格行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView.isEqual(featuredChannelView) ){
            return 1
        } else {
            return newChannelObjects.count
        }

    }
    // 设置单元格的内容（创建参数indexPath指定的单元）
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if(tableView.isEqual(featuredChannelView) ){
            // 指定identify进行重用提高性能
            let identify: String = "featuredChannelCell"
            var cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: identify)
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            //cell.textLabel?.text = ctrlNames[indexPath.row]

            return cell
        } else {
            // 指定identify进行重用提高性能
            let identify: String = "newChannelCell"
            let cell = tableView.dequeueReusableCellWithIdentifier(identify, forIndexPath: indexPath) as! UITableViewCell
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator

            cell.textLabel?.text = newChannelObjects[indexPath.row]["name"] as? String
            
            var imageCell = UIView(frame: CGRectMake(0, 0, 200, 20))
            imageCell.backgroundColor = UIColor.redColor()
            cell.addSubview(imageCell)
            
            println("第\(indexPath.row)的数据：\(newChannelObjects[indexPath.row])")
            
            return cell

        }
        
    }
    
    
    
    
    
    
    
    func cycleScrollView(cycleScrollView: SDCycleScrollView!, didSelectItemAtIndex index: Int) {
        NSLog("---点击了第%ld张图片", index);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.view.frame = CGRectMake(0, 0, self.view.frame.width, 1000)
        self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 1000)
    }

    
}

//extension HomeController: ChannelBLDelegate {
//    func findChannel(channelType: String) -> BFTask {
//        
//    }
//}










