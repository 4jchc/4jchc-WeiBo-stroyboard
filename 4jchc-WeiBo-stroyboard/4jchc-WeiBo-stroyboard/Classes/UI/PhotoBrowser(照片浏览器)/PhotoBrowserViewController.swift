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
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PhotoCell", forIndexPath: indexPath) as! PhotoCell
        
        cell.backgroundColor = UIColor(red: random(), green: random(), blue: random(), alpha: 1.0)
        // 设置 cell 的 urlString
        cell.urlString = urls![indexPath.item]
        return cell
    }
    
    func random() -> CGFloat {
        return CGFloat(arc4random_uniform(256)) / 255
    }

   
}

//MARK: - 照片浏览的 cell
///  照片浏览的 cell
class PhotoCell: UICollectionViewCell,UIScrollViewDelegate {
    
    /// 单张图片缩放的滚动视图
    var scrollView: UIScrollView?
    /// 显示图像的图像视图
    var imageView: UIImageView?
    /// 图像的 URL - 函数会先于 layoutSubviews 函数执行
    /**
    - scrollview 的大小没有被设置
    - cell 的大小已经被设置，由视图控制器 viewWillLayoutSubviews 函数中设置的 layout 的 itemsize 导致的！
    */
//    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
//        return imageView!
//    }
    
    
    /// 图像的 URL
    var urlString: String? {
        // 下载图像，显示图像
        didSet {
            let net = NetworkManager.sharedNetworkManager
            // 大图还没有缓存，需要临时下载

            net.requestImage(urlString!) { (result, error) -> () in
                
                print(result)
                if result != nil {
                    
                    if let image = result as? UIImage {
                        // 设置图像
                        self.setupImageView(image)
                    
//                    self.imageView!.image = result as? UIImage
//                    
//                    self.imageView!.sizeToFit()
//                    let image = result as! UIImage
//                    self.calcImageSize(image.size)
                }
            }
        }
    }
    
}
    ///  根据图像设置图像视图
    /**
    网络图片的类型
    - 长图
    - 短图
    
    1. 如何区分长图还是短图！
    - 都以宽度为基准缩放
    - 如果高度没有屏幕高，就是短图，垂直居中
    - 如果高度超出屏幕，就是长图，顶端对齐，方便滚动
    
    */
    /// 是否是短图的标记
    var isShortImage = false
    
    func setupImageView(image: UIImage) {
        // 0. 将 scrollView 的滚动参数重置
        scrollView?.contentOffset = CGPointZero
        scrollView?.contentSize = CGSizeZero
        scrollView?.contentInset = UIEdgeInsetsZero
        // 1. 准备参数
        let imageSize = image.size
        let screenSize = self.bounds.size
        
        // 2. 按照宽度进行缩放，目标宽度 screenSize.width
        // 只需要计算目标高度
        let h = screenSize.width / imageSize.width * imageSize.height
        
        // 直接设置看结果
        let rect = CGRectMake(0, 0, screenSize.width, h)
        imageView!.frame = rect
        imageView!.image = image
        scrollView!.frame = self.bounds
        
        // 区分长图和短图
        if rect.size.height > screenSize.height {
            print("长图")
            // 设置滚动区域
            scrollView!.contentSize = rect.size
             isShortImage = false
        } else {
            print("短图")
            // 需要垂直居中，设置 inset
            let y = (screenSize.height - h) * 0.5
            scrollView?.contentInset = UIEdgeInsetsMake(y, 0, 0, 0)
            isShortImage = true
        }
    }
    
    // MARK: - UIScrollView 代理方法
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    // 重新让图片居中 - 只有短图需要居中
    func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView?, atScale scale: CGFloat) {
        print("------ \(scrollView) \(view)")
        if isShortImage {
            // 如果是缩放视图，缩放完成后，bound和frame的大小是不一致的
            let y = (frame.size.height - imageView!.frame.size.height) * 0.5
            scrollView.contentInset = UIEdgeInsetsMake(y, 0, 0, 0)

        }
    }
    
    
    
    
    
    ///  计算图像大小
//    func calcImageSize(size: CGSize) {
        // 0. 计算图像的宽高比
        
        // 1. 计算图像和屏幕的宽高比
//        var wScale = size.width / self.bounds.size.width
//        var hScale = size.height / self.bounds.size.height
        
        // 2. 宽度和高度
//                var w = self.bounds.size.width
//                var h = self.bounds.size.height
//        let w = size.width
//        let h = size.height
//        
//        imageView!.frame = bounds
//        if (h / w) > 2 {
//            imageView!.contentMode = UIViewContentMode.ScaleAspectFill
//            scrollView!.contentSize = size
//        } else {
//            imageView!.contentMode = .ScaleAspectFit
//        }
        
        //        if wScale > hScale {
        //            // 计算目标高度
        //            h / self.bounds.size.height = size.width / self.bounds.size.width
        //        } else {
        //            // 计算目标宽度
        //        }
        
//    }

    
    
    // ** cell 的大小是 50 * 50，完全没有设置
    override func awakeFromNib() {
        print("\(__FUNCTION__) \(self.bounds)")
        // 创建界面元素
        scrollView = UIScrollView()
        self.addSubview(scrollView!)
        scrollView!.delegate = self
        scrollView!.maximumZoomScale = 2.0
        scrollView!.minimumZoomScale = 1
        
        // 图像视图，大小取决于传递的图像
        imageView = UIImageView()
        scrollView!.addSubview(imageView!)
    }
    
     // 只有 cell 的布局发生变化的时候，才会被执行
    override func layoutSubviews() {
        super.layoutSubviews()
        
        print("\(__FUNCTION__) \(self.bounds)")
        // 设置滚动视图的大小
        scrollView!.frame = self.bounds
    }

}





