//
//  Coordinator.swift
//  AITwin
//
//  Created by Karpenko Bohdan on 31.05.2025.
//

import SwiftUI

final class Coordinator: BaseCoordinator<Coordinator.Screen> {
    
    //MARK: - Init
    
    init() {
        super.init(rootScreen: .sessionsList)
    }
    
    //MARK: - Actions
    
    func createNewSessionAction() {
        push(.createSession)
    }
}

extension Coordinator {
    enum Screen: ScreenProtocol {
        case sessionsList
        case createSession
        case chat(_ sessionId: String)
        
        func view() -> AnyView {
            switch self {
            case .sessionsList:
                return AnyView(SessionsListView())
            case .createSession:
                return AnyView(CreateSessionView())
            case .chat(let id):
                return AnyView(ChatView())
            }
        }
        
        var id: Int {
            switch self {
            case .sessionsList:
                return 0
            case .createSession:
                return 1
            case .chat:
                return 3
            }
        }
    }
}
