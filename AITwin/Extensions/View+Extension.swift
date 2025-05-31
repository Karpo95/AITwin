//
//  View+Extension.swift
//  AITwin
//
//  Created by Karpenko Bohdan on 31.05.2025.
//

import SwiftUI

extension View { 
    func loading(_ isLoading: Bool) -> some View {
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
    
    func navBar<Content: ToolbarContent>(title: String = "", @ToolbarContentBuilder content:  () -> Content) -> some View {
        self
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
            .toolbar {
                content()
            }
            .navigationTitle(title)
    }
    
    //MARK: - Alerts
    
    func errorAlert(error: Binding<AppError?>, buttonTitle: String = "OK") -> some View {
        let localizedAlertError = LocalizedAlertError(error: error.wrappedValue)
        return alert(isPresented: .constant(localizedAlertError != nil), error: localizedAlertError) { _ in
            Button(buttonTitle) {
                error.wrappedValue = nil
            }
        } message: { error in
            Text(error.recoverySuggestion ?? "")
        }
    }
}
