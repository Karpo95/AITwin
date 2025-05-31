//
//  BaseCoordinator.swift
//  AITwin
//
//  Created by Karpenko Bohdan on 31.05.2025.
//

import SwiftUI

protocol ScreenProtocol: Hashable, Identifiable {
    func view() -> AnyView
}

class BaseCoordinator<ScreenType: ScreenProtocol>: ObservableObject, AnyObject {
    
    @Published var navigationPath: [ScreenType] = []
    @Published var sheet: ScreenType?
    @Published var fullScreenCover: ScreenType?
    @Published var rootScreen: ScreenType
    
    init(rootScreen: ScreenType) {
        self.rootScreen = rootScreen
    }
    
    func push(_ screen: ScreenType) {
        navigationPath.append(screen)
    }
    
    func sheet(_ screen: ScreenType) {
        sheet = screen
    }
    
    func present(_ screen: ScreenType) {
        fullScreenCover = screen
    }
    
    func back() {
        navigationPath.removeLast()
    }
    
    func backToRoot() {
        navigationPath.removeAll()
    }
}
