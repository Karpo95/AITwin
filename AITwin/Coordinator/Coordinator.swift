//
//  Coordinator.swift
//  AITwin
//
//  Created by Karpenko Bohdan on 31.05.2025.
//

import SwiftUI
import Combine

final class Coordinator: BaseCoordinator<Coordinator.Screen> {
    //MARK: - Properties
    
    let sessionDidAdd = PassthroughSubject<Session, Never>()
    
    //MARK: - Init
    
    init() {
        super.init(rootScreen: .sessionsList)
    }
    
    //MARK: - Actions
    
    func createNewSessionAction() {
        push(.createSession)
    }
    
    func addSession(_ session: Session) {
        sessionDidAdd.send(session)
        push(.chat(session.id))
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
                return 2
            }
        }
    }
}
