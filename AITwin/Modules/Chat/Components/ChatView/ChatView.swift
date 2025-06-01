//
//  ChatView.swift
//  AITwin
//
//  Created by Karpenko Bohdan on 01.06.2025.
//

import SwiftUI

struct ChatView: View {
    // MARK: - Properties
    let messages: [Message]
    
    // MARK: - Body
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack {
                    placeholder
                    ForEach(messages) { message in
                        MessageView(message: message)
                            .id(message.id)
                            .transition(.move(edge: message.sender == .user ? .bottom : .bottom).combined(with: .opacity))
                    }
                    .animation(.easeInOut(duration: 0.3), value: messages)
                }
            }
            .onAppear {
                scrollToLast(proxy, messages: messages)
            }
            .onChange(of: messages) { newValue in
                withAnimation(messages.count == 0 ? nil : .easeOut(duration: 0.35)) {
                    scrollToLast(proxy, messages: newValue)
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardDidShowNotification)) { _ in
                withAnimation(.easeOut(duration: 0.25)) {
                    scrollToLast(proxy, messages: messages)
                }
            }
        }
        .padding(.horizontal)
    }
    
    //MARK: - Subviews
    
    @ViewBuilder private var placeholder: some View {
        if messages.count == 0 {
            PlaceholderText(text: TextConstant.chatPlaceholder)
        }
    }
    
    //MARK: - Actions
    
    private func scrollToLast(_ proxy: ScrollViewProxy, messages: [Message]) {
        let lastID = messages.last?.id
        proxy.scrollTo(lastID, anchor: .bottom)
    }
}
