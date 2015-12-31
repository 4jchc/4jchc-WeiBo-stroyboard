//
//  NetworkManager.swift
//  HMWeibo04
//
//  Created by apple on 15/3/2.
//  Copyright (c) 2015年 heima. All rights reserved.
//

import Foundation


import SimpleNetwork

///  网路访问接口 - 单例
///  用来隔离应用程序和第三方框架之间的网络访问
class NetworkManager {
    
    
    
    ////*****✅/ 单例的概念：
    // 1. 内存中有一个唯一的实例
    // 2. 提供唯一的全局访问入口
    // let 是定义常量，而且在 swift 中，let 是线程安全的
    private static let instance = NetworkManager()

    /// 定义一个类变量，提供全局的访问入口
    class var sharedNetworkManager: NetworkManager {
        
        return instance
        
    }
    
    
    
    // 定义了一个类的完成闭包类型
    typealias Completion = (result: AnyObject?, error: NSError?) -> ()

    func requestJSON(method: HTTPMethod, _ urlString: String, _ params: [String: String]?, completion: Completion) {
        
        net.requestJSON(method, urlString, params, completion)
    }

    
    
    
    ///*****✅第三方框架入口
    ///  全局的一个网络框架实例，本身也只会被实例化一次
    private let net = SimpleNetwork()
}






