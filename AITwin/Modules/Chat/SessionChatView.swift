//
//  SessionChatView.swift
//  AITwin
//
//  Created by Karpenko Bohdan on 31.05.2025.
//

import SwiftUI

struct SessionChatView: View {
    //MARK: - Properties
    
    @EnvironmentObject private var coordinator: Coordinator
    @StateObject private var viewModel: SessionChatViewModel
    
    //MARK: - Init
    
    init(session: Session) {
        _viewModel = StateObject(wrappedValue: SessionChatViewModel(session: session))
    }
    
    //MARK: - Body
    
    var body: some View {
        VStack {
            ChatView(messages: viewModel.messages)
            inputView
        }
        .mainBg()
        .errorAlert(error: $viewModel.error)
        .navBar(title: viewModel.title) {
            SessionChatNavBar {
                coordinator.backToRoot()
            }
        }
        .toolbarBackground(Color.white.opacity(0.8), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
    }
    
    //MARK: - Subviews
    
    private var inputView: some View {
        HStack {
            AppTextField(text: $viewModel.text, placeholder: TextConstant.messagePlaceholder)
            SendButton(action: viewModel.sendAction, isLoading: viewModel.sendLoading, isActive: viewModel.sendButtonIsActive)
        }
        .padding(.horizontal)
        .padding(.bottom)
    }
}

