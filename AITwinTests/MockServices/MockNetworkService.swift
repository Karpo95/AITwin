//
//  MockNetworkService.swift
//  AITwin
//
//  Created by Karpenko Bohdan on 01.06.2025.
//

import Foundation
@testable import AITwin

final class MockNetworkService: NetworkServiceProtocol {
    enum Behavior {
        case success
        case failure(NetworkError)
    }
    
    // Configurable behavior for each endpoint
    var sessionsBehavior: Behavior = .success
    var createSessionBehavior: Behavior = .success
    var messagesBehavior: Behavior = .success
    var sendMessageBehavior: Behavior = .success
    
    // Default results (override in tests if needed)
    var sessionsResult: [Session] = Session.mocks
    var createSessionResult: Session = Session.mock
    var messagesResult: [Message] = Message.mocks
    var sendMessageAssistantResult: Message = Message.mockAssistant
    var sendMessageUserResult: Message = Message.mockUser
    
    func sessions() async throws -> [Session] {
        switch sessionsBehavior {
        case .success:
            return sessionsResult
        case .failure(let error):
            throw error
        }
    }
    
    func createSession(title: String, category: SessionCategory) async throws -> Session {
        switch createSessionBehavior {
        case .success:
            return createSessionResult
        case .failure(let error):
            throw error
        }
    }
    
    func messages(sessionId: String) async throws -> [Message] {
        switch messagesBehavior {
        case .success:
            return messagesResult.filter { $0.sessionId == sessionId }
        case .failure(let error):
            throw error
        }
    }
    
    func sendMessage(sessionId: String, text: String, sender: Message.Sender) async throws -> Message {
        switch sendMessageBehavior {
        case .success:
            return sender == .assistant ? sendMessageAssistantResult : sendMessageUserResult
        case .failure(let error):
            throw error
        }
    }
}
