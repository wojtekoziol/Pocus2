//
//  TimerViewModel.swift
//  Pocus2
//
//  Created by Wojciech Kozioł on 01/09/2024.
//

import SwiftUI

@Observable
class TimerViewModel {
    let notificationService: NotificationService

    private var timer: Timer?
    private(set) var elapsed = 0
    private(set) var maxTime = 5
    private(set) var isRunning = false
    var isShowingBanner = false

    private let notificationCenter = UNUserNotificationCenter.current()
    private let endDateKey = "endDate"

    init(notificationService: NotificationService) {
        self.notificationService = notificationService        
    }

    private func start() {
        notificationService.scheduleNotification(for: TimeInterval(timeRemaining), title: "🎊 Your focus session has ended!", body: "Make sure to get some rest.")

        isRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            guard let self else { return }

            if elapsed >= maxTime {
                isShowingBanner = true
                reset()
            } else {
                elapsed += 1
            }
        }
    }

    private func stop() {
        timer?.invalidate()
        isRunning = false

        notificationService.cancelAllNotifications()
    }

    func reset() {
        stop()
        elapsed = 0
        // TODO: Set max time
    }

    func toggle() {
        if isRunning {
            stop()
        } else {
            start()
        }
    }


    func hanglePhaseChange(_ newPhase: ScenePhase) {
        switch newPhase {
        case .background:
            guard isRunning else { return }

            timer?.invalidate()
            isRunning = false

            let endDate = Date.now.addingTimeInterval(TimeInterval(timeRemaining))
            UserDefaults.standard.set(endDate, forKey: endDateKey)

        case .active:
            let endDate = UserDefaults.standard.object(forKey: endDateKey) as? Date
            guard let endDate else { return }

            if endDate > .now {
                elapsed = maxTime - Int(endDate.timeIntervalSince(.now))
                start()
            } else {
                reset()
            }

            UserDefaults.standard.removeObject(forKey: endDateKey)

        case .inactive:
            break
        @unknown default:
            fatalError("Unknown scene phase")
        }
    }

    var angle: Double {
        if isRunning || elapsed != 0 {
            return 360 - Double(elapsed) / Double(maxTime) * 360
        }
        return 0
    }

    var formattedTime: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .abbreviated

        let formattedString = formatter.string(from: TimeInterval(timeRemaining)) ?? ""
        return formattedString
    }

    private var timeRemaining: Int {
        maxTime - elapsed
    }
}
