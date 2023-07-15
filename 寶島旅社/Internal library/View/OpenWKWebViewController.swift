//
//  WKWebViewController.swift
//  Pitaya
//
//  Created by Eric Lin on 2022/6/22.
//  Copyright © 2022 Eric Lin. All rights reserved.
//

import UIKit
import WebKit

class OpenWKWebViewController: UIViewController {
    static func make(urlString: String, title: String) -> OpenWKWebViewController {
        let vc = OpenWKWebViewController()
        vc.urlString = urlString
        vc.titleName = title
        return vc
    }
    
    var urlString = ""
    var titleName = ""
    /// 載入頁
    lazy var loadingPageView: LoadingPageView = {
        return LoadingPageView()
    }()
    
    private lazy var webView: WKWebView = {
        let view = WKWebView()
        return view
    }()
    
    func setupUI() {
        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        webView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        webView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        webView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI() //Web View建立
        webView.uiDelegate = self
        webView.navigationDelegate = self
        
        navigationItem.title = titleName
        
        if self.urlString != "" {
            guard let url = URL(string: self.urlString) else {
                assertionFailure("Fail to prepare data parameter.")
                return
            }
            webView.load(URLRequest(url: url))
        } else {
            let alerts = UIAlertController(title: "通知", message: "此旅店尚未提供官網", preferredStyle: .alert)
            let okBth = UIAlertAction(title: "關閉", style: .default) { _ in
                self.navigationController?.popViewController(animated: true)
            }
            alerts.addAction(okBth)
            self.present(alerts, animated: true, completion: nil)
            
        }
    }
    
}

//MARK: - WKUIDelegate
extension OpenWKWebViewController: WKUIDelegate {
    
    //顯示JavaScript 確認Alert
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        
        let alert = UIAlertController(title: "通知", message: message, preferredStyle: .alert)
        let okBtn = UIAlertAction(title: "關閉", style: .default) { _ in
            completionHandler(true)
        }
        alert.addAction(okBtn)
        self.present(alert, animated: true, completion: nil)
    }
    
    //顯示JavaScript 警告Alert
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        
        let alert = UIAlertController(title: "通知", message: message, preferredStyle: .alert)
        let okBtn = UIAlertAction(title: "關閉", style: .default) { _ in
            completionHandler()
        }
        alert.addAction(okBtn)
        self.present(alert, animated: true, completion: nil)
    }
}

//MARK: WKNavigationDelegate
extension OpenWKWebViewController: WKNavigationDelegate {
    
    //webView開始載入時呼叫
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        loadingPageView.show()
    }
    
    //webView載入完成後呼叫
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.loadingPageView.dismiss()
        }
    }
    
    //在發送請求之前，決定是否跳轉
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        let closeURL = navigationAction.request.url?.absoluteString ?? ""
        if closeURL.contains("viewclose") {
            self.navigationController?.popViewController(animated: true)
        }
        decisionHandler(.allow)
    }
    
    //網路安全性例外處理
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            let card = URLCredential.init(trust: challenge.protectionSpace.serverTrust! )
            completionHandler(URLSession.AuthChallengeDisposition.useCredential,card)
        }
    }

}
