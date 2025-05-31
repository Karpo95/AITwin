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
    case mindfulness
    case confidence
    case motivation
    case anxiety
    case communication
    case decisionMaking
    case burnout
    case timeManagement
    case conflictResolution
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
        case .mindfulness: return "Mindfulness"
        case .confidence: return "Confidence"
        case .motivation: return "Motivation"
        case .anxiety: return "Anxiety"
        case .communication: return "Communication"
        case .decisionMaking: return "Decision Making"
        case .burnout: return "Burnout"
        case .timeManagement: return "Time Management"
        case .conflictResolution: return "Conflict Resolution"
        case .other: return "Other"
        }
    }
}


extension Session {
    var formattedDateString: String {
        let date = Date(iso8601: date)
        return date?.toISO8601String(options: [.withFullDate]) ?? "Error Date"
    }
}

extension SessionCategory: FlexibleWrapGridItemProtocol {
    var id: String {
        rawValue
    }
    
    var gridItemText: String {
        displayName
    }
}
