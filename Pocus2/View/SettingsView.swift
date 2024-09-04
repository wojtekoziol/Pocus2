//
//  SettingsView.swift
//  Pocus2
//
//  Created by Wojciech Kozioł on 04/09/2024.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("focusDuration") private var focusDuration = 25
    @AppStorage("shortBreakDuration") private var shortBreakDuration = 5
    @AppStorage("longBreakDuration") private var longBreakDuration = 15
    @AppStorage("maxSessionCount") private var maxSessionCount = 4

    var body: some View {
        Form {
            Section("Focus duration") {
                Stepper("\(focusDuration) min", value: $focusDuration, in: 5...(3 * 60), step: 5)
            }

            Section("Short break duration") {
                Stepper("\(shortBreakDuration) min", value: $shortBreakDuration, in: 1...30)
            }

            Section("Long break duration") {
                Stepper("\(longBreakDuration) min", value: $longBreakDuration, in: 5...60, step: 5)
            }

            Section("Session cycles") {
                Stepper("^[\(maxSessionCount) sessions](inflect: true)", value: $maxSessionCount, in: 1...10)
            }
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
}
