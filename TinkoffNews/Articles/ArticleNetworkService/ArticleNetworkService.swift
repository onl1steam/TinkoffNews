//
//  ArticleNetworkService.swift
//  TinkoffNews
//
//  Created by Рыжков Артем on 15/05/2019.
//  Copyright © 2019 Рыжков Артем. All rights reserved.
//

import Foundation

class ArticleNetworkService {
    private init() {}
    
    // Загрузка данных с сервера 
    static func getArticles(from pageOffset: Int, pageSize: Int, completion: @escaping (Any) -> ()) {
        guard let url = URL(string: "https://cfg.tinkoff.ru/news/public/api/platform/v1/getArticles?pageSize=\(pageSize)&pageOffset=\(pageOffset)") else { return }
        
        
        NetworkService.shared.getArticles(url: url) { (response) in
            if let error = response as? NetworkError {
                completion(error)
            }
            do {
                let response = try GetArticleResponse(json: response)
                completion(response)
            } catch {
                print(error)
                completion(error)
            }
        }
    }
    
}

