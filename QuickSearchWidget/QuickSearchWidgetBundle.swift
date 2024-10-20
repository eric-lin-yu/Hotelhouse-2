//
//  QuickSearchWidgetBundle.swift
//  QuickSearchWidget
//
//  Created by Eric Lin on 2024/10/20.
//  Copyright © 2024 Eric Lin. All rights reserved.
//

import WidgetKit
import SwiftUI

@main
struct QuickSearchWidgetBundle: WidgetBundle {
    var body: some Widget {
        QuickSearchWidget()
        QuickSearchWidgetControl()
        QuickSearchWidgetLiveActivity()
    }
}
