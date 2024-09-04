//
//  TabBarView.swift
//  Pocus2
//
//  Created by Wojciech Kozioł on 04/09/2024.
//

import SwiftUI

struct TabBarView<Content: View>: View {
    @Binding var selection: TabBarItem
    let content: Content

    @State private var tabs = [TabBarItem]()

    init(selection: Binding<TabBarItem>, @ViewBuilder content: () -> Content) {
        self._selection = selection
        self.content = content()
    }

    var body: some View {
        VStack {
            AppBar()

            ZStack(alignment: .bottom) {
                content
                    .safeAreaInset(edge: .bottom) {
                        TabBar(items: tabs, selection: $selection)
                    }
            }
            .onPreferenceChange(TabBarItemPreferenceKey.self) { value in
                self.tabs = value
            }
        }
    }
}

#Preview {
    TabBarView(selection: .constant(.timer)) {
        Color.red
    }
}
