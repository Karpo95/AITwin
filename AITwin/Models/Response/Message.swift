//
//  Message.swift
//  AITwin
//
//  Created by Karpenko Bohdan on 31.05.2025.
//

import Foundation

struct Message: Codable, Identifiable {
    let id: String
    let sessionId: String
    let text: String
    let sender: Sender
    let timestamp: String
    
    enum Sender: String, Codable {
        case user, assistant
    }
}
