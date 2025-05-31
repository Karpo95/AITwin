//
//  BaseCoordinatorView.swift
//  AITwin
//
//  Created by Karpenko Bohdan on 31.05.2025.
//

import SwiftUI

struct BaseCoordinatorView<Screen: ScreenProtocol>: View {
    let rootScreen: Screen
    @Binding var navigationPath: [Screen]
    @Binding var sheet: Screen?
    @Binding var fullScreenCover: Screen?
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            rootScreen.view()
                .navigationDestination(for: Screen.self) { screen in
                    screen.view()
                        .toolbarRole(.editor)
                }
                .sheet(item: $sheet) { sheet in
                    sheet.view()
                }
                .fullScreenCover(item: $fullScreenCover) { item in
                    item.view()
                }
        }
        .navigationTitle("")
    }
}
