import Foundation
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
}
