import Foundation
import UIKit
import CommonCrypto

public extension String {
    func strToSha256() -> Data {
        if let stringData = self.data(using: .utf8) {
            var digestData = Data(count: Int(CC_SHA256_DIGEST_LENGTH))
            _ = digestData.withUnsafeMutableBytes { digestBytes in
                stringData.withUnsafeBytes { stringBytes in
                    CC_SHA256(stringBytes.baseAddress, CC_LONG(stringData.count), digestBytes.bindMemory(to: UInt8.self).baseAddress)
                }
            }
            return digestData
        }
        return Data()
    }
    
    func formatDateToYearMonthDay() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        if let date = dateFormatter.date(from: self) {
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let formattedDate = dateFormatter.string(from: date)
            return formattedDate
        }
        return nil
    }
    
    func sizeOfString(usingFont font: UIFont) -> CGSize {
        let fontAttributes = [NSAttributedString.Key.font: font]
        return self.size(withAttributes: fontAttributes)
    }
    
    /// 格式化地址，將區域、城鎮和地址組合成單一字符串。
    /// - Parameters:
    ///   - region: 區域
    ///   - town: 城鎮
    ///   - add: 地址
    /// - Returns: 格式化後的地址字符串
    static func formattedAddress(region: String, town: String, add: String) -> String {
        return region + town + add
    }
}
