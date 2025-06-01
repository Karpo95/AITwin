//
//  CreateSessionViewModelTest.swift
//  AITwinTests
//
//  Created by Karpenko Bohdan on 01.06.2025.
//

import XCTest
import Combine
@testable import AITwin

@MainActor
final class CreateSessionViewModelTests: XCTestCase {
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Helpers

    private func awaitLoadingCompletion(
        of viewModel: CreateSessionViewModel,
        timeout: TimeInterval = 1.0
    ) {
        let expectation = XCTestExpectation(description: "Wait until loading becomes false")

        viewModel.$loading
            .dropFirst() // skip initial
            .sink { loading in
                if loading == false {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: timeout)
    }

    // MARK: - Tests

    func test_startSession_success_setsCreatedSession_andDisablesLoading() {
        // Given
        let expectedSession = Session(id: "s", date: "2025-06-01T12:00:00Z", title: "Test", category: .anxiety)
        let mock = MockNetworkService()
        mock.createSessionBehavior = .success
        mock.createSessionResult = expectedSession

        let viewModel = CreateSessionViewModel(networkService: mock)
        viewModel.title = "Test"
        viewModel.selectedCategory = .anxiety

        // When
        viewModel.startSession()
        awaitLoadingCompletion(of: viewModel)

        // Then
        XCTAssertEqual(viewModel.createdSession?.id, expectedSession.id)
        XCTAssertFalse(viewModel.loading)
        XCTAssertNil(viewModel.error)
    }

    func test_startSession_validationFailure_setsValidationError_andDisablesLoading() {
        // Given
        let mock = MockNetworkService()
        let viewModel = CreateSessionViewModel(networkService: mock)
        viewModel.title = ""
        viewModel.selectedCategory = .anxiety

        // When
        viewModel.startSession()
        awaitLoadingCompletion(of: viewModel)

        // Then
        XCTAssertNil(viewModel.createdSession)
        XCTAssertFalse(viewModel.loading)
        XCTAssertNotNil(viewModel.error)
        if case let .custom(message)? = viewModel.error {
            XCTAssertFalse(message.isEmpty, "Validation error should have a message")
        } else {
            XCTFail("Expected .custom error")
        }
    }

    func test_startSession_networkFailure_setsNetworkError_andDisablesLoading() {
        // Given
        let mock = MockNetworkService()
        mock.createSessionBehavior = .failure(.unauthorized)

        let viewModel = CreateSessionViewModel(networkService: mock)
        viewModel.title = "Any"
        viewModel.selectedCategory = .career

        // When
        viewModel.startSession()
        awaitLoadingCompletion(of: viewModel)

        // Then
        XCTAssertNil(viewModel.createdSession)
        XCTAssertFalse(viewModel.loading)
        XCTAssertNotNil(viewModel.error)
    }

    func test_isCreateEnabled_returnsTrueOnlyIfCategorySelected() {
        // Given
        let mock = MockNetworkService()
        let viewModel = CreateSessionViewModel(networkService: mock)

        // Then
        XCTAssertFalse(viewModel.isCreateEnabled, "Should be false when category is nil")

        // When
        viewModel.selectedCategory = .career
        XCTAssertTrue(viewModel.isCreateEnabled, "Should be true when category is set")
    }

    func test_startSession_failsWithoutCategory() {
        // Given
        let mock = MockNetworkService()
        let viewModel = CreateSessionViewModel(networkService: mock)
        viewModel.title = "Some Title"
        viewModel.selectedCategory = nil

        // When
        viewModel.startSession()

        // Then
        XCTAssertNil(viewModel.createdSession)
        XCTAssertFalse(viewModel.loading)
        XCTAssertFalse(viewModel.isCreateEnabled)
    }
}
