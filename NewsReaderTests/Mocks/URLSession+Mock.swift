//
//  URLSession+Mock.swift
//  NewsReader
//
//  Created by Muneeb Ahmed Anwar on 28/08/2025.
//

import Foundation
@testable import NewsReader

extension URLSession {
    static func makeSession(mockSuccess: Bool) -> URLSession {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        MockURLProtocol.requestHandler = { request in
            guard mockSuccess else {
                throw NetworkError.requestFailed(statusCode: 400)
            }

            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: ["Content-Type":"application/json"]
            )!
            let data = dummyResponse.data(using: .utf8)!
            return (response, data)
        }
        return URLSession(configuration: config)
    }
}

private let dummyResponse: String = """
{
  "status": "OK",
  "copyright": "Copyright (c) 2025 The New York Times Company.  All Rights Reserved.",
  "num_results": 20,
  "results": [
    {
      "uri": "nyt://article/0c101de6-4850-5099-9a46-4d4b84582bf1",
      "url": "https://www.nytimes.com/2025/07/29/style/hypergamy-david-geffen-divorce.html",
      "id": 100000010301388,
      "asset_id": 100000010301388,
      "source": "New York Times",
      "published_date": "2025-07-29",
      "updated": "2025-08-07 00:45:00",
      "section": "Style",
      "subsection": "",
      "nytdsection": "style",
      "adx_keywords": "Online Dating;English Language;Divorce, Separations and Annulments;Suits and Litigation (Civil);Same-Sex Marriage, Civil Unions and Domestic Partnerships;audio-neutral-informative;Geffen, David;Armstrong, David (Dancer)",
      "column": null,
      "byline": "By Jesse McKinley",
      "type": "Article",
      "title": "David Geffen’s Divorce Gives New Meaning to an Old Term",
      "abstract": "Hypergamy? A lawsuit against David Geffen mentions a website where the word — that means dating above your station — is celebrated. But it also carries darker intonations.",
      "des_facet": [
        "Online Dating",
        "English Language",
        "Divorce, Separations and Annulments",
        "Suits and Litigation (Civil)",
        "Same-Sex Marriage, Civil Unions and Domestic Partnerships",
        "audio-neutral-informative"
      ],
      "org_facet": [],
      "per_facet": [
        "Geffen, David",
        "Armstrong, David (Dancer)"
      ],
      "geo_facet": [],
      "media": [
        {
          "type": "image",
          "subtype": "photo",
          "caption": "Former partners David Geffen and David Armstrong, who has also used the name Donovan Michaels.",
          "copyright": "Pascal Le Segretain/Getty Images",
          "approved_for_syndication": 1,
          "media-metadata": [
            {
              "url": "https://static01.nyt.com/images/2025/08/07/multimedia/29ST-HYPERGAMY-hfwv/29ST-HYPERGAMY-hfwv-thumbStandard.jpg",
              "format": "Standard Thumbnail",
              "height": 75,
              "width": 75
            },
            {
              "url": "https://static01.nyt.com/images/2025/08/07/multimedia/29ST-HYPERGAMY-hfwv/29ST-HYPERGAMY-hfwv-mediumThreeByTwo210.jpg",
              "format": "mediumThreeByTwo210",
              "height": 140,
              "width": 210
            },
            {
              "url": "https://static01.nyt.com/images/2025/08/07/multimedia/29ST-HYPERGAMY-hfwv/29ST-HYPERGAMY-hfwv-mediumThreeByTwo440.jpg",
              "format": "mediumThreeByTwo440",
              "height": 293,
              "width": 440
            }
          ]
        }
      ],
      "eta_id": 0
    }
  ]
}
"""
