//
//  CreateSessionViewModel.swift
//  AITwin
//
//  Created by Karpenko Bohdan on 31.05.2025.
//

import Foundation

@MainActor
final class CreateSessionViewModel: ObservableObject {
    // MARK: - Properties

    @Published var title: String = ""
    @Published var selectedCategory: SessionCategory? = nil
    @Published var error: AppError?
    @Published private(set) var createdSession: Session?
    @Published private(set) var loading = false
    
    var isCreateEnabled: Bool {
        selectedCategory != nil 
    }
    
    private let networkService: NetworkServiceProtocol

    // MARK: - Init

    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    //MARK: - Open func
    
    func startSession() {
        guard let selectedCategory = selectedCategory else { return }
        loading = true
        
        Task { [weak self] in
            guard let self else { return }
            do {
                let title = try NonEmptyValidator().validate(title)
                createdSession = try await networkService.createSession(title: title, category: selectedCategory)
            } catch let error as NetworkError {
                self.error = .network(error)
            } catch let error as ValidationError {
                self.error = .custom(message: error.localizedDescription)
            }
            loading = false
        }
    }
}
