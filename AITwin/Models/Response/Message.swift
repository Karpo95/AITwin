//
//  Message.swift
//  AITwin
//
//  Created by Karpenko Bohdan on 31.05.2025.
//

import Foundation

struct Message: Codable, Identifiable, Hashable {
    let id: String
    let sessionId: String
    let text: String
    let sender: Sender
    let timestamp: String
    
    enum Sender: String, Codable {
        case user, assistant
    }
}


extension Message {
    var formattedDate: String {
        let date = Date(iso8601: timestamp)
        return date?.toISO8601String(options: [.withFullDate]) ?? timestamp
    }
}
