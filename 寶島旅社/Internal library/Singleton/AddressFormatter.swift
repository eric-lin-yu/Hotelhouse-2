//
//  AddressFormatter.swift
//  寶島旅社
//
//  Created by wistronits on 2023/9/13.
//  Copyright © 2023 Eric Lin. All rights reserved.
//

import Foundation

class AddressFormatter {
    static let shared = AddressFormatter()

    private init() {}

    func formatAddress(region: String, town: String, add: String) -> String {
        return region + town + add
    }
}

