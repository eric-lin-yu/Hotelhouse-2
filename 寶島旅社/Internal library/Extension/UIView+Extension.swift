//
//  Extension+UIView.swift
//  DemoChatRoom
//
//  Created by Thinkpower on 2019/11/1.
//  Copyright © 2019 Thinkpower. All rights reserved.
//

import UIKit

extension UIView {
    /// View add 邊框
    public func roundFrameView(roundView: UIView, color: UIColor? = nil) {
        // 圓角
        roundView.layer.cornerRadius = 15
        roundView.layer.masksToBounds = true
        
        // 邊框線條處理
        roundView.layer.borderWidth = 1
        roundView.layer.borderColor = UIColor.black.cgColor
        
        if color == nil {
            roundView.backgroundColor = UIColor.white
        } else {
            roundView.backgroundColor = color
        }
    }
    
}
