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

                ZStack {
                    Chart {
                        ForEach(viewModel.focusDurationsWeek) { duration in
                            BarMark(
                                x: .value("Date", Date(timeIntervalSince1970: duration.date), unit: .day),
                                y: .value("Duration", duration.value)
                            )
                            .clipShape(Capsule())
                            .annotation(position: .top, alignment: .center) {
                                Text("\(duration.value) min")
                                    .font(.caption2)
                                    .foregroundStyle(.accent)
                            }
                        }
                    }
                    .padding()
                    .background(.secondary.opacity(0.2))
                    .cornerRadius(12)

                    if viewModel.focusDurationsWeek.isEmpty {
                        Text("No data to show")
                            .font(.caption)
                    }
                }
            }

            VStack(spacing: 5) {
                Text("Focus Sessions")

                ZStack {
                    Chart {
                        ForEach(viewModel.focusSessionsWeek) { session in
                            BarMark(
                                x: .value("Date", Date(timeIntervalSince1970: session.date), unit: .day),
                                y: .value("Sessions", session.value)
                            )
                            .clipShape(Capsule())
                            .annotation(position: .top, alignment: .center) {
                                Text("\(session.value)")
                                    .font(.caption2)
                                    .foregroundStyle(.accent)
                            }
                        }
                    }
                    .padding()
                    .background(.secondary.opacity(0.2))
                    .cornerRadius(12)

                    if viewModel.focusSessionsWeek.isEmpty {
                        Text("No data to show")
                            .font(.caption)
                    }
                }
            }
        }
        .foregroundStyle(.accent)
        .chartXAxis {
            AxisMarks(values: .automatic(desiredCount: 7)) { _ in
                AxisValueLabel(format: .dateTime.weekday(.narrow), centered: true)
                    .foregroundStyle(.accent)
            }
        }
        .chartYAxis(.hidden)
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
    viewModel.focusSessions = [
        .init(value: 3, date: now),
        .init(value: 1, date: yesterday)
    ]
    viewModel.focusDurations = [.init(value: 45, date: now)]

    return StatsView(viewModel: viewModel)
}
