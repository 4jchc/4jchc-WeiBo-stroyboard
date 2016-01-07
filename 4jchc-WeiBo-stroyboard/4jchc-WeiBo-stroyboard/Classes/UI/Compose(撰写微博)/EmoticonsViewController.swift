//
//  EmoticonsViewController.swift
//  4jchc-WeiBo-stroyboard
//
//  Created by 蒋进 on 16/1/7.
//  Copyright © 2016年 sijichcai. All rights reserved.
//

import UIKit

class EmoticonsViewController: UIViewController {

    @IBOutlet weak var layout: UICollectionViewFlowLayout!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        print(self.collectionView)
        // 设置界面布局
        setupLayout()
    }
    
    /// 设置界面布局
    func setupLayout() {
        // 目标 3 ＊ 7 个按钮
        let row: CGFloat = 3
        let col: CGFloat = 7
        // item 之间的间距
        let m: CGFloat = 8// =10就显示2行
        
        // 计算 item 的大小
        let screenSize = self.collectionView.bounds.size
        let w = (screenSize.width - (col + 1) * m) / col
        
        layout.itemSize = CGSizeMake(w, w)
        layout.minimumInteritemSpacing = m
        layout.minimumLineSpacing = m
        
        // 每一个分组之间的边距
        layout.sectionInset = UIEdgeInsetsMake(m, m, m, m)
        
        // 滚动方向
        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        // 分页
        collectionView.pagingEnabled = true
    }
}

/**
 接下来准备数据的时候，需要考虑每一个分组都刚好有21个cell
 */
extension EmoticonsViewController: UICollectionViewDataSource {
    
    /// 返回分组数量
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 21
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("EmoticonsCell", forIndexPath: indexPath) 
//        if indexPath.item > 2 && indexPath.item < 42{
//            
//            cell.backgroundColor = UIColor.orangeColor()
//        }
        if indexPath.section == 1 {
            cell.backgroundColor = UIColor.orangeColor()
        }
        else {
            cell.backgroundColor = UIColor.redColor()
        }
        
        return cell
    }

}
