//
//  ComposeTextView.swift
//  4jchc-WeiBo-stroyboard
//
//  Created by 蒋进 on 16/1/8.
//  Copyright © 2016年 sijichcai. All rights reserved.
//

import UIKit

class ComposeTextView: UITextView {

    
    /// 占位文本 － 注意：懒加载的对象属性，不要使用 weak
    lazy var placeHolderLabel: UILabel? = {
        let l = UILabel()
        l.text = "分享新鲜事..."
        l.font = UIFont.systemFontOfSize(18)
        l.textColor = UIColor.lightGrayColor()
        l.frame = CGRectMake(5, 8, 0, 0)
        // 可以根据文本的内容大小，自动调整
        l.sizeToFit()
        
        return l
    }()
    
    override func awakeFromNib() {
        // 添加占位文本
        addSubview(placeHolderLabel!)
        
        // 文本框默认不支持滚动，设置此属性后，能够滚动！
        alwaysBounceVertical = true
    }


}


//extension UITextView {
//    
//    /// 占位文本 － 注意：懒加载的对象属性，不要使用 weak
//    var placeHolderLabel : UILabel? {
//        get{
//            let l = UILabel()
//            l.text = "分享新鲜事..."
//            l.font = UIFont.systemFontOfSize(18)
//            l.textColor = UIColor.lightGrayColor()
//            l.frame = CGRectMake(5, 8, 0, 0)
//            // 可以根据文本的内容大小，自动调整
//            l.sizeToFit()
//            
//            return l
//
//        }
//        set{
//            placeHolderLabel?.text = newValue?.text
//        }
//        
//    }
//    
//
//    override public func awakeFromNib() {
//        // 添加占位文本
//        addSubview(placeHolderLabel!)
//       
//        // 文本框默认不支持滚动，设置此属性后，能够滚动！
//        alwaysBounceVertical = true
//    }
//    
//}