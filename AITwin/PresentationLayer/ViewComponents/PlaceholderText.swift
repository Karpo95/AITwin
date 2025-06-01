//
//  PlaceholderText.swift
//  AITwin
//
//  Created by Karpenko Bohdan on 31.05.2025.
//

import SwiftUI

struct PlaceholderText: View {
    //MARK: - Properties
    
    let text: String
    
    //MARK: - Body
    
    var body: some View {
         Text(text)
            .font(.appFont(.semiBold, size: 18))
            .foregroundStyle(.textPlaceholder)
            .multilineTextAlignment(.center)
    }
}
