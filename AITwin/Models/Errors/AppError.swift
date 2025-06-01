//
//  AppError.swift
//  AITwin
//
//  Created by Karpenko Bohdan on 31.05.2025.
//

import Foundation

enum AppError: Error {
    case network(Error)
    case custom(message: String)
}

extension AppError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .network(let error):
            return error.localizedDescription
        case .custom(let message):
            return message
        }
    }
}

