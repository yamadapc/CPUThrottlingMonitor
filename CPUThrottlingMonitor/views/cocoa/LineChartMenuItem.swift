//
//  LineChartMenuItem.swift
//  CPUThrottlingMonitor
//
//  Created by Pedro Tacla Yamada on 22/10/20.
//  Copyright © 2020 Pedro Tacla Yamada. All rights reserved.
//

import SwiftUI
import Cocoa

class LineChartMenuItem: NSMenuItem {
    let hostingView: NSHostingView<ContentView>?

    init(
        cpuThrottlingState: CPUThrottlingState
    ) {
        let contentView = ContentView(state: cpuThrottlingState)
        let hostingView = NSHostingView(rootView: contentView)
        self.hostingView = hostingView
        super.init(title: "Custom", action: nil, keyEquivalent: "")

        hostingView.frame = NSRect(
            origin: CGPoint(),
            size: CGSize(width: 250.0, height: 100.0)
        )
        self.isEnabled = true
        self.view = hostingView
    }

    required init(coder: NSCoder) {
        self.hostingView = nil
        super.init(coder: coder)
    }
}
