//
//  SessionsListViewModel.swift
//  AITwin
//
//  Created by Karpenko Bohdan on 31.05.2025.
//

import Foundation

@MainActor
final class SessionsListViewModel: ObservableObject {
    //MARK: - Properties
    
    @Published private(set) var sessions = [Session]()
    @Published private(set) var isLoading: Bool = false
    @Published var error: AppError?

    private let networkService: NetworkServiceProtocol
    
    var showPlaceholder: Bool {
        sessions.isEmpty
    }
    
    //MARK: - Init
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
        fetchData()
    }
    
    //MARK: - Open func
        
    func addSession(_ session: Session) {
        sessions.insert(session, at: 0)
    }
    
    func refreshAction() {
        fetchData()
    }
    
    //MARK: - Private
    
    private func fetchData() {
        isLoading = true
        Task { [weak self] in
            guard let self else { return }
            do {
                sessions = try await networkService.sessions().sortedByDate()
            } catch let error as NetworkError {
                self.error = .network(error)
            }
            isLoading = false
        }
    }
}
