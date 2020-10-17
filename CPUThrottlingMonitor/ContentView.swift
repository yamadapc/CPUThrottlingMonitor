//
//  ContentView.swift
//  CPUThrottlingMonitor
//
//  Created by Pedro Tacla Yamada on 17/10/20.
//  Copyright © 2020 Pedro Tacla Yamada. All rights reserved.
//

import SwiftUI

struct LineChartView: View {
    var geometry: GeometryProxy
    var history: [Int]

    var body: some View {
        Path { path in
            let width = geometry.size.width
            let lineHeight = geometry.size.height - 10.0
            let total = history.count
            if total == 0 {
                return
            }

            for i in 0...total-1 {
                let value = history[i]
                let point = CGPoint(
                    x: Double(width) * (Double(i) / Double(total-1)),
                    y: Double(lineHeight + 10.0) - Double(lineHeight) * (Double(value) / 100.0)
                )
                if i == 0 {
                    path.move(to: point)
                }
                path.addLine(to: point)
                path.move(to: point)
            }
        }.stroke(lineWidth: 3.0).fill(Color.blue)
    }
}

struct ContentView: View {
    @ObservedObject var state = CPUThrottlingState()

    var body: some View {
        VStack {
            VStack {
                GeometryReader { geometry in
                    LineChartView(
                        geometry: geometry,
                        history: self.state.getHistory()
                    )
                }.background(Rectangle().foregroundColor(Color(NSColor.controlBackgroundColor)))
                    .border(SeparatorShapeStyle(), width: 2.0)
            }.padding(10.0)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            HStack {
                Button(action: {
                    NSApp.terminate(self)
                }, label: { Text("Quit") }).frame(alignment: .topTrailing)
            }.padding(10).frame(maxWidth: .infinity, maxHeight: 30, alignment: .trailing)
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(state: CPUThrottlingState(speedLimits: [
            100,
            100,
            88,
            90,
            90,
            100,
            99,
            100,
            89,
            50,
            75,
            75,
            80,
        ]))
    }
}
