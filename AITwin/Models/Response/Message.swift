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
        return date?.toLocalDateString(format: .full) ?? timestamp
    }
}

//MARK: - Mock

extension Message {
    static let mock = Message(
        id: "mock-message-1",
        sessionId: "mock-session-1",
        text: "This is a mock message.",
        sender: .user,
        timestamp: "2025-06-01T10:00:00Z"
    )
    
    static let mocks: [Message] = [
        Message(
            id: "mock-message-1",
            sessionId: "mock-session-1",
            text: "Hello from mock!",
            sender: .assistant,
            timestamp: "2025-06-01T09:00:00Z"
        ),
        Message(
            id: "mock-message-2",
            sessionId: "mock-session-1",
            text: "How can I help you today?",
            sender: .assistant,
            timestamp: "2025-06-01T09:01:00Z"
        ),
        Message(
            id: "mock-message-3",
            sessionId: "mock-session-1",
            text: "User response goes here.",
            sender: .user,
            timestamp: "2025-06-01T09:02:00Z"
        )
    ]
}

