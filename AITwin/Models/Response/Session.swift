//
//  Session.swift
//  AITwin
//
//  Created by Karpenko Bohdan on 31.05.2025.
//

import Foundation

struct Session: Codable, Identifiable {
    let id: String
    let date: String
    let title: String
    let category: SessionCategory
}

enum SessionCategory: String, Codable, CaseIterable {
    case career
    case emotions
    case relationships
    case health
    case productivity
    case selfDiscovery
    case stress
    case habits
    case goals
    case other
}

extension SessionCategory {
    var displayName: String {
        switch self {
        case .career: return "Career"
        case .emotions: return "Emotions"
        case .relationships: return "Relationships"
        case .health: return "Health"
        case .productivity: return "Productivity"
        case .selfDiscovery: return "Self Discovery"
        case .stress: return "Stress"
        case .habits: return "Habits"
        case .goals: return "Goals"
        case .other: return "Other"
        }
    }
}
