//
//  ArticleCell.swift
//  TinkoffNews
//
//  Created by Рыжков Артем on 15/05/2019.
//  Copyright © 2019 Рыжков Артем. All rights reserved.
//

import UIKit

class ArticleCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!   
    @IBOutlet weak var viewsCountLabel: UILabel!
    
    func configure(with article: Article) {
        titleLabel.text = article.title
        viewsCountLabel.text = String(article.viewsCount)
    }
}

