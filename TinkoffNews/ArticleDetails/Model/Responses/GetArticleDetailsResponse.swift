//
//  ArticleDetailsResponse.swift
//  TinkoffNews
//
//  Created by Рыжков Артем on 16/05/2019.
//  Copyright © 2019 Рыжков Артем. All rights reserved.
//

import Foundation

struct GetArticleDetailsResponse {
    typealias JSON = [String: AnyObject]
    let articleText: String
    
    init(json: Any) throws {
        // Сериализация JSON формата
        guard let array = json as? JSON else { throw NetworkError.noInternetConnection }
        
        let articleText = array["text"] as! String
        self.articleText = articleText
    }  
}
