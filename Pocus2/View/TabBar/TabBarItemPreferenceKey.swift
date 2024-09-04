//
//  TabBarItemPreferenceKey.swift
//  Pocus2
//
//  Created by Wojciech Kozioł on 04/09/2024.
//

import Foundation
import SwiftUI

struct TabBarItemPreferenceKey: PreferenceKey {
    static var defaultValue = [TabBarItem]()

    static func reduce(value: inout Value, nextValue: () -> Value) {
        value += nextValue()
    }
}

struct TabBarItemModifier: ViewModifier {
    let tab: TabBarItem
    @Binding var selection: TabBarItem

    func body(content: Content) -> some View {
        content
            .opacity(tab == selection ? 1.0 : 0.0)
            .preference(key: TabBarItemPreferenceKey.self, value: [tab])
    }
}

extension View {
    func tabBarItem(tab: TabBarItem, selection: Binding<TabBarItem>) -> some View {
        modifier(TabBarItemModifier(tab: tab, selection: selection))
    }
}
