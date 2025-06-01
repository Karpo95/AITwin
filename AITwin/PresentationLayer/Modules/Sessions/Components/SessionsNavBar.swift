//
//  SessionsNavBar.swift
//  AITwin
//
//  Created by Karpenko Bohdan on 31.05.2025.
//

import SwiftUI

struct SessionsNavBar: ToolbarContent {
    //MARK: - Properties
    
    let action: EmptyClosure
    
    //MARK: - Body
    
    var body: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            IconButton(icon: .refresh, action: action)
        }
    }
}
