//
//  LineChartView.swift
//  CPUThrottlingMonitor
//
//  Created by Pedro Tacla Yamada on 19/10/20.
//  Copyright © 2020 Pedro Tacla Yamada. All rights reserved.
//

import SwiftUI

struct LineChartView: View {
    var geometry: GeometryProxy
    var points: [Int]

    fileprivate func drawPath(_ path: inout Path, drawEdges: Bool = false) {
        let width = geometry.size.width - 5
        let lineHeight = geometry.size.height - 10.0
        let total = points.count
        if total == 0 {
            return
        }

        if drawEdges {
            path.move(to: CGPoint(x: 2.5, y: Double(geometry.size.height)))
        }

        for i in 0...total-1 {
            let value = points[i]
            let point = CGPoint(
                x: 2.5 + Double(width) * (Double(i) / Double(total-1)),
                y: Double(lineHeight + 10.0) - Double(lineHeight) * (Double(value) / 100.0)
            )
            if !drawEdges && i == 0 {
                path.move(to: point)
            }
            path.addLine(to: point)
        }

        if drawEdges {
            path.addLine(to: CGPoint(x: 2.5 + Double(width), y: Double(geometry.size.height)))
            path.addLine(to: CGPoint(x: 2.5, y: Double(geometry.size.height)))
            path.closeSubpath()
        }
    }

    var body: some View {
        ZStack {
            Path { path in
                drawPath(&path, drawEdges: true)
            }.fill(
                LinearGradient(
                    gradient: Gradient(
                        colors: [
                            Color.blue.opacity(0.3),
                            Color.blue.opacity(0.1),
                        ]
                    ),
                    startPoint: .top,
                    endPoint: .bottom
            ))
            Path { path in
                drawPath(&path, drawEdges: true)
            }.stroke(lineWidth: 1).fill(Color.blue.opacity(0.9))
        }.background(Rectangle().fill(Color(NSColor.windowBackgroundColor)))
    }
}

struct LineChartView_Previews: PreviewProvider {
    static func randomData() -> [Int] {
        var data: [Int] = []
        for i in 0...100 {
            data.append(60 + Int(10.0 * (1.0 + sin(10.0 * Double(i) / 100.0))))
        }
        return data
    }

    static var previews: some View {
        Group {
            GeometryReader { geometry in
                LineChartView(geometry: geometry, points: randomData())
            }
            .previewDisplayName("Light mode")
            .environment(\.colorScheme, .light)

            GeometryReader { geometry in
                LineChartView(geometry: geometry, points: randomData())
            }
            .previewDisplayName("Dark mode")
            .environment(\.colorScheme, .dark)
        }
    }
}
