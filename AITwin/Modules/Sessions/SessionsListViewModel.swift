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
    @Published private(set) var loading: Bool = false
    @Published var error: AppError?
    
    private let networkService: NetworkServiceProtocol
    
    var showPlaceholder: Bool {
        sessions.isEmpty
    }
    
    //MARK: - Init
    
    init(networService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networService
        fetchData()
    }
    
    //MARK: - Open func
    
    func refreshAction() {
        fetchData()
    }
    
    func createNewSessionAction() {
    
    }
    
    //MARK: - Private
    
    private func fetchData() {
        loading = true
        Task { [weak self] in
            guard let self else { return }
            do {
                sessions = try await networkService.sessions()
            } catch let error as NetworkError {
                self.error = .network(error)
            }
            loading = false
        }
    }
}
