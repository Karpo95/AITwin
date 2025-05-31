//
//  FileStorageService.swift
//  AITwin
//
//  Created by Karpenko Bohdan on 31.05.2025.
//

import Foundation

final class FileStorageService {
    private let fileURL: URL

    init?(filename: String = "mock_data.json") {
        guard let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("[FileStorageService] Failed to locate document directory.")
            return nil
        }
        self.fileURL = docs.appendingPathComponent(filename)
    }

    func load<T: Decodable>() -> T? {
        do {
            let data = try Data(contentsOf: fileURL)
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            print("[FileStorageService] Failed to load or decode: \(error)")
            return nil
        }
    }

    func save<T: Encodable>(_ object: T) -> Bool {
        do {
            let data = try JSONEncoder().encode(object)
            try data.write(to: fileURL, options: .atomic)
            return true
        } catch {
            print("[FileStorageService] Failed to save: \(error)")
            return false
        }
    }
}
