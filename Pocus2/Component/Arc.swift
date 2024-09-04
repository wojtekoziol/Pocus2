//
//  Arc.swift
//  Pocus2
//
//  Created by Wojciech Kozioł on 01/09/2024.
//

import SwiftUI

struct Arc: Shape {
    let startAngle: Double
    var endAngle: Double
    let clockwise: Bool

    var animatableData: Double {
        get { endAngle }
        set { endAngle = newValue }
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addArc(center: CGPoint(x: rect.midX, y: rect.midY), radius: rect.width / 2, startAngle: .degrees(startAngle - 90), endAngle: .degrees(endAngle - 90), clockwise: !clockwise)
        return path
    }
}
