//  Created by Eric Lin  on 2019/11/1.
//  Copyright © 2019 Eric Lin . All rights reserved.
//

import UIKit

extension UIView {
    /// View add 邊框
    func addRoundBorder(cornerRadius: CGFloat = 15, 
                        borderWidth: CGFloat = 1,
                        borderColor: UIColor = .black,
                        backgroundColor: UIColor = .white) {
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
        self.backgroundColor = backgroundColor
    }
}
