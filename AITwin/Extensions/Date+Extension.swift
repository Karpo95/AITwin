//
//  Date+Extension.swift
//  AITwin
//
//  Created by Karpenko Bohdan on 31.05.2025.
//

import Foundation

import Foundation

extension Date {
    /// Ініціалізує `Date` з ISO 8601-рядка, застосовуючи вказані `options`.
    ///
    /// - Parameters:
    ///   - isoString: рядок формату ISO 8601 (наприклад, "2025-05-31T14:23:00Z" або "2025-05-31T14:23:00.123+0200").
    ///   - options: набір опцій `ISO8601DateFormatter.Options`, що визначають стиль розбору (наприклад, з дробовими секундами, з часовим поясом тощо).
    ///
    /// Якщо рядок не відповідає вказаним `options`, ініціалізатор повертає `nil`.
    init?(iso8601 isoString: String, options: ISO8601DateFormatter.Options = [.withInternetDateTime]) {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = options
        
        guard let date = formatter.date(from: isoString) else {
            return nil
        }
        self = date
    }
    
    /// Повертає ISO 8601-рядок з цієї `Date`, використовуючи вказані `options`.
    ///
    /// - Parameter options: набір опцій `ISO8601DateFormatter.Options`, що визначають стиль форматування (наприклад, з дробовими секундами, з часовим поясом тощо).
    /// - Returns: відформатований ISO 8601-рядок.
    func toISO8601String(options: ISO8601DateFormatter.Options) -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = options
        return formatter.string(from: self)
    }
}
