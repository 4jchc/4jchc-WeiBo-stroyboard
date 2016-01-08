//
//  EmoteTextAttachment.swift
//  4jchc-WeiBo-stroyboard
//
//  Created by 蒋进 on 16/1/8.
//  Copyright © 2016年 sijichcai. All rights reserved.
//

import UIKit

class EmoteTextAttachment: NSTextAttachment {

    // 表情对应的文本符号
    var emoteString: String?
    
    /// 返回一个 属性字符串
    class func attributeString(emoticon: Emoticon, height: CGFloat) -> NSAttributedString {
        let attachment = EmoteTextAttachment()
        attachment.image = UIImage(contentsOfFile: emoticon.imagePath!)
        attachment.emoteString = emoticon.chs
        
        // 设置高度
        attachment.bounds = CGRectMake(0, -4, height, height)
        
        // 2. 带图像的属性文本
        return NSAttributedString(attachment: attachment)
    }
}


