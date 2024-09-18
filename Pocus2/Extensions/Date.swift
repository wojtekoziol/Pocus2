//
//  Date.swift
//  Pocus2
//
//  Created by Wojciech Kozioł on 17/09/2024.
//

import Foundation

extension Date {
    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        calendar.component(component, from: self)
    }

    func startOfDay() -> Date {
        Calendar.current.startOfDay(for: self)
    }

    func addDays(_ amount: Int) -> Date {
        self.addingTimeInterval(24 * 60 * 60 * Double(amount))
    }
}
