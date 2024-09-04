//
//  CricleTimer.swift
//  Pocus2
//
//  Created by Wojciech Kozioł on 01/09/2024.
//

import SwiftUI

struct CircleTimer: View {
    var angle: Double
    var text: String?
    var unit: String?

    var body: some View {
        ZStack {
            Circle()
                .stroke(.accent.opacity(0.2), lineWidth: 10)

            Arc(startAngle: 0, endAngle: angle, clockwise: true)
                .stroke(.accent, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                .animation(.linear(duration: 1), value: angle)

            if let text {
                VStack {
                    Text(text)
                        .font(.system(size: 48))
                        .fontWeight(.light)

                    if let unit {
                        Text(unit)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
    }
}

#Preview {
    CircleTimer(angle: 220, text: "40s")
}
