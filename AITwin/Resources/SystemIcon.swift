//
//  SystemIcon.swift
//  AITwin
//
//  Created by Karpenko Bohdan on 31.05.2025.
//

import SwiftUI

enum SystemIcon: String {
    case refresh = "arrow.clockwise"
    
    var image: Image {
        Image(systemName: rawValue)
    }
}
