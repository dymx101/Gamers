//
//  HomeVideoCell.swift
//  Gamers
//
//  Created by 虚空之翼 on 15/8/9.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

import UIKit

class HomeVideoCell: UITableViewCell {

    @IBOutlet weak var videoImage: UIImageView!
    @IBOutlet weak var videoTitle: UILabel!
    @IBOutlet weak var channelName: UILabel!
    @IBOutlet weak var videoViews: UILabel!
    
    @IBAction func clickShare(sender: AnyObject) {
        println("共享")
        
        var actionSheetController: UIAlertController = UIAlertController()
        
        actionSheetController.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel) { (alertAction) -> Void in
            NSLog("Tap 取消 Button")
        })
        actionSheetController.addAction(UIAlertAction(title: "破坏性按钮", style: UIAlertActionStyle.Destructive) { (alertAction) -> Void in
            NSLog("Tap 破坏性按钮 Button")
        })
        
        actionSheetController.addAction(UIAlertAction(title: "新浪微博", style: UIAlertActionStyle.Default) { (alertAction) -> Void in
            NSLog("Tap 新浪微博 Button")
        })
        
        //显示
        //self.presentViewController(actionSheetController, animated: true, completion: nil)
//        self.superview
        
        //presentViewController(actionSheetController, animated: true, completion: nil)
        
    
        
        //sender.vie
        
//        UITableViewCell * cell = (UITableViewCell *)[[sender superview] superview];
//        NSIndexPath * path = [self.tableView indexPathForCell:cell];
//        NSLog(@"index row%d", [path row]);

//        UIView *v = [sender superview];//获取父类view
//        UIView *v1 = [v superview];
//        UITableViewCell *cell = (UITableViewCell *)[v1 superview];//获取cell
//        NSIndexPath *indexPathAll = [self.tableView indexPathForCell:cell];//获取cell对应的section
//        NSLog(@"indexPath:--------%@",indexPathAll);
//        let v = sender.superview
//        let v1 = sender.superview
//        
//        let cell: UITableViewCell = v1.superview as? UITableViewCell
//        
//        let indexPathAll =
        
        
        
        
        println(sender.tag)
        
        
    }
    
    
    @IBAction func abc(sender: AnyObject, forEvent event: UIEvent) {

        
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
