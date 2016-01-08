//
//  Emoticons.swift
//  4jchc-WeiBo-stroyboard
//
//  Created by 蒋进 on 16/1/8.
//  Copyright © 2016年 sijichcai. All rights reserved.
//

import Foundation

/// 表情符号分组
class EmoticonsSection {
    /// 分组名称
    var name: String?
    /// 类型
    var type: String?
    /// 路径
    var path: String?
    /// 表情符号的数组(每一个 section中应该包含21个表情符号，界面处理是最方便的)
    /// 其中21个表情符号中，最后一个删除(就不能使用plist中的数据)
    var emoticons: [Emoticon]?
    
    /// 加载表情符号分组数据
    class func loadEmoticons() -> [EmoticonsSection] {
        
        // 1. 路径
        let path = NSURL(fileURLWithPath: NSBundle.mainBundle().bundlePath).URLByAppendingPathComponent("Emoticons/emoticons.plist").path!
        //let path = (NSBundle.mainBundle().bundlePath as NSString).stringByAppendingPathComponent("Emoticons/emoticons.plist")
        let array = NSArray(contentsOfFile: path)
        
        // 2. 遍历数组
        var result = [EmoticonsSection]()
        for dict in array as! [NSDictionary] {
            // 进入 group_path 对应的目录进一步加载数据
            result += loadEmoticons(dict)
        }
        
        return [EmoticonsSection]()
    }
    
    /// 使用 dict 加载 group_path 对应的表情符号数组
    class func loadEmoticons(dict: NSDictionary) -> [EmoticonsSection] {
        // 1. 根据 dict 中的 group_path 加载不同目录中的 info.plist
        let group_path = dict["emoticon_group_path"] as! String
        
        let path = (NSBundle.mainBundle().bundlePath as NSString).stringByAppendingPathComponent("Emoticons/\(group_path)/info.plist")

        // 2. 加载 info.plist
        let infoDict = NSDictionary(contentsOfFile: path)!
        
        // 3. 从 infoDict 的 emoticon_group_emoticons 中提取表情符号数组
        let list = infoDict["emoticon_group_emoticons"] as! NSArray
        let result = loadEmoticons(list, dict: dict)
        
        return result
    }
    
    /// 从 emoticon_group_emoticons 返回表情数组的数组，每一个数组 都 包含 21 个表情(最后一个是空的)
    /// 这是真正创建数据的函数！
    class func loadEmoticons(list: NSArray, dict: NSDictionary) -> [EmoticonsSection] {
        
        
        
        return [EmoticonsSection]()
    }
}

/// 表情符号类
class Emoticon {
    /// emoji 的16进制字符串
    var code: String?
    /// 类型
    var type: String?
    /// 表情符号的文本 - 发送给服务器的文本
    var chs: String?
    /// 表情符号的图片 - 本地做图文混排使用的图片
    var png: String?
}






