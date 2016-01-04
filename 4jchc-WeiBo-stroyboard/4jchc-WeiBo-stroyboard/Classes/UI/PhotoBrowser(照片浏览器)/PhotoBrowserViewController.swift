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
    
    /**
     1. loadView -> 创建视图层次结构，纯代码开发替代 storyboard & xib
     2. viewDidLoad -> 视图加载完成，只是把视图元件加载完成，还没有开始布局
     不要设置关于 frame 之类的属性！
     3. viewWillAppear -> 视图将要出现
     4. viewWillLayoutSubviews —> 视图将要布局子视图，苹果建议设置界面布局属性
     5. view 的 layoutSubviews 方法，视图和所有子视图布局
     6. viewDidLayoutSubviews -> 视图&所有子视图布局完成
     7. viewDidAppear -> 视图已经出现
     */
    override func viewWillLayoutSubviews() {

    // 视图将要布局前，此时视图的 frame 已经是全屏的了

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

//MARK: - 照片浏览的 cell
///  照片浏览的 cell
class PhotoCell: UICollectionViewCell {
    
    /// 单张图片缩放的滚动视图
    var scrollView: UIScrollView?
    /// 显示图像的图像视图
    var imageView: UIImageView?
    
    /// 图像的 URL
    var urlString: String? {
        // 下载图像，显示图像
        didSet {
            let net = NetworkManager.sharedNetworkManager
            // 大图还没有缓存，需要临时下载

            net.requestImage(urlString!) { (result, error) -> () in
                
                print(result)
                if result != nil {
                    // 设置图像
                    self.imageView!.image = result as? UIImage
                    
                    self.imageView!.sizeToFit()
                }
            }
        }
    }
    
    // ** cell 的大小是 50 * 50，完全没有设置
    override func awakeFromNib() {
        print("\(__FUNCTION__) \(self.bounds)")
        // 创建界面元素
        scrollView = UIScrollView()
        self.addSubview(scrollView!)
        
        // 图像视图，大小取决于传递的图像
        imageView = UIImageView()
        scrollView!.addSubview(imageView!)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        print("\(__FUNCTION__) \(self.bounds)")
        // 设置滚动视图的大小
        scrollView!.frame = self.bounds
    }
    
}







