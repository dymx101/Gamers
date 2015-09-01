//
//  AppDelegate.swift
//  Gamers
//
//  Created by 虚空之翼 on 15/7/9.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

import UIKit
import ReachabilitySwift
import Bolts

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var allowRotation: Bool = false

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // 初始化Google登入
//        var configureErr: NSError?
//        GGLContext.sharedInstance().configureWithError(&configureErr)
//        if configureErr != nil {
//            println("Error configuring the Google context: \(configureErr)")
//        }
        
        
        // 全程网络检测
        let reachability = Reachability.reachabilityForInternetConnection()
        // 判断联网情况（可以写在view中）
        reachability.whenReachable = { reachability in
            if reachability.isReachableViaWiFi() {
                println("Reachable via WiFi")
            } else {
                println("Reachable via Cellular")
            }
            
        }
        reachability.whenUnreachable = { reachability in
            println("Not reachable")
            var alertView: UIAlertView = UIAlertView(title: "", message: "网络出现问题！", delegate: nil, cancelButtonTitle: "确定")
            alertView.show()
        }
        // 全局通知事件
        reachability.startNotifier()
        
        // 启动时候判断
        var internetStatus = reachability.currentReachabilityStatus
        if internetStatus == Reachability.NetworkStatus.NotReachable {
            var alertView: UIAlertView = UIAlertView(title: "", message: "网络出现问题！", delegate: nil, cancelButtonTitle: "确定")
            alertView.show()
        }
        
        // 设置web缓存
        let cacheSizeMemory = 4*1024*1024; // 4MB
        let cacheSizeDisk = 32*1024*1024; // 32MB
        var sharedCache: NSURLCache = NSURLCache(memoryCapacity: cacheSizeMemory, diskCapacity: cacheSizeDisk, diskPath: "nsurlcache")
        NSURLCache.setSharedURLCache(sharedCache)
        
        // 检测更新
//        SystemBL.sharedSingleton.getVersion().continueWithSuccessBlock({ [weak self] (task: BFTask!) -> BFTask! in
//            if var version = (task.result as? Version) {
//                let plistPath = NSBundle.mainBundle().pathForResource("system", ofType: "plist")
//                //获取属性列表文件中的全部数据
//                let systemData = NSDictionary(contentsOfFile: plistPath!)!
//                let localVersion = systemData["version"] as! String
//                
//                if version.version.toInt() > localVersion.toInt() {
//                    var alertView: UIAlertView = UIAlertView(title: "", message: "检测到新版本，是否更新！", delegate: nil, cancelButtonTitle: "否", otherButtonTitles: "是")
//                    alertView.show()
//                }
//            }
//  
//            return nil
//        })

        
        return true
    }
    func applicationDidReceiveMemoryWarning(application: UIApplication) {
        NSURLCache.sharedURLCache().removeAllCachedResponses()
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
// google登入
//    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
//        return GIDSignIn.sharedInstance().handleURL(url, sourceApplication: sourceApplication, annotation: annotation)
//    }
    // 播放器横屏，暂时解决办法
    func application(application: UIApplication, supportedInterfaceOrientationsForWindow window: UIWindow?) -> Int {
        if allowRotation {
            return Int(UIInterfaceOrientationMask.All.rawValue)
        }
        return Int(UIInterfaceOrientationMask.Portrait.rawValue)
    }
    
    

}

