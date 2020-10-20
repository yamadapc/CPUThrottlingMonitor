//
//  SettingsView.swift
//  CPUThrottlingMonitor
//
//  Created by Pedro Tacla Yamada on 20/10/20.
//  Copyright © 2020 Pedro Tacla Yamada. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    @State private var isOn = !UserDefaults.standard.bool(forKey: "disableAnalytics")

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
                            UserDefaults.standard.setValue(!value, forKey: "disableAnalytics")
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
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .frame(width: 200.0, height: 100.0, alignment: .center)
    }
}
