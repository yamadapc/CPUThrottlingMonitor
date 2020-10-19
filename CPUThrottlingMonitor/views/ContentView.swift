//
//  ContentView.swift
//  CPUThrottlingMonitor
//
//  Created by Pedro Tacla Yamada on 17/10/20.
//  Copyright © 2020 Pedro Tacla Yamada. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var state = CPUThrottlingState()

    var body: some View {
        VStack {
            ZStack {
                GeometryReader { geometry in
                    LineChartView(
                        geometry: geometry,
                        points: self.state.getHistory()
                    )
                }
                HStack {
                    Text("CPU Speed Limit:")
                    Text("\(state.getCurrentValue())%")
                        .bold()
                }.foregroundColor(Color(NSColor.controlTextColor))
            }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView(state: CPUThrottlingState(
                speedLimits: (0..<100).map { _ in .random(in: 75...100) }
            )).frame(width: 200.0, height: 150.0, alignment: .center)
              .previewDisplayName("Light mode")
            .environment(\.colorScheme, .light)

            ContentView(state: CPUThrottlingState(
                speedLimits: (0..<100).map { _ in .random(in: 75...100) }
            )).frame(width: 200.0, height: 150.0, alignment: .center)
              .previewDisplayName("Dark mode")
            .environment(\.colorScheme, .dark)
        }
    }
}
