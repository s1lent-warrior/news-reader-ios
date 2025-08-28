//
//  ArticleDetailViewModel.swift
//  NewsReader
//
//  Created by Muneeb Ahmed Anwar on 28/08/2025.
//

import Combine
import Foundation

final class ArticleDetailViewModel: ObservableObject {
    @Published var article: Article
    @Published var showWebView = false

    init(article: Article) {
        self.article = article
    }
}
