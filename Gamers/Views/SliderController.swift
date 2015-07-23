//
//  SliderController.swift
//  Gamers
//
//  Created by 虚空之翼 on 15/7/23.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

import UIKit

class SliderController: UIViewController {

    @IBOutlet weak var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSLog("222222")
        
//        self.navigationController!.toolbarHidden = true
//        self.navigationController!.navigationBarHidden = true
        self.navigationController
        
        self.button.backgroundColor = UIColor.grayColor()
        
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
