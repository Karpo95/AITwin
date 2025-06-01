//
//  SendButton.swift
//  AITwin
//
//  Created by Karpenko Bohdan on 01.06.2025.
//

import SwiftUI

struct SendButton: View {
    // MARK: - Properties
    
    let action: EmptyClosure
    let isLoading: Bool
    var isActive: Bool = true
    
    // MARK: - Body
    var body: some View {
        Button(action: action) {
            HStack {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(Constants.progressScale)
                        .tint(Color(.secondary))
                } else {
                    Text(TextConstant.send)
                        .font(.appFont(.bold, size: Constants.fontSize))
                        .foregroundStyle(.white)
                        .minimumScaleFactor(0.5)
                }
            }
            .frame(width: Constants.width, height: Constants.height)
            .background {
                RoundedRectangle(cornerRadius: Constants.cornerRadius)
                    .foregroundStyle(.accent)
            }
        }
        .allowsHitTesting(!isLoading && isActive)
        .opacity(isActive ? 1 : 0.5)
        .shadow(radius: Constants.shadowRadius)
    }
    
    // MARK: - Constants
    
    private enum Constants {
        static let width: CGFloat = 80
        static let height: CGFloat = 45
        static let cornerRadius: CGFloat = 5
        static let fontSize: CGFloat = 15
        static let progressScale: CGFloat = 1.5
        static let shadowRadius: CGFloat = 3
    }
}
