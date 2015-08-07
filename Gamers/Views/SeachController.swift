//
//  SeachController.swift
//  Gamers
//
//  Created by 虚空之翼 on 15/7/20.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

import UIKit

class SeachController: UITableViewController, UITableViewDataSource, UITableViewDelegate  {
    
    var searchContentView: UIView!
    var searchBackgroundView: UIView!
    var autocompleteView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 导航栏添加搜索框
        let searchBarView = UIView(frame: CGRectMake(45, 0, self.view.frame.size.width, 44))
        searchBarView.backgroundColor = UIColor.whiteColor()
        
        let searchBar = UISearchBar(frame: CGRectMake(0, 0, self.view.frame.size.width-100, 44))
        searchBar.searchBarStyle = UISearchBarStyle.Minimal
        searchBar.tintColor = self.navigationController?.navigationBar.barTintColor
        searchBar.showsBookmarkButton = false
        //searchBar.showsCancelButton = true
        searchBar.delegate = self
        //searchBar.becomeFirstResponder()

        searchBarView.addSubview(searchBar)

        //self.navigationController?.view.addSubview(searchBarView)
        self.navigationItem.titleView = searchBarView
        self.navigationItem.titleView?.sizeToFit()

        // autocomplete 界面
        searchContentView = UIView(frame: CGRectMake(0, 64, self.view.frame.size.width, 160))
        searchContentView.backgroundColor = UIColor.whiteColor()
        searchContentView.layer.borderWidth = 1
        searchContentView.layer.borderColor = UIColor.grayColor().CGColor

        
        autocompleteView = UITableView(frame: CGRectMake(0, 0, self.view.frame.size.width, 160))
        autocompleteView.delegate = self
        autocompleteView.dataSource = self
        autocompleteView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "autocompleteCell")
        searchContentView.addSubview(autocompleteView)
        
        
        // 灰色背景
        searchBackgroundView = UIView(frame: CGRectMake(0, 224, self.view.frame.size.width, self.view.frame.size.height-224))
        searchBackgroundView.backgroundColor = UIColor.grayColor()
        searchBackgroundView.alpha = 0.7
        
        self.navigationController?.view.addSubview(searchContentView)
        self.navigationController?.view.addSubview(searchBackgroundView)
        // 默认隐藏搜索界面
        searchContentView.hidden = true
        searchBackgroundView.hidden = true
        
        // 设置tableview顶部不在导航栏下
        self.edgesForExtendedLayout = UIRectEdge.None
        // 隐藏底部工具栏
        //self.tabBarController!.tabBar.hidden = true
        
        
        
        
        
        

    }


    // 卸载界面
    override func viewWillDisappear(animated: Bool) {
        // 返回等切换页面，删除搜索界面
        searchContentView.removeFromSuperview()
        searchBackgroundView.removeFromSuperview()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }

    // MARK: 表格代理协议
    // 分区
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch tableView {
        case autocompleteView:
            return 32
        default:
            return 100
        }
    }
    // 行数
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    // 单元格内容
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //
        
        switch tableView {
        case autocompleteView:
            let cell = tableView.dequeueReusableCellWithIdentifier("autocompleteCell", forIndexPath: indexPath) as! UITableViewCell
            
            return cell
        default:
            var cell = tableView.dequeueReusableCellWithIdentifier("SeachCell", forIndexPath: indexPath) as! UITableViewCell
            
            //cell.videoTitle.text = "abc"
            
            return cell
            
        }


    }
    
}

// MARK: 搜索代理
extension SeachController: UISearchBarDelegate {
    // 第一响应者时触发
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        //
        println("准备开始搜索")
        
        
        // 显示搜索界面
        searchContentView.hidden  = false
        searchBackgroundView.hidden = false
        
        
        return true
    }
    // 点击搜索
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        //
        println("点击搜索")
        
        // 隐藏搜索界面
        searchContentView.hidden  = true
        searchBackgroundView.hidden = true
    }
    // 点击取消时触发事件
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        //
        println("canncel")
    }
    // 搜索内容发生变化时触发事件
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        //
        println("内容发生变化")
        // 显示搜索界面
        searchContentView.hidden  = false
        searchBackgroundView.hidden = false
    }
    // 搜索范围标签变化时
    func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        //
        println("选择范围变化")
    }
    
    
    
}

