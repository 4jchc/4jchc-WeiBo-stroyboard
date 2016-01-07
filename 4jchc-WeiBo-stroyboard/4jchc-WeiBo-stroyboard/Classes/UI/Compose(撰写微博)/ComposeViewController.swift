//
//  ComposeViewController.swift
//  HMWeibo04
//
//  Created by apple on 15/3/5.
//  Copyright (c) 2015年 heima. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController ,UITextViewDelegate{

    ///  取消
    @IBAction func cancel(sender: UIBarButtonItem) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    /// 发送按钮
    @IBOutlet weak var sendButton: UIBarButtonItem!
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
    @IBOutlet weak var textView: UITextView!

    @IBOutlet weak var toolBarBottomConstraint: NSLayoutConstraint!
    
    
    func textViewDidChange(textView: UITextView) {
        print(textView.text)
       
        placeHolderLabel!.hidden = !textView.text.isEmpty
        sendButton.enabled = !textView.text.isEmpty
    }
    /// 滚动视图开始被拖拽
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        textView.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 文本框默认不支持滚动，设置此属性后，能够滚动！
        textView.alwaysBounceVertical = true
        textView.addSubview(placeHolderLabel!)
        // 设置文本框的默认焦点
        textView.becomeFirstResponder()
        // 添加观察者，监听键盘框架的变化
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardFrameChanged:", name: UIKeyboardWillChangeFrameNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardFrameChanged:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    deinit {
        
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
//        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillChangeFrameNotification, object: nil)
//        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    /// 键盘变化监听方法
    func keyboardFrameChanged(notification: NSNotification) {
        print(notification)
        
        var height: CGFloat = 0
        var duration = 0.25
        
        if notification.name == UIKeyboardWillChangeFrameNotification {
            let rect = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
            height = rect.size.height
            
            duration = (notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        }
        
        toolBarBottomConstraint.constant = height

        UIView.animateWithDuration(duration) {
            
            self.view.layoutIfNeeded()
        }
    
    }




}
