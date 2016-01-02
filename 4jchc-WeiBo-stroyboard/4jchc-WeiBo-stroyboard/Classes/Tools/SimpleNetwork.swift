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

    
    
    //MARK: -下载多张图片
    func demoGCDGroup() {
        /**
         dispatch_group_async(dispatch_group_t group, dispatch_queue_t queue, dispatch_block_t block)
         {
         dispatch_retain(group);
         
         // 一旦使用了 enter，后续的 block 就会被 group 监听
         dispatch_group_enter(group);
         
         dispatch_async(queue, ^{
         block();
         
         // 异步执行完毕之后，必须要使用 dispatch_group_leave
         dispatch_group_leave(group);
         
         dispatch_release(group);
         });
         }
         */
         
         // 利用调度组统一监听一组异步任务执行完毕
        let group = dispatch_group_create()
        
        dispatch_group_async(group, dispatch_get_global_queue(0, 0)) { () -> Void in
            
        }
        
        dispatch_group_notify(group, dispatch_get_main_queue()) { () -> Void in
            // 所有任务完成后的回调
        }
    }
    
    
    ///  异步下载网路图像
    ///
    ///  :param: urlString  urlString
    ///  :param: completion 完成回调
    func requestImage(urlString: String, _ completion: Completion) {
        
        // 1. 调用 download 下载图像，如果图片已经被缓存过，就不会再次下载
        
        self.downloadImage(urlString) { (result, error) -> () in
            
            // 2.1 错误处理
            if error != nil {
                completion(result: nil, error: error)
            } else {
                // 2.2 图像是保存在沙盒路径中的，文件名是 url ＋ md5
                let path = self.fullImageCachePath(urlString)
                // 将图像从沙盒加载到内存
                let image = UIImage(contentsOfFile: path)
                
                // 提示：尾随闭包，如果没有参数，没有返回值，都可以省略！
                dispatch_async(dispatch_get_main_queue()) {
                    completion(result: image, error: nil)
                }
            }
            
        }

    }
    
    ///  完整的 URL 缓存路径
    func fullImageCachePath(urlString: String) -> String {
        let path = urlString.md5 as String


        return   NSURL(fileURLWithPath: cachePath!).URLByAppendingPathComponent(path).path!
        //return (cachePath! as NSString).stringByAppendingPathComponent(path)
    }
    

    
    ///  下载多张图片
    ///
    ///  - parameter urls:       图片 URL 数组
    ///  - parameter completion: 所有图片下载完成后的回调
    func downloadImages(urls: [String], _ completion: Completion) {
        
        // 希望所有图片下载完成，统一回调！
        
        // 利用调度组统一监听一组异步任务执行完毕
        let group = dispatch_group_create()
        
        // 遍历数组
        for url in urls {
            // 进入调度组
            dispatch_group_enter(group)
            downloadImage(url) { (result, error) -> () in
                // 一张图片下载完成，会自动保存在缓存目录
                // 下载多张图片的时候，有可能有些有错误，有些没错误！
                // 暂时不处理
                
                // 离开调度组
                dispatch_group_leave(group)
            }
        }
        
        // 在主线程回调
        dispatch_group_notify(group, dispatch_get_main_queue()) { () -> Void in
            // 所有任务完成后的回调
            completion(result: nil, error: nil)
        }
    }
    
    ///  下载图像并且保存到沙盒
    ///
    ///  - parameter urlString:  urlString
    ///  - parameter completion: 完成回调
    func downloadImage(urlString: String, _ completion: Completion) {
        
        // 1. 将下载的图像 url 进行 md5
        var path = urlString.md5
        // 2. 目标路径
        
        path = (cachePath! as NSString).stringByAppendingPathComponent(path)
        
        // 2.1 缓存检测，如果文件已经下载完成直接返回
        if NSFileManager.defaultManager().fileExistsAtPath(path) {
            print("\(urlString) 图片已经被缓存")
            completion(result: nil, error: nil)
            return
        }
        
        // 3. 下载图像
        if let url = NSURL(string: urlString) {
            self.session!.downloadTaskWithURL(url) { (location, _, error) -> Void in
                
                // 错误处理
                if error != nil {
                    completion(result: nil, error: error)
                    return
                }
                
                do {
                    // 将文件复制到缓存路径
                    try NSFileManager.defaultManager().copyItemAtPath(location!.path!, toPath: path)
                } catch _ {
                    
                }
                
                // 直接回调，不传递任何参数
                completion(result: nil, error: nil)
                }.resume()}
        else {
            let error = NSError(domain: SimpleNetwork.errorDomain, code: -1, userInfo: ["error": "无法创建 URL"])
            completion(result: nil, error: error)
        }

            
            
            
        }

    
    /// 完整图像缓存路径
    lazy var cachePath: String? = {
        // 1. cache
        var path = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true).last
        NSURL(fileURLWithPath: NSTemporaryDirectory()).URLByAppendingPathComponent("instagram.igo")
        
        
        
        path = (path as NSString!).stringByAppendingPathComponent(imageCachePath)
        
        // 2. 检查缓存路径是否存在 － 注意：必须准确地指出类型 ObjCBool
        var isDirectory: ObjCBool = true
        // 无论存在目录还是文件，都会返回 true，是否是路径由 isDirectory 来决定
        let exists = NSFileManager.defaultManager().fileExistsAtPath(path!, isDirectory: &isDirectory)
        print("isDirectory： \(isDirectory) exists \(exists) path: \(path)")
        
        // 3. 如果有同名的文件－干掉
        // 一定需要判断是否是文件，否则目录也同样会被删除
        if exists && !isDirectory {
            do {
                try NSFileManager.defaultManager().removeItemAtPath(path!)
            } catch _ {
            }
        }
        
        do {
            // 4. 直接创建目录，如果目录已经存在，就什么都不做
            // withIntermediateDirectories -> 是否智能创建层级目录
            try NSFileManager.defaultManager().createDirectoryAtPath(path!, withIntermediateDirectories: true, attributes: nil)
        } catch _ {
        }
        
        return path
    }()
    
    /// 缓存路径的常量 - 类变量不能存储内容，但是可以返回数值
    private static var imageCachePath = "com.itheima.imagecache"
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //MARK: -JSON
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
                print("urlStr111\( urlStr )")
            }
            print("urlStr222\( urlStr )---NSMutableURLRequest-\(NSMutableURLRequest(URL: NSURL(string: urlStr)!))")
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
            
            let str = k + "=" + v.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.alphanumericCharacterSet())!
            
            query.append(str)
            print("query--\(query)")
       
        }
        print("query.joinWithSeparator-----\(query.joinWithSeparator("&"))")
        return query.joinWithSeparator("&")
        
        
        
//        var array = [String]()
//        for (key, value) in params! {
//            let str = key + "=" + value.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
//            array.append(str)
//        }
//        print("array.joinWithSeparator---\(array.joinWithSeparator("&"))")
//        print("array.joinWithSeparator("&")--\(array.joinWithSeparator("&"))")
//        
//        return array.joinWithSeparator("&")
        
        
        
        
        
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