//
//  Article.swift
//  TinkoffNews
//
//  Created by Рыжков Артем on 15/05/2019.
//  Copyright © 2019 Рыжков Артем. All rights reserved.
//

import Foundation
import CoreData

class Article {
    
    var urlSlug: String = ""
    var title: String = ""
    var viewsCount: Int = 0
    var articleText: String = ""
    
    // Инициализация при получении записей с сервера
    init?(dict: [String: AnyObject]) {
        guard let urlSlug = dict["slug"] as? String,
            let title = dict["title"] as? String else { return nil }
        
        self.urlSlug = urlSlug
        self.title = title
    }
    
    // Инициализация при получении записей из бд
    init?(article: Articles) {
        guard let urlSlug = article.urlSlug,
            let title = article.title,
            let articleText = article.articleText else {return nil}
        let viewsCount = article.viewsCount
        
        self.urlSlug = urlSlug
        self.articleText = articleText
        self.title = title
        self.viewsCount = Int(viewsCount)
    }
    
    func increaseViewsCount() {
        self.viewsCount += 1
        CoreDataManager.shared.updateArticleViewsCount(at: self)
    }
}
