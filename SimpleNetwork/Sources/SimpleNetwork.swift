//
//  SimpleNetwork.swift
//  SimpleNetwork
//
//  Created by 刘凡 on 15/3/1.
//  Copyright (c) 2015年 itheima. All rights reserved.
//

import Foundation

///  HTTP 访问方法
public enum HTTPMethod: String {
    case GET =  "GET"
    case POST = "POST"
}

public class SimpleNetwork {

    ///  完成回调类型定义
    ///
    ///  :param: result 返回结果
    ///  :param: error  网络访问错误
    public typealias Completion = (result: AnyObject?, error: NSError?) -> ()
    
    ///  请求 JSON
    ///
    ///  :param: method     HTTP方法
    ///  :param: urlString  urlString
    ///  :param: params     可选参数字典
    ///  :param: completion 完成回调
    public func requestJSON(method: HTTPMethod, _ urlString: String, _ params: [String: String]? = nil, _ completion: Completion) {
        if let request = request(method, urlString, params) {
            session!.dataTaskWithRequest(request, completionHandler: { (data, _, error) -> Void in
                
                // 判断是否出现错误
                if error != nil {
                    completion(result: nil, error: error)
                    return
                }

                // JSON 反序列化
                
                if let json: AnyObject = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) {
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        completion(result: json, error: nil)
                    }
                } else {
                    let error = NSError(domain: SimpleNetwork.errorDomain, code: -1, userInfo: ["error": "JSON反序列化失败"])
                    print(error)
                }
            }).resume()
            
            return
        }
        
        let error = NSError(domain: SimpleNetwork.errorDomain, code: -1, userInfo: ["error": "网络请求创建失败"])
        completion(result: nil, error: error)
    }
    
    ///  根据方法建立网络请求
    ///
    ///  :param: method     HTTP方法
    ///  :param: urlString  urlString
    ///  :param: params     可选参数字典
    ///
    ///  :returns: NSURLRequest?
    func request(method: HTTPMethod, _ urlString: String, _ params: [String: String]?) -> NSURLRequest? {
        
        if urlString.isEmpty {
            return nil
        }
        
        var urlStr = urlString
        var request: NSMutableURLRequest?
        
        switch method {
        case .GET:
            if let query = quertString(params) {
                urlStr += "?" + query
            }
            request = NSMutableURLRequest(URL: NSURL(string: urlStr)!)
        case .POST:
            if let query = quertString(params) {
                request = NSMutableURLRequest(URL: NSURL(string: urlStr)!)
                assert(request != nil, "Request 创建失败!")
                
                request!.HTTPMethod = method.rawValue
                request!.HTTPBody = query.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
            }
        }
        
        return request
    }
    
    ///  根据参数字典生成---拼接--查询字符串
    ///
    ///  :param: params 参数字典
    ///
    ///  :returns: 查询参数
    func quertString(params: [String: String]?) -> String? {
        
        if params == nil {
            return nil
        }
        
        // 查询字符串数组
        var query = [String]()
        for (k, v) in params! {
            
            let str = k + "=" + v.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
            
            query.append(str)
       
        }
        
        return query.joinWithSeparator("&")
    }
    
    ///  公共构造函数
    public convenience init () {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        self.init(configuration: configuration)
    }

    ///  构造函数
    ///
    ///  :param: timeoutInterval 超时时长
    public convenience init(timeoutInterval: NSTimeInterval) {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.timeoutIntervalForRequest = timeoutInterval
        configuration.timeoutIntervalForResource = timeoutInterval

        self.init(configuration: configuration)
        
        // 注意，在调用默认构造函数之前，不能在convenience构造函数中使用属性
        self.timeoutInterval = timeoutInterval
    }

    ///  默认构造函数
    public init(configuration: NSURLSessionConfiguration) {
        self.session = NSURLSession(configuration: configuration)
    }

    ///  网络会话
    var session: NSURLSession?
    ///  默认网络超时时长
    var timeoutInterval: NSTimeInterval?
    ///  错误域常量
    private static let errorDomain = "com.itheima.errorDomain"
}