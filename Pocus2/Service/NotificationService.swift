//
//  NotificationService.swift
//  Pocus2
//
//  Created by Wojciech Kozioł on 01/09/2024.
//

import Foundation
import UserNotifications

class NotificationService {
    private let notificationCenter = UNUserNotificationCenter.current()

    func scheduleNotification(for timeInterval: TimeInterval, title: String, body: String) {
        requestPermissions { [weak self] success in
            guard success else { return }

            let content = UNMutableNotificationContent()
            content.title = title
            content.body = body

            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

            self?.notificationCenter.add(request)
        }
    }

    func cancelAllNotifications() {
        notificationCenter.removeAllPendingNotificationRequests()
    }

    private func requestPermissions(_ completion: @escaping (Bool) -> Void) {
        notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                completion(success)
            } else if let error {
                print(error.localizedDescription)
                completion(false)
            }
        }
    }
}
