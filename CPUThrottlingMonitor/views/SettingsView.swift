//
//  SettingsView.swift
//  CPUThrottlingMonitor
//
//  Created by Pedro Tacla Yamada on 20/10/20.
//  Copyright © 2020 Pedro Tacla Yamada. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    var analyticsService: AnalyticsService

    @State private var isOn: Bool = false

    init(analyticsService: AnalyticsService) {
        self.analyticsService = analyticsService
    }

    var body: some View {
        GeometryReader { geometry in
            VStack {
                Text("Settings")
                    .bold()
                Divider()

                VStack {
                    Toggle(isOn: Binding(
                        get: { self.isOn },
                        set: { value in
                            self.analyticsService.setIsEnabled(value)
                            self.isOn = value
                        }
                    ), label: {
                        Text("Enable anonymous metrics")
                    }).frame(maxWidth: .infinity, alignment: .leading)
                }.frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(10.0)
            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .topLeading)
        }
        .onAppear(perform: {
            self.isOn = self.analyticsService.getIsEnabled()
        })
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(
            analyticsService: AnalyticsService(
                options: AnalyticsServiceOptions(trackingId: "", clientId: "")
            )
        )
            .frame(width: 200.0, height: 100.0, alignment: .center)
    }
}
