//
//  RequestJSONTests.swift
//  SimpleNetwork
//
//  Created by 刘凡 on 15/3/1.
//  Copyright (c) 2015年 itheima. All rights reserved.
//

import UIKit
import XCTest

class RequestJSONTests: XCTestCase {

    /// 网络工具类
    let net = SimpleNetwork()
    /// 测试网络地址
    let urlString = "http://httpbin.org/get"
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testRequestJSON() {
        // 定义一个预期
        let expectation = expectationWithDescription(urlString)
        
        net.requestJSON(.GET, urlString, ["username": "大老虎"]) { (result, error) -> () in
            print("\(result) + \(error)")
            XCTAssertNotNil(result)
            XCTAssertNil(error)
            
            // 预期达成
            expectation.fulfill()
        }
        
        // 等待预期达成
        waitForExpectationsWithTimeout(10.0, handler: { (error) -> Void in
            XCTAssertNil(error)
        })
    }
    
    ///  测试主方法出错的回调
    func testRequestJSONError() {
        net.requestJSON(.GET, "", nil) { (result, error) -> () in
            XCTAssertNotNil(error)
        }
    }
    
    ///  测试 POST 请求
    func testPOSTRequest() {
        var request = net.request(.POST, urlString, ["name": "zhangsan"])
        XCTAssertEqual(request!.HTTPMethod!, "POST")
        XCTAssertEqual(request!.URL!.absoluteString, urlString)
        
 
        //MARK: - data不能断言要转成字符串
        //***💗方法 1
        XCTAssertEqual(request!.HTTPBody!.description, "name=zhangsan".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!.description)
        //***💗方法 2
        XCTAssertEqual(String(data: request!.HTTPBody!, encoding:NSUTF8StringEncoding), "name=zhangsan", "HTTPBody is correct")
        
//        guard let HTTPBodyData = request?.request?.HTTPBody else {
//            XCTAssertTrue(false, "HTTPBody data is not set")
//            return
//        }
        
        
        request = net.request(.POST, urlString, ["name": "zhangsan", "book": "ios 8.0"])
        XCTAssertEqual(request!.HTTPMethod!, "POST")
        XCTAssertEqual(request!.URL!.absoluteString, urlString)
        XCTAssertEqual(request!.HTTPBody!.description, "book=ios%208.0&name=zhangsan".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!.description)
    }
    
    ///  测试 GET 请求
    func testGETRequest() {
        var request = net.request(.GET, urlString, nil)
        XCTAssertEqual(request!.HTTPMethod!, "GET")
        XCTAssertEqual(request!.URL!.absoluteString, urlString)
        
        request = net.request(.GET, urlString, ["name": "zhangsan"])
        XCTAssertEqual(request!.URL!.absoluteString, urlString+"?name=zhangsan")
        
        request = net.request(.GET, urlString, ["name": "zhangsan", "book": "ios 8.0"])
        XCTAssertEqual(request!.URL!.absoluteString, urlString+"?book=ios%208.0&name=zhangsan")
    }
    
    ///  测试请求
    func testRequest() {
        XCTAssertNil(net.request(.GET, "", nil))
        XCTAssertNotNil(net.request(.GET, urlString, nil))
        
        XCTAssertNil(net.request(.POST, "", nil))
        XCTAssertNil(net.request(.POST, urlString, nil))
    }

    ///  测试请求字符串
    func testQueryString() {
        XCTAssertNil(net.quertString(nil))
        XCTAssert(net.quertString(["name": "zhangsan"])! == "name=zhangsan")
        XCTAssert(net.quertString(["title": "boss", "name": "zhangsan"])! == "title=boss&name=zhangsan")
        XCTAssert(net.quertString(["id": "app id", "title": "boss", "name": "zhangsan"])! == "id=app%20id&title=boss&name=zhangsan")
    }
}
