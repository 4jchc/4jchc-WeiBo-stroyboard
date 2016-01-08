//
//  ComposeViewController.swift
//  HMWeibo04
//
//  Created by apple on 15/3/5.
//  Copyright (c) 2015年 heima. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {

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
    

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        // 关闭键盘
        textView.resignFirstResponder()
    }
    
    /// 发送微博
    @IBAction func sendStatus(sender: UIBarButtonItem) {
        let urlString = "https://api.weibo.com/2/statuses/update.json"
        
        if let token = AccessToken.loadAccessToken()?.access_token {
            let params = ["access_token": token,
                "status": textView.text!]
            
            let net = NetworkManager.sharedNetworkManager
            // 重点提示：params中一定都要确保有值，否则会提示 .POST 不正确！
            net.requestJSON(.POST, urlString, params) { (result, error) -> () in
                SVProgressHUD.showInfoWithStatus("微博发送成功")
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置 UI
        setupUI()
        
        // 注册通知
        registerNotification()
        // 添加子视图控制器 － 可以保证响应者链条正常传递
        self.addChildViewController(emoticonsVC!)
    }
    
    /// 设置 UI
    func setupUI() {
        // 文本框默认不支持滚动，设置此属性后，能够滚动！
        textView.alwaysBounceVertical = true
        textView.addSubview(placeHolderLabel!)
        
        // 设置文本框的默认焦点
        textView.becomeFirstResponder()
    }
    
    /// 注册键盘通知
    func registerNotification() {
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
    // MARK: - 选择表情部分代码
    /// 表情视图控制器
    lazy var emoticonsVC: EmoticonsViewController? = {
        let sb = UIStoryboard(name: "Emoticons", bundle: nil)
        let vc = sb.instantiateInitialViewController() as? EmoticonsViewController
        
        // 1. 设置代理
        vc?.delegate = self
        
        return vc
    }()

    

    /// 选择表情
    @IBAction func selectEmote() {
        
        // inputView == nil 就使用的是系统的键盘
        print(textView.inputView)
        
        // 关闭键盘
        textView.resignFirstResponder()
        
        // 更换 textView 的输入视图[键盘]
        // 如果要更换文本框的输入视图，需要注意当前文本框不能处于输入状态
        //        let v = UIView(frame: CGRectMake(0, 0, 320, 216))
        //        v.backgroundColor = UIColor.redColor()
        
        if textView.inputView == nil {
            textView.inputView = emoticonsVC?.view
        } else {
            textView.inputView = nil
        }
        
        // 开启键盘
        textView.becomeFirstResponder()
    }
    
}
// 2. 遵守协议(通过 extension)并且实现方法！
extension ComposeViewController: EmoticonsViewControllerDelegate {
    
    func emoticonsViewControllerDidSelectEmoticon(vc: EmoticonsViewController, emoticon: Emoticon) {
        print("\(emoticon.chs)")
        
        // 设置文本
        if emoticon.chs != nil {
            // 图文混排的入口
            let str = emoticon.chs
            
            // 1. 图像附件 － 一个附件对应一个独立的字符，可以用删除键直接咔嚓！
            let attachment = NSTextAttachment()
            attachment.image = UIImage(contentsOfFile: emoticon.imagePath!)
            // 设置高度
            let height = textView.font!.lineHeight
            attachment.bounds = CGRectMake(0, 0, height, height)
            
            // 2. 带图像的属性文本
            let attributeString = NSAttributedString(attachment: attachment)
            
            // 3. 替换 textView 中的属性文本
            // 3.1 可变的属性文本
            let strM = NSMutableAttributedString(attributedString: textView.attributedText)
            strM.replaceCharactersInRange(textView.selectedRange, withAttributedString: attributeString)
            // 3.2 设置完文本属性之后，字体会发生变化 － 定义在 NSAttributedString.h 头文件中
            // 设置整个属性字符串中的文本属性
            let range = NSMakeRange(0, strM.length)
            strM.addAttribute(NSFontAttributeName, value: textView.font!, range: range)
            
            // 3.3 记录光标位置 location 对应光标的位置
            let location = textView.selectedRange.location
            
            // 3.4 设置 textView 中的文本 － 把图片插入之后，直接替换整个文本
            // 结果会导致光标移动到文本末尾
            textView.attributedText =  strM
            
            // 3.5 重新设置光标位置
            textView.selectedRange = NSMakeRange(location + 1, 0)
            
            // 3.6 测试！！！
            print(textView.text)
            
        } else if emoticon.emoji != nil {
            // 应该在用户光标位置“插入”表情文本
            textView.replaceRange(textView.selectedTextRange!, withText: emoticon.emoji!)
        }
    }
}



/// UITextView 的扩展

extension ComposeViewController: UITextViewDelegate {
    

    /// 将要使用 replacementText 添加到 textView 的 range 位置
    /// 能够在用户输入之前进行判断
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        // 删除键或者其他的功能键如何判断？
        if text.isEmpty {
            print("是删除吗？")
            return true
        }
        
        // 在 textView 控件中，没有代理方法监听回车键！
        // 以下代码是在 textView 中拦截回车键的办法
        if text == "\n" {
            print("回车键")
            view.endEditing(true)
        }
        
        // 微博文字通常限制 140 个字
        if textView.text.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) + text.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 10 {
            return false
        }
        
        return true
    }
    func textViewDidChange(textView: UITextView) {
        print(textView.text)
        
        placeHolderLabel!.hidden = !textView.text.isEmpty
        sendButton.enabled = !textView.text.isEmpty
    }
    /// 滚动视图开始被拖拽
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        textView.resignFirstResponder()
    }

}









