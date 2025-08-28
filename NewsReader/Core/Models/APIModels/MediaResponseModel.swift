//
//  Media.swift
//  NewsReader
//
//  Created by Muneeb Ahmed Anwar on 27/08/2025.
//

import Foundation

struct MediaResponseModel: Codable, Equatable {
    let type: String
    let subtype: String?
    let caption: String?
    let mediaMetadata: [MediaMetadataResponseModel]

    enum CodingKeys: String, CodingKey {
        case type
        case subtype
        case caption
        case mediaMetadata = "media-metadata"
    }
}

struct MediaMetadataResponseModel: Codable, Equatable {
    let url: URL
    let format: String
    let height: Int
    let width: Int
}
