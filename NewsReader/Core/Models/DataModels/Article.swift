//
//  ArticleResponseModel.swift
//  NewsReader
//
//  Created by Muneeb Ahmed Anwar on 27/08/2025.
//


import Foundation

struct Article: Identifiable, Equatable, Hashable {
    let id: Int64
    let title: String
    let byline: String
    let section: String
    let abstract: String
    let url: URL
    let publishedDate: String
    let thumbUrl: URL?
    let heroImageUrl: URL?
}
