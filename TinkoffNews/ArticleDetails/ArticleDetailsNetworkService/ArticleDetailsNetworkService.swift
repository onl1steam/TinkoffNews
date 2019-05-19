//
//  ArticleDetailsNetworkService.swift
//  TinkoffNews
//
//  Created by Рыжков Артем on 16/05/2019.
//  Copyright © 2019 Рыжков Артем. All rights reserved.
//

import Foundation

class ArticleDetailsNetworkService {
    
    private init() {}
    
    // Загрузка текста статьи с сервера
    static func getArticleDetails(for urlSlug: String, completion: @escaping (GetArticleDetailsResponse) -> ()) {
        guard let url = URL(string: "https://cfg.tinkoff.ru/news/public/api/platform/v1/getArticle?urlSlug=\(urlSlug)") else { return }
        
        NetworkService.shared.getArticleDetails(url: url) { (json) in
            do {
                let response = try GetArticleDetailsResponse(json: json)
                completion(response)
            } catch {
                print(error)
            }
        }
    }
}
