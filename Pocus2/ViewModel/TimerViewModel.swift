//
//  TimerViewModel.swift
//  Pocus2
//
//  Created by Wojciech Kozioł on 01/09/2024.
//

import SwiftUI

@Observable
class TimerViewModel {
    enum SessionType {
        case focus, longBreak, shortBreak
    }

    let notificationService: NotificationService

    private let focusDuration = 25 * 60
    private let shortBreakDuration = 5 * 60
    private let longBreakDuration = 15 * 60
    private let maxSessionCount = 4

    private var timer: Timer?
    private var elapsed = 0
    private(set) var isRunning = false
    private var isBreak = false
    private var sessionCount = 0
    var isShowingBanner = false

    private let endDateKey = "endDate"

    init(notificationService: NotificationService) {
        self.notificationService = notificationService        
    }

    private func start() {
        if isBreak {
            notificationService.scheduleNotification(for: TimeInterval(timeRemaining), title: "⚡️ It's time to focus!", body: "Give it all you've got.")
        } else {
            notificationService.scheduleNotification(for: TimeInterval(timeRemaining), title: "🎊 Your focus session has ended!", body: "Make sure to get some rest.")
        }

        isRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            guard let self else { return }

            if elapsed >= currentDuration || !isRunning {
                handleTimerEnd()
            } else {
                elapsed += 1
            }
        }
    }

    private func handleTimerEnd(withBanner: Bool = true) {
        if withBanner {
            isShowingBanner = true
        }

        stop()

        elapsed = 0

        if !isBreak {
            sessionCount += 1
        } else if isBreak && sessionCount >= maxSessionCount {
            sessionCount = 0
        }

        isBreak.toggle()
    }

    private func stop() {
        timer?.invalidate()
        isRunning = false

        notificationService.cancelAllNotifications()
    }

    func reset() {
        stop()
        elapsed = 0
        sessionCount = 0
        isBreak = false
    }

    func skip() {
        handleTimerEnd(withBanner: false)
    }

    func toggle() {
        isRunning ? stop() : start()
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
                elapsed = currentDuration - Int(endDate.timeIntervalSince(.now))
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
            return 360 - Double(elapsed) / Double(currentDuration) * 360
        }
        return 0
    }

    var formattedTime: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = timeRemaining < 60 ? [.second] : [.minute]

        let formattedString = formatter.string(from: TimeInterval(timeRemaining)) ?? ""
        return formattedString
    }

    var formattedUnit: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = timeRemaining < 60 ? [.second] : [.minute]
        formatter.unitsStyle = .spellOut

        let formattedString = formatter.string(from: TimeInterval(timeRemaining)) ?? ""
        return formattedString.components(separatedBy: " ").last ?? ""
    }

    private var currentDuration: Int {
        switch sessionType {
        case .focus:
            focusDuration
        case .longBreak:
            longBreakDuration
        case .shortBreak:
            shortBreakDuration
        }
    }

    private var timeRemaining: Int {
        currentDuration - elapsed
    }

    var quote: String {
        switch sessionType {
        case .focus:
            "Focus Session"
        case .longBreak:
            "Long Break Session"
        case .shortBreak:
            "Short Break Session"
        }
    }

    private var sessionType: SessionType {
        if isBreak && sessionCount >= maxSessionCount {
            return .longBreak
        } else if isBreak {
            return .shortBreak
        }

        return .focus
    }
}
