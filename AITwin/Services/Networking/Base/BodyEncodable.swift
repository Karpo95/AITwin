//
//  BodyEncodable.swift
//  AITwin
//
//  Created by Karpenko Bohdan on 31.05.2025.
//

import Foundation

protocol BodyEncodable: Encodable {
    func toData() throws -> Data
}

extension BodyEncodable {
    func toData() throws -> Data {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        return try encoder.encode(self)
    }
}
