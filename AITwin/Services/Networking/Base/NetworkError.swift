//
//  NetworkError.swift
//  AITwin
//
//  Created by Karpenko Bohdan on 31.05.2025.
//

import Foundation

enum NetworkError: LocalizedError {
    case invalidURL
    case jsonDecodeError
    case unauthorized
    case paymentRequired
    case dataLoadingError(code: Int)
    case unknown

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The URL provided was invalid."
        case .jsonDecodeError:
            return "Failed to decode the response from the server."
        case .unauthorized:
            return "You are not authorized. Please log in again."
        case .paymentRequired:
            return "Payment is required to access this resource."
        case .dataLoadingError(let code):
            return "Failed to load data. Server responded with status code \(code)."
        case .unknown:
            return "An unknown error occurred. Please try again later."
        }
    }
}
