//
//  Untitled.swift
//  寶島旅社
//
//  Created by wistronits on 2025/1/7.
//  Copyright © 2025 Eric Lin. All rights reserved.
//

import UIKit

extension NSObject {
    
    class var className: String {
        return String(describing: self)
    }

    var className: String {
        return type(of: self).className
    }
}
