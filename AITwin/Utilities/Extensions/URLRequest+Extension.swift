//
//  URLRequest+Extension.swift
//  AITwin
//
//  Created by Karpenko Bohdan on 31.05.2025.
//

import Foundation

extension URLRequest {
    func bodyData() -> Data? {
        if let b = httpBody {
            return b
        }
        
        guard let stream = httpBodyStream else {
            return nil
        }
        
        stream.open()
        defer { stream.close() }
        
        let bufferSize = 1024
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: bufferSize)
        defer { buffer.deallocate() }
        
        var data = Data()
        while stream.hasBytesAvailable {
            let read = stream.read(buffer, maxLength: bufferSize)
            if read == 0 { break }
            data.append(buffer, count: read)
        }
        return data
    }
}

