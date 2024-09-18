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
    let statsViewModel: StatsViewModel

    private var focusDuration = 25 * 60
    private var shortBreakDuration = 5 * 60
    private var longBreakDuration = 15 * 60
    private var maxSessionCount = 4

    private var timer: Timer?

    // Elapsed seconds
    private var elapsed = 0

    private(set) var isRunning = false
    private var isBreak = false
    private var sessionCount = 0
    var isShowingBanner = false
    private(set) var bannerData: BannerData = .afterFocus

    init(notificationService: NotificationService, statsViewModel: StatsViewModel) {
        self.notificationService = notificationService
        self.statsViewModel = statsViewModel
    }

    private func start(withNotification: Bool = true) {
        if withNotification && isBreak {
            notificationService.scheduleNotification(for: TimeInterval(timeRemaining), title: "⚡️ It's time to focus!", body: "Give it all you've got.")
        } else if withNotification {
            notificationService.scheduleNotification(for: TimeInterval(timeRemaining), title: "🎊 Your focus session has ended!", body: "Make sure to get some rest.")
        }

        isRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            guard let self else {
                timer.invalidate()
                return
            }

            if elapsed >= currentDuration || !isRunning {
                handleTimerEnd(saveStats: true)
            } else {
                elapsed += 1
            }
        }
    }

    private func handleTimerEnd(withBanner: Bool = true, saveStats: Bool) {
        if !isBreak && saveStats {
            statsViewModel.addMinutes(elapsed / 60)
            statsViewModel.addSession()
        }

        if withBanner {
            bannerData = isBreak ? .afterBreak : .afterFocus
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

        updateDurations()
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
        updateDurations()
    }

    func skip() {
        handleTimerEnd(withBanner: false, saveStats: false)

        bannerData = .skip
        isShowingBanner = true
    }

    func toggle() {
        isRunning ? stop() : start()
    }

    func updateDurations() {
        guard !isRunning && elapsed == 0 else { return }

        focusDuration = (UserDefaults.standard.value(forKey: "focusDuration") as? Int ?? 25) * 60
        shortBreakDuration = (UserDefaults.standard.value(forKey: "shortBreakDuration") as? Int ?? 5) * 60
        longBreakDuration = (UserDefaults.standard.value(forKey: "longBreakDuration") as? Int ?? 15) * 60
        maxSessionCount = UserDefaults.standard.value(forKey: "maxSessionCount") as? Int ?? 4
    }

    func hanglePhaseChange(_ newPhase: ScenePhase) {
        switch newPhase {
        case .background:
            guard isRunning else { return }

            timer?.invalidate()
            isRunning = false

            let endDate = Date.now.addingTimeInterval(TimeInterval(timeRemaining))
            UserDefaults.standard.set(endDate, forKey: "endDate")
            UserDefaults.standard.set(isBreak, forKey: "isBreak")
            UserDefaults.standard.set(sessionCount, forKey: "sessionCount")

            elapsed = 0

        case .active:
            let endDate = UserDefaults.standard.object(forKey: "endDate") as? Date
            guard let endDate else { return }
            self.isBreak = UserDefaults.standard.bool(forKey: "isBreak")
            self.sessionCount = UserDefaults.standard.integer(forKey: "sessionCount")

            if endDate > .now {
                elapsed = currentDuration - Int(endDate.timeIntervalSince(.now))
            } else {
                elapsed = currentDuration
                handleTimerEnd(withBanner: false, saveStats: true)
            }

            UserDefaults.standard.removeObject(forKey: "endDate")

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

        let adjustment = timeRemaining >= 60 ? 30 : 0

        let formattedString = formatter.string(from: TimeInterval(timeRemaining + adjustment)) ?? ""
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
