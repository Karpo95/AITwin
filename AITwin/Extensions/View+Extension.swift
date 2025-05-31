//
//  View+Extension.swift
//  AITwin
//
//  Created by Karpenko Bohdan on 31.05.2025.
//

import SwiftUI

extension View {
    func loading(isLoading: Bool) -> some View {
        self
            .overlay {
                if isLoading {
                    ZStack {
                        Rectangle()
                            .foregroundStyle(.black.opacity(0.3))
                            .ignoresSafeArea()
                        AppLoaderView()
                    }
                }
            }
    }
    
    func mainBg() -> some View {
        ZStack {
            MainBgGradient()
                .ignoresSafeArea()
            self
        }
    }
}

struct MainBgGradient: View {
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                .bgTop,
                .bgBottom,
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
}
