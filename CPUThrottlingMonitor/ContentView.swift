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

    fileprivate func drawPath(_ path: inout Path) {
        let width = geometry.size.width - 5
        let lineHeight = geometry.size.height - 10.0
        let total = history.count
        if total == 0 {
            return
        }

        path.move(to: CGPoint(x: 2.5, y: Double(geometry.size.height)))
        for i in 0...total-1 {
            let value = history[i]
            let point = CGPoint(
                x: 2.5 + Double(width) * (Double(i) / Double(total-1)),
                y: Double(lineHeight + 10.0) - Double(lineHeight) * (Double(value) / 100.0)
            )
            path.addLine(to: point)
            // path.move(to: point)
        }
        path.addLine(to: CGPoint(x: 2.5 + Double(width), y: Double(geometry.size.height)))
        path.addLine(to: CGPoint(x: 2.5, y: Double(geometry.size.height)))
        path.closeSubpath()
    }

    var body: some View {
        ZStack {
            Path { path in
                drawPath(&path)
            }.fill(
                LinearGradient(
                    gradient: Gradient(
                        colors: [
                            Color.blue.opacity(0.3),
                            Color.blue.opacity(0.0),
                        ]
                    ),
                    startPoint: .top,
                    endPoint: .bottom
            ))
            Path { path in
                drawPath(&path)
            }.stroke(lineWidth: 1).fill(Color.blue.opacity(0.9))
        }
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
        ContentView(state: CPUThrottlingState(
            speedLimits: (0..<100).map { _ in .random(in: 75...100) }
        ))
    }
}
