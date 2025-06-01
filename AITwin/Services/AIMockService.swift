//
//  AIMockService.swift
//  AITwin
//
//  Created by Karpenko Bohdan on 01.06.2025.
//

import Foundation

// MARK: - Protocol

protocol AIServiceProtocol {
    func sendMessage(_ message: String) async throws -> String
}

// MARK: - Mock Service

final class MockAIService: AIServiceProtocol {
    private let cannedResponses: [String] = [
        "You're welcome! Always happy to help 🙌",
        "I understand how you feel. Everything will be okay ❤️",
        "Stay strong! Every day is a new opportunity 🌟",
        "Interesting question! Let's think it through together 🤔",
        "I'm here if you need advice or just want to chat 😊"
    ]
    
    private let defaultResponse = "I'm not sure I understood correctly… but I'm here to support you! 🤗"
    private let artificialDelay: UInt64 = 500 * 1_000_000
    
    func sendMessage(_ message: String) async throws -> String {
        try await Task.sleep(nanoseconds: artificialDelay)
        let lowercased = message.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        
        if lowercased.contains("thank") || lowercased.contains("thanks") {
            return cannedResponses[0]
        }
        
        if lowercased.contains("sad") || lowercased.contains("down") {
            return cannedResponses[1]
        }
        
        if lowercased.contains("inspire") || lowercased.contains("motivate") {
            return cannedResponses[2]
        }
        
        if lowercased.contains("?") {
            return cannedResponses[3]
        }
        
        return cannedResponses.randomElement() ?? cannedResponses[0]
    }
}
