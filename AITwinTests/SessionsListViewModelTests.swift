//
//  SessionsListViewModelTests.swift
//  AITwinTests
//
//  Created by Karpenko Bohdan on 01.06.2025.
//

import Foundation
import XCTest
import Combine
@testable import AITwin

@MainActor
final class SessionsListViewModelTests: XCTestCase {
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Helpers

    /// Waits until the `loading` property of the viewModel changes from true to false.
    private func awaitFetchCompletion(of viewModel: SessionsListViewModel, timeout: TimeInterval = 1.0) {
        let expectation = XCTestExpectation(description: "Wait until loading becomes false")
        viewModel.$isLoading
            // Skip the initial emission
            .dropFirst()
            .sink { loading in
                if loading == false {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: timeout)
    }

    /// Creates a SessionsListViewModel with a configured mock service, then waits for initial fetch to complete.
    /// - Parameters:
    ///   - sessions: The array of Session to return from the mock.
    ///   - behavior: Whether the mock should succeed or fail.
    /// - Returns: A viewModel in which `loading == false`.
    private func makeViewModel(
        with sessions: [Session],
        behavior: MockNetworkService.Behavior = .success
    ) -> SessionsListViewModel {
        let mock = MockNetworkService()
        mock.sessionsBehavior = behavior
        mock.sessionsResult = sessions
        let vm = SessionsListViewModel(networkService: mock)
        awaitFetchCompletion(of: vm)
        return vm
    }

    // MARK: - Tests for fetchData()

    func test_fetchData_success_populatesSessions_and_clearsLoading() {
        // Given / When
        let sessions = mockSessionsUnsorted
        let viewModel = makeViewModel(with: sessions)

        // Then
        XCTAssertFalse(
            viewModel.isLoading,
            "loading should be false after successful fetch"
        )
        XCTAssertEqual(
            viewModel.sessions.count,
            sessions.count,
            "The number of sessions should match the mock data"
        )
        XCTAssertEqual(
            viewModel.sessions.first?.id,
            "s1",
            "The first session (latest by date) should be s1"
        )
        XCTAssertNil(
            viewModel.error,
            "error should be nil when data is fetched successfully"
        )
        XCTAssertFalse(
            viewModel.showPlaceholder,
            "showPlaceholder should be false when sessions array is not empty"
        )
    }

    func test_fetchData_failure_setsError_and_keepsSessionsEmpty() {
        // Given / When
        let viewModel = makeViewModel(with: [], behavior: .failure(.unknown))

        // Then
        XCTAssertFalse(
            viewModel.isLoading,
            "loading should be false after fetchData() finishes with an error"
        )
        XCTAssertTrue(
            viewModel.sessions.isEmpty,
            "sessions should remain empty when fetchData() fails"
        )
        XCTAssertNotNil(
            viewModel.error,
            "error should be non-nil when fetchData() fails"
        )
        XCTAssertTrue(
            viewModel.showPlaceholder,
            "showPlaceholder should be true when sessions array is empty"
        )
    }

    func test_fetchData_sortsSessionsByDateDescending() {
        // Given: an unsorted array
        let unsorted: [Session] = mockSessionsUnsorted

        // When
        let viewModel = makeViewModel(with: unsorted)

        // Then: expect ["s1", "s2", "s3"]
        let sortedIDs = viewModel.sessions.map { $0.id }
        XCTAssertEqual(
            sortedIDs,
            ["s1", "s2", "s3"],
            "Sessions should be sorted by date descending: newest (s1), then s2, then oldest (s3)"
        )
    }

    // MARK: - Tests for refreshAction()

    func test_refreshAction_reloadsDataAndSortsByDateDescending() {
        // Given: initial data with one session
        let initial = [initialSession]
        let mockService = MockNetworkService()
        mockService.sessionsBehavior = .success
        mockService.sessionsResult = initial

        let viewModel = SessionsListViewModel(networkService: mockService)
        awaitFetchCompletion(of: viewModel)

        XCTAssertEqual(
            viewModel.sessions.count,
            1,
            "Initially there should be one session"
        )
        XCTAssertEqual(
            viewModel.sessions.first?.id,
            "s4",
            "The initial session ID should be 's4'"
        )

        // Prepare a new unsorted mock result for refresh
        let unsortedForRefresh: [Session] = mockSessionsUnsorted
        
        mockService.sessionsResult = unsortedForRefresh

        // When
        viewModel.refreshAction()
        XCTAssertTrue(
            viewModel.isLoading,
            "loading should become true immediately after calling refreshAction()"
        )
        awaitFetchCompletion(of: viewModel)

        // Then: expect ["s1", "s2", "s3"]
        XCTAssertEqual(
            viewModel.sessions.count,
            unsortedForRefresh.count,
            "After refreshAction(), sessions should match new mock count"
        )
        let refreshSortedIDs = viewModel.sessions.map { $0.id }
        XCTAssertEqual(
            refreshSortedIDs,
            ["s1", "s2", "s3"],
            "After refresh, sessions should be sorted by date descending: newest (s1), then s2, then s3"
        )
        XCTAssertNil(
            viewModel.error,
            "error should remain nil when refreshAction() succeeds"
        )
        XCTAssertFalse(
            viewModel.showPlaceholder,
            "showPlaceholder should be false when there are sessions"
        )
    }

    // MARK: - Tests for addSession(_:)

    func test_addSession_insertsSessionAtFront_whenArrayEmpty() {
        // Given / When
        let viewModel = makeViewModel(with: [], behavior: .success)
        let newSession = newerSession
        viewModel.addSession(newSession)

        // Then
        XCTAssertEqual(
            viewModel.sessions.count,
            1,
            "After adding, there should be exactly one session"
        )
        XCTAssertEqual(
            viewModel.sessions.first?.id,
            newSession.id,
            "The added session should appear at the front of the array"
        )
        XCTAssertFalse(
            viewModel.showPlaceholder,
            "showPlaceholder should be false when there is at least one session"
        )
    }

    func test_addSession_insertsSessionAtFront_whenArrayNonEmpty() {
        // Given: preload two sessions in descending order
        let initialSessions: [Session] = mockSessionsUnsorted
        let mockService = MockNetworkService()
        mockService.sessionsBehavior = .success
        mockService.sessionsResult = initialSessions

        let viewModel = SessionsListViewModel(networkService: mockService)
        awaitFetchCompletion(of: viewModel)

        XCTAssertEqual(
            viewModel.sessions.map { $0.id },
            ["s1", "s2", "s3"],
            "Initially, sessions should be sorted descending by date: s1 then s2, s3"
        )

        // When: add a newer session
        let newerSession = newerSession
        viewModel.addSession(newerSession)

        // Then
        XCTAssertEqual(
            viewModel.sessions.count,
            4,
            "After adding, there should be four sessions"
        )
        XCTAssertEqual(
            viewModel.sessions.map { $0.id },
            ["s0", "s1", "s2", "s3"],
            "New session should appear at the front, followed by previous sessions"
        )
        XCTAssertFalse(
            viewModel.showPlaceholder,
            "showPlaceholder should be false when there are sessions"
        )
    }
}


// MARK: - Mock Data for Tests

private extension SessionsListViewModelTests {
    /// Array of mock sessions intentionally unsorted for testing sort logic
    var mockSessionsUnsorted: [Session] {
        [
            Session(id: "s2", date: "2024-12-15T14:30:00Z", title: "Session Two", category: .career),
            Session(id: "s1", date: "2025-06-01T08:00:00Z", title: "Session One", category: .anxiety),
            Session(id: "s3", date: "2023-07-20T09:15:00Z", title: "Session Three", category: .conflictResolution)
        ]
    }
    
    var initialSession: Session {
        Session(id: "s4", date: "2022-06-01T12:00:00Z", title: "Initial Session", category: .anxiety)
    }
    
    /// A new session that's newer than existing ones
    var newerSession: Session {
        Session(id: "s0", date: "2025-06-01T10:00:00Z", title: "Session A0", category: .conflictResolution)
    }
}
