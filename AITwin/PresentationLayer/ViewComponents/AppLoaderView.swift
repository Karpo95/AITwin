//
//  AppLoaderView.swift
//  AITwin
//
//  Created by Karpenko Bohdan on 31.05.2025.
//

import SwiftUI

struct AppLoaderView: View {
    var body: some View {
        ZStack {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
                .padding(15)
                .scaleEffect(1.5)
                .tint(.accent)
                .background(Color(.gray).opacity(0.7))
                .cornerRadius(10)
        }
    }
}
