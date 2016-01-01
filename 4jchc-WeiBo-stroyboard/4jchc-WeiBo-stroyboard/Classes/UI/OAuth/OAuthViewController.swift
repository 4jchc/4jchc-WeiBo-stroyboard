//
//  OAuthViewController.swift
//  02-TDD
//
//  Created by apple on 15/2/28.
//  Copyright (c) 2015年 heima. All rights reserved.
//

import UIKit


//import SwiftDictModel

// 定义全局常量
let WB_Login_Successed_Notification = "WB_Login_Successed_Notification"

class OAuthViewController: UIViewController {

    /***请求成功-**{
    "access_token" = "2.00T53ksCiMQglBfca9810132k7niSC";
    "expires_in" = 157679999;
    "remind_in" = 157679999;
    uid = 2641236981;
    
    params["client_id"] = "1620692692";
    params["client_secret"] = "07f24cb123c91647e01b347eca27a5f7";
    params["grant_type"] = "authorization_code";
    params["redirect_uri"] = "http://www.baidu.com/";
    params["code"] = code; f407af7ed603b9ed0fe85b89fef510b8
    2fbd97b690fb415de69fbd045e23ea2e
    
    
    }*/
    ///*****✅读取微博地址:https://api.weibo.com/2/statuses/home_timeline.json
    
    
    let WB_API_URL_String       = "https://api.weibo.com"
    let WB_Redirect_URL_String  = "http://www.baidu.com/"//没有/无法显示登录页面
    let WB_Client_ID            = "1620692692"
    let WB_Client_Secret        = "07f24cb123c91647e01b347eca27a5f7"
    let WB_Grant_Type           = "authorization_code"
    
    @IBOutlet weak var webView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        webView.delegate = self
        loadAuthPage()
    
    }
    
    /// 加载授权页面
    func loadAuthPage() {
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(WB_Client_ID)&redirect_uri=\(WB_Redirect_URL_String)"
        let url = NSURL(string: urlString)
        
        webView.loadRequest(NSURLRequest(URL: url!))
    }

    
}





///*****✅代理webview
extension OAuthViewController: UIWebViewDelegate {
    
    /// 页面重定向
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        print("request.URL___\(request.URL)")
        
        let result = continueWithCode(request.URL!)
        if let code:String = result.code {
            
            print("可以换 accesstoke \(code)")
 
            let params = ["client_id": WB_Client_ID,
            "client_secret": WB_Client_Secret,
            "grant_type": WB_Grant_Type,
            "redirect_uri": WB_Redirect_URL_String,
            "code": code]

            let net = NetworkManager.sharedNetworkManager
            
            net.requestJSON(.POST, "https://api.weibo.com/oauth2/access_token", params, completion: { (result, error) -> () in
                
                print("\(result)----\(params)")
                
                ///*****✅调用自定义的模型SDK--SwiftDictModel
//                let token = SwiftDictModel.sharedManager.objectWithDictionary(result as! NSDictionary, cls: AccessToken.self) as! AccessToken
//                print("*****\(token.access_token)")
                ///*****✅原始方法--KVC
                //TODO:
//                let token = AccessToken(dict: result as! NSDictionary)
//                token.saveAccessToken()
                
                
                // 提问：对于 AccessToken 字典转模型，我们应该用框架吗？
                // 对于简单的模型，应该直接使用 KVC 即可！
                // JSON Model 1000，3s / 800M+
                // 切换UI - 通知
                NSNotificationCenter.defaultCenter().postNotificationName(WB_Login_Successed_Notification, object: nil)
                
            })
        }

        if !result.load {
            print("request.URL\(request.URL)")
//            SVProgressHUD.showInfoWithStatus("不加载")
            // 如果不加载页面，需要重新刷新授权页面
            // TODO: 有可能会出现多次加载页面，现在真的不正常了！
            // 只有点击取消按钮，才需要重新刷新授权页面
            if result.reloadPage {
               // SVProgressHUD.showWithStatus("你真的残忍的拒绝吗？")
               // SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.Gradient)
                
 
                loadAuthPage()
            }
        }
        print("*****\(result.load)")
        return  true//result.load
    }
    
    
    
    
    
    ////  根据URL判断是否继续
    ///
    ///  :param: url URL
    ///
    ///  :returns: 1. 是否加载当前页面 2. code(如果有) 3. 是否刷新授权页面
    
//    func continueWithCode(url: NSURL) -> (load: Bool, code: String?, reloadPage: Bool) {
//        
//        // 1. 将url转换成字符串
//        let urlString = url.absoluteString
//        print("urlString\(urlString)")
//        // 2. 如果不是微博的 api 地址，都不加载
//        if !urlString.hasPrefix(WB_API_URL_String) {
//            
//            // 3. 如果是回调地址，需要判断 code ithema.com
//            if urlString.hasPrefix(WB_Redirect_URL_String) {
//                
//                if let query = url.query {
//                    let codestr: NSString = "code="
//                    
//                    // 访问新浪微博授权的时候，带有回调地址的url只有两个，一个是正确的，一个是错误的！
//                    
//                    if query.hasPrefix(codestr as String) {
//                        
//                        let q = query as NSString!
//                        print("q.substringFromIndex(codestr.length)\(q.substringFromIndex(codestr.length))")
//                        return (false, q.substringFromIndex(codestr.length), false)
//                        
//                    } else {
//                        
//                        return (false, nil, true)
//                    }
//                }
//            }
//            
//            return (false, nil, false)
//        }
//        
//        return (false, nil, false)
//    }
//    
    
    
    
    
    
    
    

        func continueWithCode(url: NSURL) -> (load: Bool, code: String?, reloadPage: Bool) {
            let urlString = url.absoluteString
            print("___!urlString.hasPrefix(WB_API_URL_String)\(!urlString.hasPrefix(WB_API_URL_String))")
            
            print("_____urlString)\(urlString)")
            if !urlString.hasPrefix(WB_API_URL_String) {
                if urlString.hasPrefix(WB_Redirect_URL_String) {
                    if let query = url.query {
                        let codestr: NSString = "code="
                        
                        if query.hasPrefix(codestr as String) {
                            var q = query as NSString!
                            return (false, q.substringFromIndex(codestr.length), false)
                        } else {
                            return (false, nil, true)
                        }
                    }
                }
                return (false, nil, false)
            }
            return (true, nil, false)
        }
    
    
    
    
    
    
    
    
    
    ///*****✅ #pragma mark - webView代理方法
    func webViewDidFinishLoad(webView: UIWebView) {
       
        print("\(webViewDidFinishLoad)")
    }
    func webViewDidStartLoad(webView: UIWebView) {
        
    
        print("\(webViewDidStartLoad)")
    }
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        
        print("didFailLoadWithError)")
    }
    
    
    
    
    
    
    
    
}
