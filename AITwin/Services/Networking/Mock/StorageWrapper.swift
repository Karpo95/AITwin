//
//  StorageWrapper.swift
//  AITwin
//
//  Created by Karpenko Bohdan on 31.05.2025.
//

import Foundation

struct StorageWrapper: Codable {
    let sessions: [Session]
    let messages: [String: [Message]]
}
