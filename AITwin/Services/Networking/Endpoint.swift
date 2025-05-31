//
//  Endpoint.swift
//  AITwin
//
//  Created by Karpenko Bohdan on 31.05.2025.
//

import Foundation

enum Endpoint {
    case sessions
    case createSession(body: SessionHTTTPBody)
    case messages(sessionId: String)
    case sendMessage(sessionId: String, body: MessageHTTPBody)
}

extension Endpoint: TargetType {
    var body: Data? {
        switch self {
        case .sessions:
            return nil
        case .createSession(let session):
            return try? session.toData()
        case .messages:
            return nil
        case .sendMessage(_, let body):
            return try? body.toData()
        }
    }
    
    var scheme: String {
        "https"
    }
    
    var host: String {
        "example.com"
    }
    
    var path: String {
        switch self {
        case .sessions:
            return "/api/sessions"
        case .createSession:
            return "/api/sessions"
        case .messages(let sessionId):
            return "/api/sessions/\(sessionId)/messages"
        case .sendMessage(let sessionId, _):
            return "/api/sessions/\(sessionId)/messages"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .sessions, .messages:
            return .GET
        case .createSession, .sendMessage:
            return .POST
        }
    }
    
    var queryItems: [URLQueryItem] {
        []
    }
    
    var headers: [String: String] {
        [:]
    }
}
