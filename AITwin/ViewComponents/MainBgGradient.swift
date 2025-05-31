//
//  MainBgGradient.swift
//  AITwin
//
//  Created by Karpenko Bohdan on 31.05.2025.
//

import SwiftUI

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
