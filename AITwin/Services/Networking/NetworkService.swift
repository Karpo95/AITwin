//
//  NetworkService.swift
//  AITwin
//
//  Created by Karpenko Bohdan on 31.05.2025.
//

import Foundation

protocol NetworkServiceProtocol {
    func sessions() async throws -> [Session]
    func createSession(title: String, category: SessionCategory) async throws -> Session
    func messages(sessionId: String) async throws -> [Message]
    func sendMessage(sessionId: String, text: String, sender: Message.Sender) async throws -> Message
}

final class NetworkService: BaseNetworkService<Endpoint>, NetworkServiceProtocol {
    
    private let mockSession: URLSession = {
        let config = URLSessionConfiguration.default
        config.protocolClasses = [MockURLProtocol.self]
        let mockSession = URLSession(configuration: config)
        return mockSession
    }()
        
    func sessions() async throws -> [Session] {
        try await fetchData(api: .sessions, urlSession: mockSession)
    }
    
    func createSession(title: String, category: SessionCategory) async throws -> Session {
        let body = SessionHTTPBody(title: title, category: category)
        return try await fetchData(api: .createSession(body: body), urlSession: mockSession)
    }
    
    func messages(sessionId: String) async throws -> [Message] {
        return try await fetchData(api: .messages(sessionId: sessionId), urlSession: mockSession)
    }
    
    func sendMessage(sessionId: String, text: String, sender: Message.Sender) async throws -> Message {
        let body = MessageHTTPBody(text: text, sender: sender)
        return try await fetchData(api: .sendMessage(sessionId: sessionId, body: body), urlSession: mockSession)
    }
}
