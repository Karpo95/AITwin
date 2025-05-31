//
//  BaseNetworkService.swift
//  AITwin
//
//  Created by Karpenko Bohdan on 31.05.2025.
//

import Foundation

class BaseNetworkService<Endpoint: TargetType> {
    
    init() {}
    
    func fetchData<T: Decodable>(api: Endpoint, urlSession: URLSession = .shared) async throws -> T {
        let request = try await createRequest(api: api)

        do {
            let (data, response) = try await urlSession.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.unknown
            }

            switch httpResponse.statusCode {
            case 200...299:
                break
            case 401:
                throw NetworkError.unauthorized
            case 402:
                throw NetworkError.paymentRequired
            default:
                throw NetworkError.dataLoadingError(code: httpResponse.statusCode)
            }

            do {
                return try await decode(data: data)
            } catch {
                throw NetworkError.jsonDecodeError
            }

        } catch let error as NetworkError {
            throw error
        } catch {
            throw NetworkError.unknown
        }
    }
    
    private func createRequest(api: Endpoint) async throws -> URLRequest {
        let url = try await createUrl(type: api)
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = api.headers
        request.httpMethod = api.httpMethod.rawValue
        if let bodyData = api.body {
            request.httpBody = bodyData
            if api.headers["Content-Type"] == nil {
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
        }
        return request
    }
    
    private func createUrl(type: Endpoint) async throws -> URL {
        var components = URLComponents()
        components.scheme = type.scheme
        components.host = type.host
        components.path = type.path
        guard let url = components.url else { throw NetworkError.invalidURL }
        return url
    }
    
    private func decode<T:Decodable>(data: Data) async throws -> T {
        let decoder = JSONDecoder()
        guard let result = try? decoder.decode(T.self, from: data) else { throw NetworkError.jsonDecodeError }
        return result
    }
}
