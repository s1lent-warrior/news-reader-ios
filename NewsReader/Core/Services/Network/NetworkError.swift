//
//  NetworkError.swift
//  NewsReader
//
//  Created by Muneeb Ahmed Anwar on 27/08/2025.
//

import Foundation

public enum NetworkError: Error, LocalizedError {
    case emptyData
    case noInternet
    case requestFailed(statusCode: Int)
    case decoding(error: DecodingError)
    case transport(error: Error)

    public var errorDescription: String? {
        switch self {
        case .emptyData:
            "Response was empty."
        case .noInternet:
            "The Internet connection appears to be offline."
        case let .requestFailed(statusCode):
            "Request failed with status \(statusCode)."
        case let .decoding(error):
            "Decoding Failed: \(error.localizedDescription)"
        case let .transport(error):
            "Network error: \(error.localizedDescription)"
        }
    }
}
