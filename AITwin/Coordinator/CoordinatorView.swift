//
//  CoordinatorView.swift
//  AITwin
//
//  Created by Karpenko Bohdan on 31.05.2025.
//

import SwiftUI

struct CoordinatorView: View {
    @StateObject private var coordinator = Coordinator()
    
    var body: some View {
        BaseCoordinatorView(
            rootScreen: coordinator.rootScreen,
            navigationPath: $coordinator.navigationPath,
            sheet: $coordinator.sheet,
            fullScreenCover: $coordinator.fullScreenCover
        )
        .environmentObject(coordinator)
    }
}
