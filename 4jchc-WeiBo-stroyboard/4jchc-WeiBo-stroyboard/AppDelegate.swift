//
//  AppDelegate.swift
//  4jchc-WeiBo-stroyboard
//
//  Created by 蒋进 on 15/12/30.
//  Copyright © 2015年 sijichcai. All rights reserved.
//

import UIKit

///********************
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        

        
        // 实例化对象的时候，()就是调用默认的构造函数
//        let net = SimpleNetwork()
//
//        let urls = ["http://ww1.sinaimg.cn/thumbnail/62c13fbagw1epuww0k4xgj20c8552b29.jpg",
//        "http://ww3.sinaimg.cn/thumbnail/e362b134jw1epuxb47zoyj20dw0ku421.jpg",
//        "http://ww1.sinaimg.cn/thumbnail/e362b134jw1epuxbaym1sj20ku0dwgpu.jpg",
//        "http://ww2.sinaimg.cn/thumbnail/e362b134jw1epuxbdhirmj20dw0kuae8.jpg"]
//
//        print(net.downloadImages(urls, { (result, error) -> () in
//            print("OK")
//        }))
        
        
        // 测试发布代图片的微博
        uploadPicture()
        
        
        
        
        
        // 打开数据库
        SQLite.sharedSQLite.openDatabase("readme.db")
        // 检查沙盒中是否已经保存的 token
        // 如果已经存在 token，应该直接显示主界面
        if let token = AccessToken.loadAccessToken() {
            print(token.debugDescription)
            print(token.uid)
            
            showMainInterface()
        } else {
            // 添加通知监听，监听用户登录成功
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "showMainInterface", name: WB_Login_Successed_Notification, object: nil)
        }
        
        return true
    }
    
    ///  测试上拉刷新数据的代码
    func demoLoadData() {
        // 加载数据测试代码 － 第一次刷新，都是从服务器加载数据！
        StatusesData.loadStatus(0, topId: 0) { (data, error) -> () in
            // 第一次加载的数据
            if let statuses = data?.statuses {
                // 模拟上拉刷新
                // 取出最后一条记录中的 id，id -1 -> maxId
                let mId = statuses.last!.id
                let tId = statuses.first!.id
                print("maxId \(mId) ---- topId \(tId)")
                
                // 上拉刷新
                StatusesData.loadStatus((mId - 1), topId: tId, completion: { (data, error) -> () in
                    print("第一次上拉刷新结束")
                    
                    // 再一次加载的数据
                    if let statuses = data?.statuses {
                        // 模拟上拉刷新
                        // 取出最后一条记录中的 id，id -1 -> maxId
                        let mId = statuses.last!.id
                        let tId = statuses.first!.id
                        print("2222 maxId \(mId) ---- topId \(tId)")
                        
                        // 上拉刷新
                        StatusesData.loadStatus((mId - 1), topId: tId, completion: { (data, error) -> () in
                            print("第二次上拉刷新结束")
                        })
                    }
                })
            }
        }
        
    }
    
    func uploadPicture() {
        let urlString = "https://upload.api.weibo.com/2/statuses/upload.json"
        let token = AccessToken.loadAccessToken()
        
        let params = ["access_token": token!.access_token!, "status": "测试一下"]
        let image = UIImage(named: "compose_photo_preview_right")
        let data = UIImagePNGRepresentation(image!)
        
        NetworkManager.sharedNetworkManager.postUpload(urlString, params: params, fieldName: "pic", dataList: [data!], filenames: ["oooo"]) { (result, error) -> () in
            
            print(NSThread.currentThread())
        }
    }
    
    
    
    
    
    ///  显示主界面
    func showMainInterface() {
        // 通知在不需要的时候，要及时销毁
        NSNotificationCenter.defaultCenter().removeObserver(self, name: WB_Login_Successed_Notification, object: nil)
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        window!.rootViewController = sb.instantiateInitialViewController()
        
        // 设置 nav 按钮的外观
        setNavAppearance()
    }
    
    
    
    
    
    ///  设置按钮的 tintColor
    func setNavAppearance() {
        // 提示：关于外观的设置，应该在 appDelegate 中，程序一启动就设置
        // 一经设置，全局有效
        // 有一个比较常见的外观设置：UISwitch
        UINavigationBar.appearance().tintColor = UIColor.orangeColor()
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


}

