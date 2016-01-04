//
//  HomeViewController.swift
//  HMWeibo04
//
//  Created by apple on 15/3/5.
//  Copyright (c) 2015年 heima. All rights reserved.
//

import UIKit

class HomeViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
    }
    
    
    /// 微博数据
    var statusData: StatusesData?
    


    ///  加载微博数据
    func loadData() {
        
        SVProgressHUD.show()

        StatusesData.loadStatus { (data, error) -> () in
            if error != nil {
                print(error)
                SVProgressHUD.showInfoWithStatus("你的网络不给力")
                return
            }
            SVProgressHUD.dismiss()
            if data != nil {
                // 刷新表格数据
                self.statusData = data
                self.tableView.reloadData()

            }
        }
    }

    // MARK: 表格数据源 & 代理扩展
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
 
        
        return self.statusData?.statuses?.count ?? 0

    }
    
    ///  根据indexPath 返回微博数据&可重用标识符
    func cellInfo(indexPath: NSIndexPath) -> (status: Status, cellId: String) {
        let status = self.statusData!.statuses![indexPath.row]
        let cellId = StatusCell.cellIdentifier(status)
        
        return (status, cellId)
    }
    
    
    
    ///  准备表格的cell
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // 提取cell信息
        let info = cellInfo(indexPath)
        
        let cell = tableView.dequeueReusableCellWithIdentifier(info.cellId, forIndexPath: indexPath) as! StatusCell
        
        // 判断表格的闭包是否被设置
        if cell.photoDidSelected == nil {
            
    
            // 设置闭包
            cell.photoDidSelected = { (status: Status, photoIndex: Int)->() in
                
                // 使用类方法调用，不需要知道视图控制器太多的内部细节
                let vc = PhotoBrowserViewController.photoBrowserViewController()
                vc.urls = info.status.largeUrls
                vc.selectedIndex = photoIndex
                self.presentViewController(vc, animated: true, completion: nil)

            }
        }
        
        cell.status = info.status
        
        return cell
    }
    
    
    

    
    

//    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        
//        
//        // 根据微博数据判断可重用标识符
//        let status = self.statusData!.statuses![indexPath.row]
//        let cellId = StatusCell.cellIdentifier(status)
//        
//        let cell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath) as! StatusCell
//
//
//        cell.status = status
//        
//        return cell
//    }

    // 行高的处理
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        // 提示：查询可重用cell不要使用 indexPath
        // 提取cell信息
        let info = cellInfo(indexPath)
        
        let cell = tableView.dequeueReusableCellWithIdentifier(info.cellId) as! StatusCell
        
        return cell.cellHeight(info.status)
        
    }
    
    // 预估行高，可以提高性能
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 300
    }


}




