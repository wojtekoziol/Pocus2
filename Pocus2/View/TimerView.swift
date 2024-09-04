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
    @State private var showingResetAlert = false

    init() {
        let notificationService = NotificationService()
        self._viewModel = State(initialValue: TimerViewModel(notificationService: notificationService))
    }

    var body: some View {
        VStack(spacing: 50) {
            Text(viewModel.quote)
                .font(.subheadline)
                .foregroundStyle(.accent)

            CircleTimer(angle: viewModel.angle, text: viewModel.formattedTime, unit: viewModel.formattedUnit)
                .frame(width: 300, height: 300)

            Button(action: {}) {
                Image(systemName: viewModel.isRunning ? "pause.fill" : "play.fill")
                    .font(.title)
                    .contentTransition(.symbolEffect(.replace, options: .speed(2)))
            }
            .simultaneousGesture(LongPressGesture().onEnded { _ in
                showingResetAlert = true
            })
            .simultaneousGesture(TapGesture(count: 2).onEnded{ _ in
                viewModel.skip()
            })
            .simultaneousGesture(TapGesture().onEnded { _ in
                viewModel.toggle()
            })
        }
        .onChange(of: scenePhase) {
            viewModel.hanglePhaseChange(scenePhase)
        }
        .frame(maxHeight: .infinity)
        .banner(show: $viewModel.isShowingBanner, with: viewModel.bannerData)
        .onAppear(perform: viewModel.updateDurations)
        .alert("You're about to reset a timer!", isPresented: $showingResetAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Reset", role: .destructive, action: viewModel.reset)
        } message: {
            Text("This action cannot be undone.")
        }
    }
}

#Preview {
    TimerView()
}
