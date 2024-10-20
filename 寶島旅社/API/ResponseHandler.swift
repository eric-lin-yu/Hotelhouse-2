//
//  ResponseHandler.swift
//  Pitaya
//
//  Created by Eric Lin on 2019/9/2.
//  Copyright © 2019 Eric Lin. All rights reserved.
//

import UIKit

struct ResponseHandler {
    /// 處理錯誤的回呼。
    ///
    /// - Parameters:
    ///   - statusCode: errorCode 狀態碼。預設值為 `nil`。
    ///   - errorString: 錯誤說明。
    static func errorHandler(statusCode: Int? = nil, errorString: String) {
        LoadingPageView.shard.dismiss()
        print("\n - - - - - - - - - - errorHandler - - - - - - - - - - \n")
        defer { print("\n - - - - - - - - - -  END - - - - - - - - - - \n") }
        
        var errorMsg = "發生一點錯誤,請稍後再試。"
        
        if let code = statusCode {
            switch code {
            case 401:
                errorMsg = "未經授權的存取。"
            case 404:
                errorMsg = "找不到指定的資源。"
            case 500:
                errorMsg = "伺服器發生內部錯誤。"
            default:
                errorMsg = "(\(code)) \(errorString)"
            }
        } else {
            errorMsg = "目前無法建立網路連線,請檢查是否已開啟手機上網功能!"
        }
        
        presentAlertHandler(message: errorMsg)
    }
    
    /// 顯示 Alert 彈窗。
    ///
    /// - Parameters:
    ///   - message: 警示訊息字串。
    ///   - handler: 點擊確定按鈕後的處理程式碼區塊。預設為 `nil`。
    static func presentAlertHandler(message: String, handler: (() -> Void)? = nil) {
        guard let window = SceneDelegate.shared?.window else {
            assertionFailure("Fail to prepare data parameter.")
            return
        }
        var vc = window.rootViewController
        if vc is UITabBarController {
            vc = (vc as! UITabBarController).selectedViewController
            if vc is UINavigationController {
                vc = (vc as! UINavigationController).visibleViewController

                // Convert HTML message to attributed string
//                guard let htmlData = message.data(using: .utf8) else {
//                    return
//                }
//                let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
//                    .documentType: NSAttributedString.DocumentType.html,
//                    .characterEncoding: String.Encoding.utf8.rawValue
//                ]
//                guard let attributedString = try? NSAttributedString(data: htmlData, options: options, documentAttributes: nil) else {
//                    return
//                }

                let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
//                alertController.setValue(attributedString, forKey: "attributedMessage")

                let okButton = UIAlertAction(title: "確定", style: .default) { (_) in
                    if let handler = handler {
                        handler()
                    }
                }
                alertController.addAction(okButton)
                vc?.present(alertController, animated: true, completion: nil)
            }
        }
    }

    
}
