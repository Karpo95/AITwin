//
//  SessionsListView.swift
//  AITwin
//
//  Created by Karpenko Bohdan on 31.05.2025.
//

import SwiftUI

struct SessionsListView: View {
    //MARK: - Properties
    
    @EnvironmentObject private var coordinator: Coordinator
    @StateObject private var viewModel = SessionsListViewModel()
    
    //MARK: - Body
    var body: some View {
        VStack {
            placeholder
            ScrollView {
                list
            }
            newSessionButton
        }
        .mainBg()
        .loading(viewModel.loading)
        .errorAlert(error: $viewModel.error)
        .navBar(title: TextConstant.sessions) {
            SessionsNavBar(action: viewModel.refreshAction)
        }
    }
    
    //MARK: - Subviews
    
    private var newSessionButton: some View {
        AppButton(text: TextConstant.startNewSession) {
            coordinator.createNewSessionAction()
        }
    }
    
    @ViewBuilder private var placeholder: some View {
        if viewModel.showPlaceholder {
            PlaceholderText(text: TextConstant.sessionsPlaceholder)
                .padding()
        }
    }
    
    private var list: some View {
        VStack(spacing: 10) {
            ForEach(viewModel.sessions) { session in
                SessionItemView(session: session)
            }
        }
        .padding(.horizontal)
    }
}

//MARK: - Preview

#Preview {
    SessionsListView()
}
