//
//  MockAIService.swift
//  AITwinTests
//
//  Created by Karpenko Bohdan on 01.06.2025.
//

import Foundation
@testable import AITwin

final class MockAIService: AIServiceProtocol {
    var response: String = ""
    func sendMessage(_ text: String) async throws -> String {
        return try NonEmptyValidator().validate(response)
    }
}
