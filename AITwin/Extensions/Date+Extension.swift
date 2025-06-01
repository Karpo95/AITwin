//
//  Date+Extension.swift
//  AITwin
//
//  Created by Karpenko Bohdan on 31.05.2025.
//

import Foundation

extension Date {
    init?(iso8601 isoString: String, options: ISO8601DateFormatter.Options = [.withInternetDateTime]) {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = options
        formatter.timeZone = .current
        
        guard let date = formatter.date(from: isoString) else {
            return nil
        }
        self = date
    }
    
    func toISO8601String(options: ISO8601DateFormatter.Options = [.withInternetDateTime]) -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = options
        formatter.timeZone = .current
        return formatter.string(from: self)
    }
    
    func toLocalDateString(format: Format) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format.rawValue
        formatter.timeZone = .current
        return formatter.string(from: self)
    }
    
    enum Format: String {
        case full = "yyyy-MM-dd HH:mm"
    }
}
