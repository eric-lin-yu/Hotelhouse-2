//
//  AppIntent.swift
//  QuickSearchWidget
//
//  Created by Eric Lin on 2024/10/20.
//  Copyright © 2024 Eric Lin. All rights reserved.
//

import WidgetKit
import AppIntents

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource { "Configuration" }
    static var description: IntentDescription { "This is an example widget." }

    // An example configurable parameter.
    @Parameter(title: "Favorite Emoji", default: "😃")
    var favoriteEmoji: String
}
