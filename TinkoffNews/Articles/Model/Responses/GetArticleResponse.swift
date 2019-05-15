//
//  GetArticleResponse.swift
//  TinkoffNews
//
//  Created by Рыжков Артем on 15/05/2019.
//  Copyright © 2019 Рыжков Артем. All rights reserved.
//

import Foundation

struct GetArticleResponse {
    typealias JSON = [String: AnyObject]
    let articles: [Article]
    
    init(json: Any) throws {
        // JSON serialization
        guard let array = json as? [JSON] else { throw NetworkError.noInternetConnection }
        
        var articles = [Article]()
        for dictionary in array {
            guard let article = Article(dict: dictionary) else { continue }
            articles.append(article)
        }
        self.articles = articles
    }
}
