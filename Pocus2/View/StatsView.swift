//
//  StatsView.swift
//  Pocus2
//
//  Created by Wojciech Kozioł on 17/09/2024.
//

import SwiftUI
import Charts

struct StatsView: View {
    @Bindable var viewModel: StatsViewModel

    var body: some View {
        VStack(spacing: 15) {
            VStack(spacing: 5) {
                Text("Focus Durations")

                Chart {
                    ForEach(viewModel.focusDurationsWeek) { duration in
                        BarMark(
                            x: .value("Date", Date(timeIntervalSince1970: duration.date), unit: .day),
                            y: .value("Duration", duration.value)
                        )
                        .cornerRadius(12)
                    }
                }
                .padding()
                .background(.secondary.opacity(0.1))
                .cornerRadius(12)
            }

            VStack(spacing: 5) {
                Text("Focus Sessions")

                Chart {
                    ForEach(viewModel.focusSessionsWeek) { session in
                        BarMark(
                            x: .value("Date", Date(timeIntervalSince1970: session.date), unit: .day),
                            y: .value("Sessions", session.value)
                        )
                        .cornerRadius(12)
                    }
                }
                .padding()
                .background(.secondary.opacity(0.1))
                .cornerRadius(12)
            }
        }
        .foregroundStyle(.accent)
        .chartXAxis {
            AxisMarks(values: .automatic(desiredCount: 7)) { _ in
                AxisValueLabel(format: .dateTime.weekday(.narrow), centered: true)
            }
        }
        .chartXScale(
            domain: Date.now.addDays(-6).startOfDay()...Date.now.addDays(1).startOfDay(),
            range: .plotDimension(padding: 12)
        )
        .padding()
    }
}

#Preview {
    let viewModel = StatsViewModel()
    let now = Calendar.current.startOfDay(for: .now).timeIntervalSince1970
    let yesterday = Calendar.current.startOfDay(for: .now.addingTimeInterval(-24*60*60*6)).timeIntervalSince1970
    viewModel.focusDurations = [
        .init(value: 3, date: now),
        .init(value: 1, date: yesterday)
    ]
    viewModel.focusSessions = [.init(value: 45, date: now)]

    return StatsView(viewModel: viewModel)
}
