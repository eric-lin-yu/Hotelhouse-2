//
//  QuickSearchWidgetLiveActivity.swift
//  QuickSearchWidget
//
//  Created by Eric Lin on 2024/10/20.
//  Copyright © 2024 Eric Lin. All rights reserved.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct QuickSearchWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct QuickSearchWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: QuickSearchWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension QuickSearchWidgetAttributes {
    fileprivate static var preview: QuickSearchWidgetAttributes {
        QuickSearchWidgetAttributes(name: "World")
    }
}

extension QuickSearchWidgetAttributes.ContentState {
    fileprivate static var smiley: QuickSearchWidgetAttributes.ContentState {
        QuickSearchWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: QuickSearchWidgetAttributes.ContentState {
         QuickSearchWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: QuickSearchWidgetAttributes.preview) {
   QuickSearchWidgetLiveActivity()
} contentStates: {
    QuickSearchWidgetAttributes.ContentState.smiley
    QuickSearchWidgetAttributes.ContentState.starEyes
}
