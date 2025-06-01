//
//  AppTextField.swift
//  AITwin
//
//  Created by Karpenko Bohdan on 31.05.2025.
//

import SwiftUI

struct AppTextField: View {
    //MARK: - Properties
    
    @Binding var text: String
    let placeholder: String
    
    //MARK: - Body
    
    var body: some View {
        TextField(placeholder, text: $text)
            .padding(12)
            .font(.appFont(.regular, size: 17))
            .background(Color(.white))
            .cornerRadius(8)
            .shadow(radius: 3)
    }
}
