//
//  SessionChatNavBar.swift
//  AITwin
//
//  Created by Karpenko Bohdan on 01.06.2025.
//

import SwiftUI

struct SessionChatNavBar: ToolbarContent {
    //MARK: - Properties
    
    let backAction: EmptyClosure
    
    //MARK: - Body
    
    var body: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            IconButton(icon: .chevronLeft, action: backAction)
        }
    }
}
