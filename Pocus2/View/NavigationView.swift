//
//  NavigationWrapper.swift
//  Pocus2
//
//  Created by Wojciech Kozioł on 03/09/2024.
//

import SwiftUI

struct NavigationView: View {
    @State private var selection: TabBarItem = .timer
    @State private var statsViewModel = StatsViewModel()

    var body: some View {
        NavigationStack {
            TabBarView(selection: $selection) {
                TimerView(statsViewModel: statsViewModel)
                    .tabBarItem(tab: .timer, selection: $selection)

                StatsView(viewModel: statsViewModel)
                    .tabBarItem(tab: .stats, selection: $selection)
            }
        }
    }
}

#Preview {
    NavigationView()
}
