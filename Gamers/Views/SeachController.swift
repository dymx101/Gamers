//
//  SeachController.swift
//  Gamers
//
//  Created by 虚空之翼 on 15/7/20.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

import UIKit

class SeachController: UITableViewController, UITableViewDataSource, UITableViewDelegate  {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
//        UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 35)];//allocate titleView
//        UIColor *color =  self.navigationController.navigationBar.barTintColor;
//        
//        [titleView setBackgroundColor:color];
//        
//        UISearchBar *searchBar = [[UISearchBar alloc] init];
//        
//        searchBar.delegate = self;
//        searchBar.frame = CGRectMake(0, 0, 200, 35);
//        searchBar.backgroundColor = color;
//        searchBar.layer.cornerRadius = 18;
//        searchBar.layer.masksToBounds = YES;
//        [searchBar.layer setBorderWidth:8];
//        [searchBar.layer setBorderColor:[UIColor whiteColor].CGColor];  //设置边框为白色
//        
//        searchBar.placeholder = @"|搜索你想要的东西";
//        [titleView addSubview:searchBar];
//        
//        //Set to titleView
//        [self.navigationItem.titleView sizeToFit];
//        self.navigationItem.titleView = titleView;
        
        
        let titleView = UIView(frame: CGRectMake(0, 0, 200, 35))
        titleView.backgroundColor = self.navigationController?.navigationBar.barTintColor
        
        let searchBar = UISearchBar(frame: CGRectMake(0, 0, 200, 35))
        //searchBar.delegate = self
        searchBar.backgroundColor = self.navigationController?.navigationBar.barTintColor
        searchBar.layer.cornerRadius = 5
        searchBar.layer.masksToBounds = true
        searchBar.layer.borderWidth = 1
        searchBar.layer.borderColor = UIColor.redColor().CGColor
        searchBar.placeholder = "seach"
        titleView.addSubview(searchBar)
        
        self.navigationItem.titleView?.sizeToFit()
        self.navigationItem.titleView = titleView
        
        
        
        
        
        
        println("abc")
        
        
        
        
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //
        var cell = tableView.dequeueReusableCellWithIdentifier("SeachCell", forIndexPath: indexPath) as! SeachCell

        cell.videoTitle.text = "abc"
        
        return cell

    }
    
    
}

