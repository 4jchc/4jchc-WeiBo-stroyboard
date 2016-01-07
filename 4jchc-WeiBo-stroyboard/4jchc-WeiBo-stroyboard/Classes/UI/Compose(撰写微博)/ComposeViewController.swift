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
    
    @IBOutlet weak var placeHolderLabel: UILabel!
    
    @IBOutlet weak var toolBarBottomConstraint: NSLayoutConstraint!
    
    
    func textViewDidChange(textView: UITextView) {
        print(textView.text)
        placeHolderLabel.hidden = !textView.text.isEmpty
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 添加观察者，监听键盘框架的变化
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardFrameChanged:", name: UIKeyboardWillChangeFrameNotification, object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillChangeFrameNotification, object: nil)
        
    }
    
    /// 键盘变化监听方法
    func keyboardFrameChanged(notification: NSNotification) {
        print(notification)
        
        let rect = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        let duration = (notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        toolBarBottomConstraint.constant = rect.size.height
        
        UIView.animateWithDuration(duration) {
            
            self.view.layoutIfNeeded()
        }
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
