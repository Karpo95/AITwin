//
//  IconButton.swift
//  AITwin
//
//  Created by Karpenko Bohdan on 31.05.2025.
//

import SwiftUI

struct IconButton: View {
    //MARK: - Properties
    
    let icon: SystemIcon
    let action: EmptyClosure
    
    //MARK: - Body
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon.rawValue)
                .padding(5)
        }
    }
}
