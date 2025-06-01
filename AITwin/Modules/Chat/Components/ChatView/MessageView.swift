//
//  MessageView.swift
//  AITwin
//
//  Created by Karpenko Bohdan on 01.06.2025.
//

import SwiftUI

struct MessageView: View {
    // MARK: - Properties
    let message: Message
    
    // MARK: - Helpers
    private var isFromUser: Bool {
        message.sender == .user
    }
    
    // MARK: - Body
    var body: some View {
        HStack {
            if isFromUser {
                Spacer(minLength: Constants.horizontalSpacerMinLength)
            }
            
            messageContent
                .background {
                    bg
                }
            
            if !isFromUser {
                Spacer(minLength: Constants.horizontalSpacerMinLength)
            }
        }
}
    
    //MARK: - Subviews
    
    private var bg: some View {
        ChatBubble()
            .rotation(Angle(degrees: isFromUser ? 180 : 0))
            .fill(
                Color(
                    isFromUser
                    ? .secondary
                    : .accent
                )
            )
    }
    
    private var messageContent: some View {
        VStack(alignment: isFromUser ? .trailing : .leading) {
            Text(message.text)
                .font(.appFont(.regular, size: Constants.fontSize))
                .foregroundStyle(.textMain)
            Text(message.formattedDate)
                .foregroundStyle(.white)
                .font(.appFont(.regular, size: Constants.dateFontSize))
        }
        .padding(.vertical, Constants.verticalPadding)
        .padding(
            .leading,
            isFromUser
            ? Constants.horizontalPaddingOutgoing
            : Constants.horizontalPaddingIncoming
        )
        .padding(
            .trailing,
            isFromUser
            ? Constants.horizontalPaddingIncoming
            : Constants.horizontalPaddingOutgoing
        )
    }
    
    // MARK: - Constants
    private enum Constants {
        static let fontSize: CGFloat = 13
        static let dateFontSize: CGFloat = 10
        static let verticalPadding: CGFloat = 12
        static let horizontalPaddingIncoming: CGFloat = 20
        static let horizontalPaddingOutgoing: CGFloat = 12
        static let horizontalSpacerMinLength: CGFloat = 40
    }
}
