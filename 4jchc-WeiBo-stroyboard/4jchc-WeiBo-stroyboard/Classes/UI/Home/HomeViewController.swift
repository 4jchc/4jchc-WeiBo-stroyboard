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
                 print("内*****\(data)")
                print("内容为内*****\(self.statusData)")
            }
        }
    }

    // MARK: 表格数据源 & 代理扩展
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("内容为内容为*****\(self.statusData)")
        
        return self.statusData?.statuses?.count ?? 0

    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("HomeCell", forIndexPath: indexPath) as! StatusCell
        
        let status = self.statusData!.statuses![indexPath.row] as Status

        cell.status = status
        
        return cell
    }

    // 行高的处理
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        // 提示：查询可重用cell不要使用 indexPath
        let cell = tableView.dequeueReusableCellWithIdentifier("HomeCell") as! StatusCell
        let status = self.statusData!.statuses![indexPath.row]
        
        return cell.cellHeight(status)
    }
    
    // 预估行高，可以提高性能
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 300
    }


}




