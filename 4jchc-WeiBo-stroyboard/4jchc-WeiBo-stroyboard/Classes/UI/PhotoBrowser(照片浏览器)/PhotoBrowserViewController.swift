//
//  PhotoBrowserViewController.swift
//  4jchc-WeiBo-stroyboard
//
//  Created by 蒋进 on 16/1/4.
//  Copyright © 2016年 sijichcai. All rights reserved.
//


import UIKit


class PhotoBrowserViewController: UIViewController {
    
    /// 图片的 URL 数组
    var urls: [String]?
    /// 选中照片的索引
    var selectedIndex: Int = 0
    
    
    // 从 sb 创建视图控制器
    class func photoBrowserViewController() -> PhotoBrowserViewController {
        let sb = UIStoryboard(name: "PhotoBrowser", bundle: nil)
        let vc = sb.instantiateInitialViewController() as! PhotoBrowserViewController
        
        return vc
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        println("测试数据接收 \(urls) \(selectedIndex)")
    }

}
