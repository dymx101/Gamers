//
//  ViewController.swift
//  Gamers
//
//  Created by 虚空之翼 on 15/7/9.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

import UIKit
import YouTubePlayer
import Alamofire
import SwiftyJSON
import Starscream

class ViewController: UIViewController, WebSocketDelegate {

    @IBOutlet weak var playerView: YouTubePlayerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let plistPath = NSBundle.mainBundle().pathForResource("team", ofType: "plist")

        // 1、测试视频播放
        playerView.playerVars = ["playsinline": "1"]
        playerView.loadVideoID("yRRABRn0JTc")
        
        // 2、测试API接口
        Alamofire.request(.GET, "http://beta.gamers.tm:3000/api/videos", parameters: ["order": "popular"])
            .responseJSON { (request, response, data, error) in
                //println(json)
                //println(data)
                
                // 3、测试解析JSON
                let json = JSON(data!)
                if let userName = json[0]["owner"].string{
                    //println(userName)
                }
        }
        
        // 4、测试SQLite数据存储
//        let sql="INSERT INTO SYSTEM (ID,KEYWORDS,IOS,ANDROID,REMARK) "+"VALUES (?,?,?,?,?)"
//        let db = Db.getDb()
//        db.open()
//        db.executeUpdate(sql, withArgumentsInArray: [1,"version",1,1,"开发第一版"])
//        db.close()
        
        let sql = "SELECT * FROM SYSTEM"
        let db = DB.getDb()
        db.open()
        let rs = db.executeQuery(sql, withArgumentsInArray: [1])

        while rs.next() {
            println(rs.stringForColumn("IOS"))
        }
        db.close()
        

//
        // 5、测试WebSocket
        //socket.delegate = self
        //socket.connect()
        
        
        var socket2 = WebSocket(url: NSURL(string: "ws://localhost:8080/")!, protocols: ["chat", "superchat"])
        
        
        let dao = SliderDao()
        dao.fetchSlider(refresh: true)
        
        
        
        
        
        
    }
    
    var socket = WebSocket(url: NSURL(scheme: "ws", host: "localhost:8080", path: "/")!, protocols: ["chat", "superchat"])

    @IBOutlet weak var message: UIButton!
    @IBOutlet weak var connect: UIButton!

    @IBAction func onclickConnect(sender: AnyObject) {
        if socket.isConnected {
            socket.disconnect()
            self.connect.backgroundColor = UIColor.redColor()
            self.connect.setTitle("Connect", forState: UIControlState.allZeros)
        } else {
            socket.connect()
            self.connect.setTitle("Disconnect", forState: UIControlState.allZeros)
            self.connect.backgroundColor = UIColor.greenColor()
        }
    }
    
    @IBAction func sendMessage(sender: AnyObject) {
        socket.writeString("hello there!")
    }
    // Websocket 组件的4个委托Delegate方法
    func websocketDidConnect(ws: WebSocket) {
        println("websocket is connected")
    }
    func websocketDidDisconnect(ws: WebSocket, error: NSError?) {
        if let e = error {
            println("websocket is disconnected: \(e.localizedDescription)")
        }
    }
    func websocketDidReceiveMessage(ws: WebSocket, text: String) {
        println("Received text: \(text)")
    }
    func websocketDidReceiveData(ws: WebSocket, data: NSData) {
        println("Received data: \(data.length)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

