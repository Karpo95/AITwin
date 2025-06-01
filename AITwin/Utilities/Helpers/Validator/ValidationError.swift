//
//  ValidationError.swift
//  AITwin
//
//  Created by Karpenko Bohdan on 01.06.2025.
//

import Foundation

enum ValidationError: LocalizedError {
    case emptyField
    
    var errorDescription: String? {
        switch self {
        case .emptyField:
            return "The field cannot be empty after trimming whitespace."
        }
    }
}
