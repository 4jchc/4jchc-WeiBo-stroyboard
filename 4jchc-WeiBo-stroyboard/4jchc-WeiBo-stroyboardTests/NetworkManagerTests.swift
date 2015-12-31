//
//  NetworkManagerTests.swift
//  4jchc-WeiBo-stroyboard
//
//  Created by 蒋进 on 15/12/31.
//  Copyright © 2015年 sijichcai. All rights reserved.
//

import XCTest

class NetworkManagerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    ///  测试单例
    func testSingleton() {
        let manager1 = NetworkManager.sharedNetworkManager
        let manager2 = NetworkManager.sharedNetworkManager
        
        XCTAssert(manager1 === manager2)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
}
