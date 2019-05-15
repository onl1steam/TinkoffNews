//
//  Article.swift
//  TinkoffNews
//
//  Created by Рыжков Артем on 15/05/2019.
//  Copyright © 2019 Рыжков Артем. All rights reserved.
//

import Foundation

struct Article {
    
    var articleId: String
    var title: String
    var viewsCount: Int
    var articleText: String
    
    init?(dict: [String: AnyObject]) {
        guard let articleId = dict["id"] as? String,
            let title = dict["title"] as? String else { return nil }
        
        self.articleId = articleId
        self.title = title
        self.viewsCount = 0
        self.articleText = ""
    }
    
    
}
