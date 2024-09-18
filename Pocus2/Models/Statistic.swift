//
//  Statistic.swift
//  Pocus2
//
//  Created by Wojciech Kozioł on 18/09/2024.
//

import Foundation

struct Statistic: Codable, Identifiable {
    let id = UUID()
    var value: Int
    var date: TimeInterval

    private enum CodingKeys: String, CodingKey {
        case value, date
    }

    mutating func add(_ newValue: Int) {
        self.value += newValue
    }
}
