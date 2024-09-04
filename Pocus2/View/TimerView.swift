//
//  ContentView.swift
//  Pocus2
//
//  Created by Wojciech Kozioł on 01/09/2024.
//

import SwiftUI

struct TimerView: View {
    @Environment(\.scenePhase) var scenePhase

    @State private var viewModel: TimerViewModel

    init() {
        let notificationService = NotificationService()
        self._viewModel = State(initialValue: TimerViewModel(notificationService: notificationService))
    }

    var body: some View {
        VStack(spacing: 50) {
            CircleTimer(angle: viewModel.angle, text: viewModel.formattedTime)
                .frame(width: 300, height: 300)

            Button {
                viewModel.toggle()
            } label: {
                Image(systemName: viewModel.isRunning ? "pause.fill" : "play.fill")
                    .font(.title)
                    .contentTransition(.symbolEffect(.replace, options: .speed(2)))
            }
        }
        .onChange(of: scenePhase) {
            viewModel.hanglePhaseChange(scenePhase)
        }
        .frame(maxHeight: .infinity)
        .banner(show: $viewModel.isShowingBanner, with: BannerData(title: "Your focus session has ended!", message: "Make sure to get some rest.", emoji: "🎊"))
    }
}

#Preview {
    TimerView()
}
