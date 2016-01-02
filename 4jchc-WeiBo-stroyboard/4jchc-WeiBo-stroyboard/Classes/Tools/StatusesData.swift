//
//  StatusesData.swift
//  HMWeibo04
//
//  Created by apple on 15/3/5.
//  Copyright (c) 2015年 heima. All rights reserved.
//

import UIKit
import SwiftDictModel

/**
    关于业务模型

    - 专门处理"被动"的业务，模型类永远不知道谁会在什么时候调用它！
    - 准备好跟数据模型相关的数据
*/
/// 加载微博数据 URL
private let WB_Home_Timeline_URL = "https://api.weibo.com/2/statuses/home_timeline.json"

///  微博数据列表模型DictModelProtocol
@objc(StatusesData) class StatusesData: NSObject, DictModelProtocol {
    ///  微博记录数组
    var statuses: [Status]?
    ///  微博总数
    var total_number: Int = 0
    ///  未读数辆
    var has_unread: Int = 0
    
    static func customClassMapping() -> [String: String]? {
        return ["statuses": "\(Status.self)"]
    }
    
    
    // 定义了一个类的完成闭包类型
    typealias Completion = (result: AnyObject?, error: NSError?) -> ()
    ///  刷新微博数据 - 专门加载网络数据以及错误处理的回调
    ///  一旦加载成功，负责字典转模型，回调传回转换过的模型数据
    class func loadStatus(completion: (data: StatusesData?, error: NSError?)->()) {
        
        let net = NetworkManager.sharedNetworkManager
        print("AccessToken.loadAccessToken()?.access_token---\(AccessToken.loadAccessToken()?.access_token)")
        
        if let token = AccessToken.loadAccessToken()?.access_token {
            let params = ["access_token": token]
            print("***tokentoken**\(token)")
            // 发送网络异步请求
            net.requestJSON(.GET, WB_Home_Timeline_URL, params) { (result, error) -> () in
                
                if error != nil {
                    // 错误处理
                    completion(data: nil, error: error!)
                    return
                }
                
                // 字典转模型
                let modelTools = DictModelManager.sharedManager
                let data = modelTools.objectWithDictionary(result as! NSDictionary, cls: StatusesData.self) as? StatusesData
                print("*****\(data)")
                //MARK: -  回调 -> 将模型通知给视图控制器
                completion(data: data, error: nil)
            }
        }
    }
}



///  微博模型
@objc(Status) class Status: NSObject, DictModelProtocol {
    ///  微博创建时间
    var created_at: String?
    ///  微博ID
    var id: Int = 0
    ///  微博信息内容
    var text: String?
    ///  微博来源
    var source: String?
    ///  转发数
    var reposts_count: Int = 0
    ///  评论数
    var comments_count: Int = 0
    ///  表态数
    var attitudes_count: Int = 0
    ///  配图数组
    var pic_urls: [StatusPictureURL]?
    /// 用户信息
    var user: UserInfo?
    /// 转发微博
    var retweeted_status: Status?
    
    static func customClassMapping() -> [String : String]? {
        return ["pic_urls": "\(StatusPictureURL.self)",
        "user": "\(UserInfo.self)",
        "retweeted_status": "\(Status.self)",]
    }
}



///  微博配图模型
@objc(StatusPictureURL) class StatusPictureURL: NSObject,DictModelProtocol {
    ///  缩略图 URL
    var thumbnail_pic: String?
    static func customClassMapping() -> [String : String]? {
        return nil
    }
}
