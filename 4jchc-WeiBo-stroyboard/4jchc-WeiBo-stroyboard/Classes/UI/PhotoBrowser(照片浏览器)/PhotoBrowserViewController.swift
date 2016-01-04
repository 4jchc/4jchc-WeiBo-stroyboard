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
    
    @IBOutlet weak var photoView: UICollectionView!
    @IBOutlet weak var layout: UICollectionViewFlowLayout!
    
    
    
    // 从 sb 创建视图控制器
    class func photoBrowserViewController() -> PhotoBrowserViewController {
        let sb = UIStoryboard(name: "PhotoBrowser", bundle: nil)
        let vc = sb.instantiateInitialViewController() as! PhotoBrowserViewController
        
        return vc
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("测试数据接收 \(urls) \(selectedIndex)")
    }
    
    // 视图将要布局前，此时视图的 frame 已经是全屏的了
    override func viewWillAppear(animated: Bool) {
        print("\(__FUNCTION__) \(view.frame)")
        // 设置 collectionView 的布局
        layout.itemSize = view.bounds.size
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        // 滚动方向
        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        photoView.pagingEnabled = true
    }
    
    // 关闭
    @IBAction func close() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}




///  UICollectionView 的数据源方法
extension PhotoBrowserViewController: UICollectionViewDataSource {
    
    // 数据行数
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return urls?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PhotoCell", forIndexPath: indexPath) 
        
        cell.backgroundColor = UIColor(red: random(), green: random(), blue: random(), alpha: 1.0)
        
        return cell
    }
    
    func random() -> CGFloat {
        return CGFloat(arc4random_uniform(256)) / 255
    }

    
    
    
}
