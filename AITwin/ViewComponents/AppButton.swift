//
//  AppButton.swift
//  AITwin
//
//  Created by Karpenko Bohdan on 31.05.2025.
//

import SwiftUI

struct AppButton: View {
    //MARK: - Properties
    
    let action: EmptyClosure
    let text: String
    
    //MARK: - Body
    
    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.appFont(.semiBold, size: 17))
                .foregroundStyle(.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 15)
                .background{
                    RoundedRectangle(cornerRadius: .greatestFiniteMagnitude)
                        .foregroundStyle(.primary)
                }
                .shadow(radius: 3)
        }
    }
}

#Preview {
    AppButton(action: {}, text: "Some button")
}
