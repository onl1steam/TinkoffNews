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
        // Если запись есть в БД, берем из нее
        if let articleText = CoreDataManager.shared.getArticleTextBySlug(urlSlug: urlSlug) {
            if articleText != "" {
                articleDetailsView.attributedText = articleText.html2AttributedString
                self.loadingIndicator.stopAnimating()
                self.loadingIndicator.isHidden = true
                return
            }
        }
        // Если нет в БД, грузим с сервера и сохраняем в БД
        ArticleDetailsNetworkService.getArticleDetails(for: urlSlug) { (response) in
            CoreDataManager.shared.saveArticleText(urlSlug: self.urlSlug, articleText: response.articleText)
            self.articleDetailsView.attributedText = response.articleText.html2AttributedString
            
            self.loadingIndicator.stopAnimating()
            self.loadingIndicator.isHidden = true
        }
    }
}

// Перевод HTML разметки в читаемый вид

extension Data {
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: self, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print(error)
            return  nil
        }
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}

extension String {
    var html2AttributedString: NSAttributedString? {
        return Data(utf8).html2AttributedString
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}
