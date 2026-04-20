//
//  HTTPClient.swift
//  AISmartExpenseAnalyzer
//
//  Created by Thiago Oliveira on 20/04/26.
//

import Foundation

protocol HTTPClientProtocol {
    func send<T: Decodable>(_ request: URLRequest) async throws -> T
}

final class HTTPClient: HTTPClientProtocol {
    private let session: URLSession
    private let decoder: JSONDecoder

    init(session: URLSession = .shared, decoder: JSONDecoder = JSONDecoder()) {
        self.session = session
        self.decoder = decoder
    }

    func send<T>(_ request: URLRequest) async throws -> T where T : Decodable {
        let data: Data
        let response: URLResponse

        do {
            (data, response) = try await session.data(for: request)
        } catch let urlError as URLError {
            throw HTTPClientError.from(urlError)
        }

        guard let http = response as? HTTPURLResponse else {
            throw HTTPClientError.invalidResponse
        }

        switch http.statusCode {
        case 200...299:
            do {
                return try decoder.decode(T.self, from: data)
            } catch {
                throw HTTPClientError.decodingFailed(reason: error.localizedDescription)
            }
        case 401:
            throw HTTPClientError.unauthorized
        case 429:
            throw HTTPClientError.rateLimited
        case 500...599:
            throw HTTPClientError.serverError(statusCode: http.statusCode)
        default:
            throw HTTPClientError.unexpectedStatusCode(http.statusCode)
        }
    }
}

// MARK: - HTTP Errors
enum HTTPClientError: Error, LocalizedError, Equatable {
    case networkUnavailable
    case timedOut
    case invalidResponse
    case unauthorized
    case rateLimited
    case serverError(statusCode: Int)
    case unexpectedStatusCode(Int)
    case decodingFailed(reason: String)

    var errorDescription: String? {
        switch self {
        case .networkUnavailable:
            return "No network connection."
        case .timedOut:
            return "The request timed out."
        case .invalidResponse:
            return "Received an invalid response from the server."
        case .unauthorized:
            return "Authentication failed. Check your API key."
        case .rateLimited:
            return "Rate limited by the server. Please try again later."
        case .serverError(let code):
            return "Server error (\(code)). Please try again."
        case .unexpectedStatusCode(let statusCode):
            return "Unexpected status code: \(statusCode)."
        case .decodingFailed(let reason):
            return "Failed to decode response: \(reason)"
        }
    }

    static func from(_ urlError: URLError) -> HTTPClientError {
        switch urlError.code {
        case .notConnectedToInternet, .networkConnectionLost:
            return .networkUnavailable
        case .timedOut:
            return .timedOut
        default:
            return .networkUnavailable
        }
    }
}
