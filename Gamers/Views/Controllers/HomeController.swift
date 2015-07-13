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

class HomeController: UIViewController, SDCycleScrollViewDelegate {
    @IBOutlet weak var scrollView: UIScrollView!    //滚动视图
    @IBOutlet weak var contentView: UIView!         //滚动试图内容
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.header = MJRefreshNormalHeader(refreshingBlock: { () -> Void in
            NSLog("1111111")
        })
        
        scrollView.header.autoChangeAlpha = true;
        scrollView.header.beginRefreshing()
        
        NSOperationQueue().addOperationWithBlock {
            sleep(2)
            NSOperationQueue.mainQueue().addOperationWithBlock {
                self.scrollView.header.endRefreshing()
            }
        }

        
        // 轮播
        let cycleScrollView = SDCycleScrollView(frame: CGRectMake(0, 0, self.view.frame.width, 160), imagesGroup: nil)

        
        var titles = ["The International 2015", "The International 2014", "轮播广告"];
        var imagesURLStrings = [
        "http://cdn2.gamers.tm/slider/041486869386dcc6015e74e34808b212.png",
        "http://cdn2.gamers.tm/slider/bab7b566f5727106103b303fa41306ab.jpg",
        "http://c.hiphotos.baidu.com/image/w%3D400/sign=c2318ff84334970a4773112fa5c8d1c0/b7fd5266d0160924c1fae5ccd60735fae7cd340d.jpg"
        ];
        
        cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight
        cycleScrollView.infiniteLoop = true;
        cycleScrollView.delegate = self
        cycleScrollView.titlesGroup = titles
        cycleScrollView.dotColor = UIColor.yellowColor() // 自定义分页控件小圆标颜色
        //cycleScrollView.placeholderImage = [UIImage imageNamed:@"placeholder"]
        //cycleScrollView.imageURLStringsGroup = imagesURLStrings;
        cycleScrollView.autoScrollTimeInterval = 4.0
        
        var minseconds = 1 * Double(NSEC_PER_MSEC)
        var dtime = dispatch_time(DISPATCH_TIME_NOW, Int64(minseconds))
        dispatch_after(dtime, dispatch_get_main_queue()) {
             cycleScrollView.imageURLStringsGroup = imagesURLStrings;
        }
        
        contentView.addSubview(cycleScrollView)
        
        // 添加新手推荐部分
        let l1 = UIView(frame: CGRectMake(6, 170, 6, 20))
        l1.backgroundColor = UIColor.redColor()
        contentView.addSubview(l1)
        
        let t1 = UILabel(frame: CGRectMake(14, 170, 300, 20))
        t1.text = "新秀推荐"
        contentView.addSubview(t1)
        
        let v1 = UIView(frame: CGRectMake(0, 195, self.view.frame.width, 100))
        v1.backgroundColor = UIColor.grayColor()
        contentView.addSubview(v1)
        
        
        let l2 = UIView(frame: CGRectMake(6, 305, 6, 20))
        l2.backgroundColor = UIColor.redColor()
        contentView.addSubview(l2)
        
        let t2 = UILabel(frame: CGRectMake(14, 305, 300, 20))
        t2.text = "实况大咖"
        contentView.addSubview(t2)
        
        let v2 = UIView(frame: CGRectMake(0, 330, self.view.frame.width, 100))
        v2.backgroundColor = UIColor.grayColor()
        contentView.addSubview(v2)
        
        
        let more = UIView(frame: CGRectMake(self.view.frame.width-26, 170, 20, 20))
        more.backgroundColor = UIColor.redColor()
        contentView.addSubview(more)
        
        
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
