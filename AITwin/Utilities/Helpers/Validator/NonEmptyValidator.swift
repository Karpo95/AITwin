//
//  NonEmptyValidator.swift
//  AITwin
//
//  Created by Karpenko Bohdan on 01.06.2025.
//

import Foundation

struct NonEmptyValidator {
    func validate(_ text: String) throws -> String {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            throw ValidationError.emptyField
        }
        return trimmed
    }
}
