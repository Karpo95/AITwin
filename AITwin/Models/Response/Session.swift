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

extension Session: Equatable, Hashable {}


extension Session {
    var formattedDateString: String {
        let date = Date(iso8601: date)
        return date?.toLocalDateString(format: .full) ?? self.date
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

extension Array where Element == Session {
    func sortedByDate() -> [Session] {
        sorted { $0.date > $1.date }
    }
}

// MARK: - Mock

extension Session {
    static let mock = Session(
        id: "s0",
        date: "2025-06-01T12:00:00Z",
        title: "Mock Session Title",
        category: .anxiety
    )
    
    static let mocks: [Session] = [
        Session(
            id: "s1",
            date: "2025-06-01T10:00:00Z",
            title: "Mock Session One",
            category: .anxiety
        ),
        Session(
            id: "s2",
            date: "2024-12-15T14:30:00Z",
            title: "Mock Session Two",
            category: .career
        ),
        Session(
            id: "s3",
            date: "2023-07-20T09:15:00Z",
            title: "Mock Session Three",
            category: .conflictResolution
        )
    ]
}
