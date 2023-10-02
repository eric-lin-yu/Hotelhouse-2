//
//  LocationManager.swift
//  寶島旅社
//
//  Created by wistronits on 2023/10/2.
//  Copyright © 2023 Eric Lin. All rights reserved.
//

import CoreLocation
import UIKit

class LocationManager: NSObject, CLLocationManagerDelegate {
    static let shared = LocationManager()
    
    private let manager = CLLocationManager()
    private var locationCompletion: ((CLLocation) -> Void)?
    
    private override init() {
        super.init()
        manager.delegate = self
    }
    
    func getUserLocation(completion: @escaping (CLLocation) -> Void) {
        locationCompletion = completion
        
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            showLocationDeniedAlert()
        case .authorizedWhenInUse, .authorizedAlways:
            manager.startUpdatingLocation()
        default:
            break
        }
    }
    
    private func showAlert(title: String, message: String, handler: (() -> Void)? = nil) {
        guard let window = SceneDelegate.shared?.window else {
            assertionFailure("Fail to prepare data parameter.")
            return
        }
        var vc = window.rootViewController
        if vc is UITabBarController {
            vc = (vc as! UITabBarController).selectedViewController
            if vc is UINavigationController {
                vc = (vc as! UINavigationController).visibleViewController
                
                let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                
                let okButton = UIAlertAction(title: "前往開啟", style: .default) { (_) in
                    if let handler = handler {
                        handler()
                    }
                }
                
                let cancelBtn = UIAlertAction(title: "取消", style: .destructive, handler: nil)
                alertController.addAction(okButton)
                alertController.addAction(cancelBtn)
                
                vc?.present(alertController, animated: true, completion: nil)
            }
        }
    }

    private func showLocationDeniedAlert() {
        let message = "如欲使用此功能，請開啟定位權限\n\n請至\n設定 > 隱私權與安全性 >\n定位服務 > 允許旅社取得您得位置。"
        showAlert(title: "定位權限已關閉", message: message) {
            // 開啟設定
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
        }
    }
}
