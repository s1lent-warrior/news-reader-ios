//
//  NetworkService.swift
//  NewsReader
//
//  Created by Muneeb Ahmed Anwar on 27/08/2025.
//

import Foundation
import Combine

public protocol NetworkService {
    var decoder: JSONDecoder { get set }

    func fetch<T: Decodable>(from request: RequestModel) -> AnyPublisher<T, NetworkError>
    func fetch<T: Decodable>(from request: RequestModel) async throws -> T
}

public final class DefaultNetworkService: NetworkService {
    private let session: URLSession
    public var decoder: JSONDecoder

    public init(session: URLSession, decoder: JSONDecoder = JSONDecoder()) {
        self.session = session
        self.decoder = decoder
    }

    public func fetch<T: Decodable>(from request: RequestModel) -> AnyPublisher<T, NetworkError> {
        let urlRequest = request.urlRequest
        return session.dataTaskPublisher(for: urlRequest)
            .tryMap { output -> Data in
                if let http = output.response as? HTTPURLResponse, !(200 ... 299).contains(http.statusCode) {
                    throw NetworkError.requestFailed(statusCode: http.statusCode)
                } else if output.data.isEmpty {
                    throw NetworkError.emptyData
                }
                return output.data
            }
            .decode(type: T.self, decoder: decoder)
            .mapError {
                if let error = $0 as? URLError, error.code == .notConnectedToInternet {
                    return .noInternet
                } else if let error = $0 as? DecodingError {
                    return .decoding(error: error)
                }
                return $0 as? NetworkError ?? .transport(error: $0)
            }
            .handleEvents(
                receiveSubscription: { _ in
                    print("Request: \(request.httpMethod) \(urlRequest.url?.absoluteString ?? "")")
                }, receiveOutput: {
                    print("Response: \($0)")
                }, receiveCompletion: {
                    switch $0 {
                    case .finished:
                        print("Response Arrived")
                    case let .failure(error):
                        print("Error: \(error.localizedDescription)")
                    }
                }
            )
            .eraseToAnyPublisher()
    }

    public func fetch<T: Decodable>(from request: RequestModel) async throws -> T {
        let (data, response) = try await session.data(for: request.urlRequest)
        if let http = response as? HTTPURLResponse, !(200 ... 299).contains(http.statusCode) {
            throw NetworkError.requestFailed(statusCode: http.statusCode)
        } else if data.isEmpty {
            throw NetworkError.emptyData
        }

        do {
            return try decoder.decode(T.self, from: data)
        } catch let error as DecodingError {
            throw NetworkError.decoding(error: error)
        } catch {
            throw NetworkError.transport(error: error)
        }

    }
}
