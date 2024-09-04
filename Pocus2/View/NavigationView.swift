//
//  NavigationWrapper.swift
//  Pocus2
//
//  Created by Wojciech Kozioł on 03/09/2024.
//

import SwiftUI

struct NavigationView: View {
    @State private var selection: TabBarItem = .timer

    var body: some View {
        NavigationStack {
            TabBarView(selection: $selection) {
                TimerView()
                    .tabBarItem(tab: .timer, selection: $selection)
            }
        }
    }
}

#Preview {
    NavigationView()
}
