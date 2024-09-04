//
//  TabBarItem.swift
//  Pocus2
//
//  Created by Wojciech Kozioł on 04/09/2024.
//

import Foundation
import SwiftUI

enum TabBarItem: Hashable {
    case timer, stats

    var iconName: String {
        switch self {
        case .timer:
            "timer"
        case .stats:
            "chart.bar"
        }
    }
}
