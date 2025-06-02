//
//  SessionChatViewModelTests.swift
//  AITwinTests
//
//  Created by Karpenko Bohdan on 01.06.2025.
//

import XCTest
import Combine
@testable import AITwin

@MainActor
final class SessionChatViewModelTests: XCTestCase {
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Helpers

    /// Wait until either `messages` or `error` publishes a change, indicating `fetchData()` completed.
    private func waitForFetch(_ vm: SessionChatViewModel, timeout: TimeInterval = 1.0) {
        let exp = XCTestExpectation(description: "fetchData completed")
        Publishers.Merge(
            vm.$messages.dropFirst().map { _ in () },
            vm.$error.dropFirst().map { _ in () }
        )
        .first()
        .sink { _ in exp.fulfill() }
        .store(in: &cancellables)
        wait(for: [exp], timeout: timeout)
    }

    /// Wait until `error` becomes non‐nil.
    private func waitForError(_ vm: SessionChatViewModel, timeout: TimeInterval = 1.0) {
        let exp = XCTestExpectation(description: "error published")
        vm.$error
            .dropFirst()
            .sink { error in
                if error != nil { exp.fulfill() }
            }
            .store(in: &cancellables)
        wait(for: [exp], timeout: timeout)
    }

    /// Wait until `messages.count` equals `targetCount`.
    private func waitForMessagesCount(_ vm: SessionChatViewModel, targetCount: Int, timeout: TimeInterval = 1.0) {
        let exp = XCTestExpectation(description: "messages count == \(targetCount)")
        vm.$messages
            .sink { msgs in
                if msgs.count == targetCount {
                    exp.fulfill()
                }
            }
            .store(in: &cancellables)
        wait(for: [exp], timeout: timeout)
    }

    // MARK: - Init & fetchData

    /// GIVEN a successful network response with two messages
    /// WHEN the ViewModel is initialized
    /// THEN `messages` should contain those two messages, `showPlaceholder` is false, and `error` is nil.
    func test_init_fetchData_success_populatesMessages_andClearsPlaceholder() {
        // Given
        let session = Session.mock
        let initialMessages = [ Message.mockAssistant, Message.mockUser ]
        let network = MockNetworkService()
        network.messagesBehavior = .success
        network.messagesResult = initialMessages
        let ai = MockAIService()

        // When
        let vm = SessionChatViewModel(session: session, networkService: network, aiService: ai)
        waitForFetch(vm)

        // Then
        XCTAssertEqual(vm.messages, initialMessages, "Messages should match the mock data")
        XCTAssertFalse(vm.showPlaceholder, "showPlaceholder should be false when messages are non‐empty")
        XCTAssertNil(vm.error, "error should be nil on successful fetch")
    }

    /// GIVEN a failing network response
    /// WHEN the ViewModel is initialized
    /// THEN `messages` remains empty, `error` is non‐nil, and `showPlaceholder` is true.
    func test_init_fetchData_failure_setsError_andKeepsMessagesEmpty() {
        // Given
        let session = Session.mock
        let network = MockNetworkService()
        network.messagesBehavior = .failure(.unknown)
        let ai = MockAIService()

        // When
        let vm = SessionChatViewModel(session: session, networkService: network, aiService: ai)
        waitForFetch(vm)

        // Then
        XCTAssertTrue(vm.messages.isEmpty, "messages should be empty when fetch fails")
        XCTAssertNotNil(vm.error, "error should be non‐nil on fetch failure")
        XCTAssertTrue(vm.showPlaceholder, "showPlaceholder should be true when there are no messages")
    }

    /// GIVEN any valid session
    /// WHEN accessing `title`
    /// THEN it returns the session's title.
    func test_title_returnsSessionTitle() {
        // Given
        let session = Session(id: "s123", date: "2025-02-02T09:00:00Z", title: "Test Session", category: .anxiety)
        let network = MockNetworkService()
        network.messagesBehavior = .success
        network.messagesResult = []
        let ai = MockAIService()

        // When
        let vm = SessionChatViewModel(session: session, networkService: network, aiService: ai)
        waitForFetch(vm)

        // Then
        XCTAssertEqual(vm.title, "Test Session", "title should return the session's title")
    }

    // MARK: - Computed Properties

    /// GIVEN no messages returned
    /// WHEN checking `showPlaceholder`
    /// THEN it is true.
    ///
    /// GIVEN one message returned
    /// WHEN checking `showPlaceholder`
    /// THEN it is false.
    func test_showPlaceholder_trueWhenNoMessages_falseWhenHasMessages() {
        let session = Session.mock

        // Given (no messages)
        let netA = MockNetworkService()
        netA.messagesBehavior = .success
        netA.messagesResult = []
        let aiA = MockAIService()
        let vmA = SessionChatViewModel(session: session, networkService: netA, aiService: aiA)
        waitForFetch(vmA)
        // Then
        XCTAssertTrue(vmA.showPlaceholder, "showPlaceholder should be true when there are no messages")

        // Given (one message)
        let netB = MockNetworkService()
        netB.messagesBehavior = .success
        netB.messagesResult = [ Message.mockUser ]
        let aiB = MockAIService()
        let vmB = SessionChatViewModel(session: session, networkService: netB, aiService: aiB)
        waitForFetch(vmB)
        // Then
        XCTAssertFalse(vmB.showPlaceholder, "showPlaceholder should be false when messages array is non‐empty")
    }

    /// GIVEN the `text` is empty or whitespace
    /// WHEN checking `sendButtonIsActive`
    /// THEN it is false.
    ///
    /// GIVEN a non‐empty `text`
    /// WHEN checking `sendButtonIsActive`
    /// THEN it is true.
    func test_sendButtonIsActive_falseWhenTextEmpty_trueWhenNonEmpty() {
        // Given
        let session = Session.mock
        let network = MockNetworkService()
        network.messagesBehavior = .success
        network.messagesResult = []
        let ai = MockAIService()

        let vm = SessionChatViewModel(session: session, networkService: network, aiService: ai)
        waitForFetch(vm)

        // Then (initially empty)
        XCTAssertFalse(vm.isSendButtonActive, "sendButtonIsActive should be false when text is empty")

        // When
        vm.text = "Hello"
        // Then
        XCTAssertTrue(vm.isSendButtonActive, "sendButtonIsActive should be true when text is non‐empty")

        // When
        vm.text = "   "
        // Then
        XCTAssertFalse(vm.isSendButtonActive, "sendButtonIsActive should be false when text is only whitespace")
    }

    // MARK: - sendAction

    /// GIVEN a valid user text and successful network & AI responses
    /// WHEN `sendAction()` is called
    /// THEN two messages (user + assistant) are appended, `text` is cleared, and `error` remains nil.
    func test_sendAction_success_appendsTwoMessages_andClearsText() {
        // Given
        let session = Session.mock
        let network = MockNetworkService()
        network.messagesBehavior = .success
        network.messagesResult = []
        network.sendMessageBehavior = .success
        network.sendMessageUserResult = .mockUser
        network.sendMessageAssistantResult = .mockAssistant

        let ai = MockAIService()
        ai.response = "AI response"

        let vm = SessionChatViewModel(session: session, networkService: network, aiService: ai)
        waitForFetch(vm)
        XCTAssertTrue(vm.messages.isEmpty, "Should start with no messages")

        // When
        vm.text = "User text"
        vm.sendAction()
        waitForMessagesCount(vm, targetCount: 2)

        // Then
        XCTAssertEqual(vm.messages[0], Message.mockUser, "First message should be from user")
        XCTAssertEqual(vm.messages[1], Message.mockAssistant, "Second message should be from assistant")
        XCTAssertEqual(vm.text, "", "Text should be cleared after sending")
        XCTAssertNil(vm.error, "Error should remain nil on success")
    }

    /// GIVEN empty `text` (validation fails)
    /// WHEN `sendAction()` is called
    /// THEN `error` is non‐nil and `messages` remains empty.
    func test_sendAction_validationError_setsError_andKeepsMessagesEmpty() {
        // Given
        let session = Session.mock
        let network = MockNetworkService()
        network.messagesBehavior = .success
        network.messagesResult = []
        let ai = MockAIService()
        ai.response = "" // causes ValidationError.empty

        let vm = SessionChatViewModel(session: session, networkService: network, aiService: ai)
        waitForFetch(vm)

        // When (leave text empty)
        vm.text = ""
        vm.sendAction()
        waitForError(vm)

        // Then
        XCTAssertNotNil(vm.error, "Error should be non‐nil on validation failure")
        XCTAssertTrue(vm.messages.isEmpty, "Messages should remain empty when validation fails")
    }

    /// GIVEN a valid user `text` but network fails when sending user message
    /// WHEN `sendAction()` is called
    /// THEN `error` is non‐nil and `messages` remains empty.
    func test_sendAction_networkErrorOnUser_setsError_andKeepsMessagesEmpty() {
        // Given
        let session = Session.mock
        let network = MockNetworkService()
        network.messagesBehavior = .success
        network.messagesResult = []
        network.sendMessageBehavior = .failure(.unauthorized)
        let ai = MockAIService()

        let vm = SessionChatViewModel(session: session, networkService: network, aiService: ai)
        waitForFetch(vm)

        // When
        vm.text = "Hello"
        vm.sendAction()
        waitForError(vm)

        // Then
        XCTAssertNotNil(vm.error, "Error should be non‐nil on network failure for user message")
        XCTAssertTrue(vm.messages.isEmpty, "Messages should remain empty when user send fails")
    }

    /// GIVEN a valid user `text`, network succeeds for user, but AI validation fails
    /// WHEN `sendAction()` is called
    /// THEN one user message is appended, then `error` is non‐nil.
    func test_sendAction_aiValidationError_appendsUserMessage_andSetsError() {
        // Given
        let session = Session.mock
        let network = MockNetworkService()
        network.messagesBehavior = .success
        network.messagesResult = []
        network.sendMessageBehavior = .success
        network.sendMessageUserResult = .mockUser
        network.sendMessageAssistantResult = .mockAssistant

        let ai = MockAIService()
        ai.response = "" // causes ValidationError.empty in sendAIMessgae

        let vm = SessionChatViewModel(session: session, networkService: network, aiService: ai)
        waitForFetch(vm)

        // When
        vm.text = "Hello"
        vm.sendAction()
        waitForMessagesCount(vm, targetCount: 1) // user message appended
        waitForError(vm)

        // Then
        XCTAssertEqual(vm.messages.count, 1, "One user message should be appended before AI error")
        XCTAssertEqual(vm.messages.first?.sender, .user, "Appended message should be from user")
        XCTAssertNotNil(vm.error, "Error should be non‐nil after AI validation fails")
    }
}

// MARK: - Mocks & Test Data

private extension Message {
    static let mockUser = Message(
        id: "user-mock",
        sessionId: "mock-session-1",
        text: "User mock message",
        sender: .user,
        timestamp: "2025-03-01T12:00:00Z"
    )
    static let mockAssistant = Message(
        id: "assistant-mock",
        sessionId: "mock-session-1",
        text: "Assistant mock message",
        sender: .assistant,
        timestamp: "2025-03-01T12:00:01Z"
    )
}

private extension Session {
    static let mock = Session(
        id: "mock-session-1",
        date: "2025-01-01T10:00:00Z",
        title: "Mock Session Title",
        category: .anxiety
    )
}
