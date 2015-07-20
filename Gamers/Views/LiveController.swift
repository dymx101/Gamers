//
//  LiveController.swift
//  Gamers
//
//  Created by 虚空之翼 on 15/7/20.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

import UIKit

class LiveController: UITableViewController, UITableViewDataSource, UITableViewDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // 设置分区
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    // 设置表格行数
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 13
    }
    // 设置行高
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row < 5 {
            return 140
        } else {
            return 64
        }
    }
    
    // 设置表格内容
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // 指定identify进行重用提高性能
        let identify: String = "liveCell"
        //let cell = tableView.dequeueReusableCellWithIdentifier(identify, forIndexPath: indexPath) as! LiveCell
        var cell = tableView.cellForRowAtIndexPath(indexPath)
        // 分隔线右边距
        tableView.separatorInset.right = 20
        //解决重影问题
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: identify)
            if indexPath.row < 5 {
                let image = UIImage(named: "1.jpg")
                let imageView = UIImageView(frame: CGRect(x: 10, y: 10, width: view.bounds.size.width-20, height: 120))
                imageView.image = image
                
                // 添加名称
                let name = UILabel(frame: CGRectMake(10, 100, view.bounds.size.width-20, 10))
                name.text = "老皮"
                name.textColor = UIColor.whiteColor()
                //cell.addSubview(name)
                
                // 添加在线人数
                let online = UILabel(frame: CGRectMake(10, 110, view.bounds.size.width-20, 10))
                online.text = "99人"
                online.textColor = UIColor.whiteColor()
                
                cell!.addSubview(imageView)

            } else {
                cell!.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                
                let imageView2 = UIView(frame: CGRectMake(10, 6, 100, 50))
                imageView2.backgroundColor = UIColor.grayColor()
                
                let name1 = UILabel(frame: CGRectMake(120, 6, view.bounds.size.width-130, 30))
                name1.text = "老皮"
                
                let name2 = UILabel(frame: CGRectMake(120, 30, view.bounds.size.width-130, 30))
                name2.text = "99人"
                
                cell!.addSubview(name1)
                cell!.addSubview(name2)

                cell!.addSubview(imageView2)
            }
        }

        
        NSLog("执行了第%ld个游戏", indexPath.row)
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
         NSLog("点击了第%ld个游戏", indexPath.row)
    }
    
    
    
    
}