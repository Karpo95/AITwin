//
//  MockURLProtocol.swift
//  AITwin
//
//  Created by Karpenko Bohdan on 31.05.2025.
//

import Foundation

/// A URLProtocol subclass that intercepts requests to `/api/sessions` endpoints
/// and provides mocked responses with persistent storage.
class MockURLProtocol: URLProtocol {
    override class func canInit(with request: URLRequest) -> Bool {
        guard let path = request.url?.path else { return false }
        return path.hasPrefix("/api/sessions")
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        guard let url = request.url, let method = request.httpMethod else {
            respond(status: 400, data: nil)
            return
        }
        let pathComponents = url.path.split(separator: "/").map(String.init)
            let route = parseRoute(method: method, components: pathComponents)

            switch route {
            case .listSessions:
                respond(object: MockStorage.shared.getSessions())
            case .createSession:
                handleCreateSession()
            case .sessionMessages(let sessionId):
                respond(object: MockStorage.shared.getMessages(sessionId: sessionId))
            case .sendMessage(let sessionId):
                handleSendMessage(sessionId: sessionId)
            case .unknown:
                respond(status: 400, data: nil)
            }
    }
    
    private func parseRoute(method: String, components: [String]) -> Route {
        switch (method, components.count) {
        case ("GET", 2) where components == ["api", "sessions"]:
            return .listSessions
        case ("POST", 2) where components == ["api", "sessions"]:
            return .createSession
        case ("GET", 4) where components[0] == "api" && components[1] == "sessions" && components[3] == "messages":
            return .sessionMessages(sessionId: components[2])
        case ("POST", 4) where components[0] == "api" && components[1] == "sessions" && components[3] == "messages":
            return .sendMessage(sessionId: components[2])
        default:
            return .unknown
        }
    }

    override func stopLoading() {}
    
    // MARK: - Handlers
    
    private func handleCreateSession() {
        guard let data = request.bodyData(),
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: String],
              let title = json["title"],
              let categoryStr = json["category"],
        let categiry = SessionCategory(rawValue: categoryStr) else {
            respond(status: 400, data: nil)
            return
        }
        let newSession = MockStorage.shared.addSession(title: title, category: categiry)
        respond(object: newSession)
    }

    private func handleSendMessage(sessionId: String) {
        guard let data = request.bodyData(),
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: String],
              let text = json["text"],
              let senderRaw = json["sender"],
              let sender = Message.Sender(rawValue: senderRaw) else {
            respond(status: 400, data: nil)
            return
        }
        let newMessage = MockStorage.shared.addMessage(text, sender: sender, sessionId: sessionId)
        respond(object: newMessage)
    }

    // MARK: - Response Helpers

    private func respond<T: Codable>(object: T) {
        guard let data = try? JSONEncoder().encode(object) else {
            respond(status: 500, data: nil)
            return
        }
        respond(status: 200, data: data)
    }

    private func respond(status code: Int, data: Data?) {
        let response = HTTPURLResponse(
            url: request.url!,
            statusCode: code,
            httpVersion: nil,
            headerFields: ["Content-Type": "application/json"]
        )!
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        if let body = data {
            client?.urlProtocol(self, didLoad: body)
        }
        client?.urlProtocolDidFinishLoading(self)
    }
}

//MARK: - Route

extension MockURLProtocol {
    enum Route {
        case listSessions
        case createSession
        case sessionMessages(sessionId: String)
        case sendMessage(sessionId: String)
        case unknown
    }
}
