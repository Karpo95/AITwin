//
//  CreateSessionView.swift
//  AITwin
//
//  Created by Karpenko Bohdan on 31.05.2025.
//

import SwiftUI

struct CreateSessionView: View {
    //MARK: - Properties
    
    @EnvironmentObject private var coordinator: Coordinator
    @StateObject private var viewModel = CreateSessionViewModel()
    
    //MARK: - Body
    
    var body: some View {
        VStack {
            titleTextField
            categories
            AppButton(
                text: TextConstant.startSession,
                action: viewModel.startSession
            )
            .padding()
            .disabled(!viewModel.isCreateEnabled)
            .opacity(!viewModel.isCreateEnabled ? 0.5 : 1)
        }
        .navigationTitle(TextConstant.createSession)
        .mainBg()
        .loading(viewModel.loading)
        .errorAlert(error: $viewModel.error)
        .onReceive(viewModel.$createdSession.compactMap { $0 }) { newSession in
            coordinator.addSession(newSession)
        }
    }
    
    //MARK: - Subviews
    
    private var titleTextField: some View {
        AppTextField(text: $viewModel.title, placeholder: TextConstant.sessionTitlePlaceholder)
            .padding()
    }
    
    private var categories: some View {
        FlexibleWrapGridView(
            items: SessionCategory.allCases,
            selectedItem: $viewModel.selectedCategory
        )
    }
}

//MARK: - Preview

#Preview {
    CreateSessionView()
}
