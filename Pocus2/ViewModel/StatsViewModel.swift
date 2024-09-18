//
//  StatsViewModel.swift
//  Pocus2
//
//  Created by Wojciech Kozioł on 17/09/2024.
//

import Foundation

@Observable
class StatsViewModel: Codable {
    private let fileName = "stats.json"

    var focusDurations: [Statistic]
    var focusSessions: [Statistic]

    private enum CodingKeys: String, CodingKey {
        case _focusDurations = "focusDurations"
        case _focusSessions = "focusSessions"
    }

    init() {
        do {
            let url = URL.documentsDirectory.appending(path: fileName)
            let data = try Data(contentsOf: url)
            let decoded = try JSONDecoder().decode(StatsViewModel.self, from: data)

            focusDurations = decoded.focusDurations
            focusSessions = decoded.focusSessions
        } catch {
            focusDurations = []
            focusSessions = []
        }
    }

    func addMinutes(_ minutes: Int) {
        var current = focusDurations.first(where: { $0.date == Calendar.current.startOfDay(for: .now).timeIntervalSince1970 }) ?? .init(value: 0, date: Calendar.current.startOfDay(for: .now).timeIntervalSince1970)

        current.add(minutes)

        focusDurations.removeAll(where: { $0.id == current.id})
        focusDurations.append(current)

        save()
    }

    func addSession(_ count: Int = 1) {
        var current = focusSessions.first(where: { $0.date == Calendar.current.startOfDay(for: .now).timeIntervalSince1970 }) ?? .init(value: 0, date: Calendar.current.startOfDay(for: .now).timeIntervalSince1970)

        current.add(count)

        focusSessions.removeAll(where: { $0.id == current.id})
        focusSessions.append(current)

        save()
    }

    private func save() {
        do {
            let data = try JSONEncoder().encode(self)
            let url = URL.documentsDirectory.appending(path: fileName)
            try data.write(to: url, options: [.atomic, .completeFileProtection])
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }

    var focusDurationsWeek: [Statistic] {
        focusDurations.filter { statistic in
            Calendar.current.dateComponents([.day], from: Date(timeIntervalSince1970: statistic.date), to: .now).day! < 7
        }
    }

    var focusSessionsWeek: [Statistic] {
        focusSessions.filter { statistic in
            Calendar.current.dateComponents([.day], from: Date(timeIntervalSince1970: statistic.date), to: .now).day! < 7
        }
    }
}
