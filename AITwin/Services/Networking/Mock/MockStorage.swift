//
//  MockStorage.swift
//  AITwin
//
//  Created by Karpenko Bohdan on 31.05.2025.
//

import Foundation

final class MockStorage {
    static let shared = MockStorage()

    private var sessions: [Session] = []
    private var messages: [String: [Message]] = [:]
    private let storage: FileStorageService

    private init() {
        guard let storage = FileStorageService(filename: "mock_data.json") else {
            fatalError("[MockStorage] Failed to initialize FileStorageService.")
        }
        self.storage = storage
        load()
    }

    private func load() {
        guard let wrapper: StorageWrapper = storage.load() else {
            print("[MockStorage] No data found on disk.")
            return
        }
        self.sessions = wrapper.sessions
        self.messages = wrapper.messages
    }

    private func persist() -> Bool {
        let wrapper = StorageWrapper(sessions: sessions, messages: messages)
        return storage.save(wrapper)
    }

    // MARK: - Sessions

    func getSessions() -> [Session] {
        sessions.sorted { $0.date > $1.date }
    }

    func addSession(title: String, category: SessionCategory) -> Session? {
        let newSession = Session(
            id: UUID().uuidString,
            date: ISO8601DateFormatter().string(from: Date()),
            title: title,
            category: category
        )
        sessions.insert(newSession, at: 0)
        let succes = persist()
        return succes ? newSession : nil
    }

    // MARK: - Messages

    func getMessages(sessionId: String) -> [Message] {
        messages[sessionId] ?? []
    }

    func addMessage(_ text: String, sender: Message.Sender, sessionId: String) -> Message? {
        let message = Message(
            id: UUID().uuidString,
            sessionId: sessionId,
            text: text,
            sender: sender,
            timestamp: ISO8601DateFormatter().string(from: Date())
        )
        messages[sessionId, default: []].append(message)
        let succes = persist()
        return succes ? message : nil
    }
}

