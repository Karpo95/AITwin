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
    @StateObject var viewModel: SessionsListViewModel = SessionsListViewModel()
    
    //MARK: - Init
    
    //MARK: - Body
    var body: some View {
        VStack {
            ScrollView {
                placeholderView
                listView
            }
            newSessionButton
        }
        .mainBg()
        .loading(viewModel.isLoading)
        .errorAlert(error: $viewModel.error)
        .navBar(title: TextConstant.sessions) {
            SessionsNavBar(action: viewModel.refreshAction)
        }
        .onReceive(coordinator.sessionDidAdd) { newSession in
            viewModel.addSession(newSession)
        }
    }
    
    //MARK: - Subviews
    
    private var newSessionButton: some View {
        AppButton(text: TextConstant.startNewSession) {
            coordinator.createNewSessionAction()
        }
    }
    
    @ViewBuilder private var placeholderView: some View {
        if viewModel.showPlaceholder {
            PlaceholderText(text: TextConstant.sessionsPlaceholder)
                .padding()
        }
    }
    
    private var listView: some View {
        LazyVStack(spacing: 10) {
            ForEach(viewModel.sessions) { session in
                SessionItemView(session: session)
                    .onTapGesture {
                        coordinator.didSelectSession(session)
                    }
            }
        }
        .padding()
    }
}
