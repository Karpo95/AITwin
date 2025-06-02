//
//  ChatViewModel.swift
//  AITwin
//
//  Created by Karpenko Bohdan on 01.06.2025.
//

import Foundation

@MainActor
final class SessionChatViewModel: ObservableObject {
    //MARK: - Properties
    @Published private(set) var messages = [Message]()
    
    @Published var error: AppError?
    @Published var text: String = ""
    @Published var isSending = false
    @Published var isLoading = false
    
    private let session: Session
    private let networkService: NetworkServiceProtocol
    private let aiService: AIServiceProtocol
    
    var title: String {
        session.title
    }
    
    var showPlaceholder: Bool {
        messages.count == 0
    }
    
    var isSendButtonActive: Bool {
        let text = try? NonEmptyValidator().validate(text)
        return text != nil
    }
    
    //MARK: - Init
    
    init(
        session: Session,
        networkService: NetworkServiceProtocol = NetworkService(),
        aiService: AIServiceProtocol = AIService()
    ) {
        self.session = session
        self.networkService = networkService
        self.aiService = aiService
        fetchData()
    }
    
    //MARK: - Open func
    
    func sendAction() {
        isSending = true
        Task { [weak self] in
            guard let self else { return }
            do {
                let userMessage = try await sendUserMessage()
                try await sendAIMessage(userMessage: userMessage)
            } catch let error as NetworkError {
                self.error = .network(error)
            } catch let error as ValidationError {
                self.error = .custom(message: error.localizedDescription)
            }
            isSending = false
        }
    }
    
    //MARK: - Private
    
    private func sendUserMessage() async throws -> Message {
        let text = try NonEmptyValidator().validate(text)
        let message = try await networkService.sendMessage(sessionId: session.id, text: text, sender: .user)
        self.text = ""
        messages.append(message)
        return message
    }
    
    private func sendAIMessage(userMessage: Message) async throws {
        let aiMessageText = try await aiService.sendMessage(text)
        let aiMessage = try await networkService.sendMessage(sessionId: session.id, text: aiMessageText, sender: .assistant)
        messages.append(aiMessage)
    }
    
    private func fetchData() {
        isLoading = true
        Task { [weak self] in
            guard let self else { return }
            do {
                messages = try await networkService.messages(sessionId: session.id)
            } catch let error as NetworkError {
                self.error = .network(error)
            }
            isLoading = false
        }
    }
}
