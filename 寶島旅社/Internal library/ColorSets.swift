//
//  ColorSets.swift
//  Created by Eric Lin on 2022/2/21.
//  Copyright © 2022 Eric Lin. All rights reserved.
//
import UIKit

extension UIColor {
    // 主色調
    static let mainGreen: UIColor = { return UIColor.init(hexString: "#B6C9BB") }()
    
    static let mainRed: UIColor = { return UIColor.init(hexString: "#f74311") }()
    
    static let mainGray: UIColor = { return UIColor.init(hexString: "#c4c4c4") }()
    
    /// 白煙色
    static let whitesmokeGray: UIColor = { return UIColor.init(hexString: "F5F5F5") }()
    
    /// 薄霧玫瑰色
    static let mistyRose: UIColor = { return UIColor.init(hexString: "#F9C6CF") }()
    
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
