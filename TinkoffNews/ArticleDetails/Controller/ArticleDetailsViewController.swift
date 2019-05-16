//
//  ArticleDetailsViewController.swift
//  TinkoffNews
//
//  Created by Рыжков Артем on 16/05/2019.
//  Copyright © 2019 Рыжков Артем. All rights reserved.
//

import UIKit

class ArticleDetailsViewController: UIViewController {
    
    var urlSlug: String = ""
    
    @IBOutlet weak var articleDetailsView: UITextView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        loadingIndicator.startAnimating()
        ArticleDetailsNetworkService.getArticleDetails(for: urlSlug) { (response) in
            self.articleDetailsView.text = response.articleText
            self.loadingIndicator.stopAnimating()
            self.loadingIndicator.isHidden = true
        }
    }
}
