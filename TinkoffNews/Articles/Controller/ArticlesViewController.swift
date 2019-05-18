//
//  ViewController.swift
//  TinkoffNews
//
//  Created by Рыжков Артем on 15/05/2019.
//  Copyright © 2019 Рыжков Артем. All rights reserved.
//

import UIKit
import CoreData

class ArticlesViewController: UITableViewController {
    
    private var articles = [Article]()
    
    private var pageOffset = 0
    private let pageSize = 20
    
    private var isLoading: Bool = false
    
    private var urlSlug: String = ""
    
    override func viewDidLoad() {
        // Добавление жеста pull-to-refresh
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refresh(_:)), for: UIControl.Event.valueChanged)
    }
    

    
    // Обновление данных
    @objc func refresh(_: AnyObject) {
        pageOffset = 0
        ArticleNetworkService.getArticles(from: pageOffset, pageSize: pageSize) { (response) in
            if let error = response as? NetworkError {
                self.showErrorAlert(error: error)
                return
            }
            self.articles = (response as? GetArticleResponse)?.articles ?? [Article]()
            self.refreshControl?.endRefreshing()
            self.tableView.reloadData()
            self.saveArticle()
        }
    }
    
    private func loadArticles() {
        pageOffset += pageSize
        ArticleNetworkService.getArticles(from: pageOffset, pageSize: pageSize) { (response) in
            if let _ = response as? NetworkError {
                return
            }
            self.articles += (response as? GetArticleResponse)?.articles ?? [Article]()
            self.tableView.reloadData()
        }
        isLoading = false
    }
    
    // Переход к деталям статьи
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowArticleDetails" {
            if let destinationVC = segue.destination as? ArticleDetailsViewController {
                destinationVC.urlSlug = String(urlSlug)
            }
        }
    }
   
    
    private func showErrorAlert(error: NetworkError) {
        let (title, message) = NetworkError.getErrorDescription(error)
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Повторить", style: .default, handler: { (_) in
            self.refresh(self)
        }))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            
            self.refreshControl?.endRefreshing()
        }))
        self.present(alert, animated: true, completion: nil)
        return
    }
    
    // Сохранение в БД
    
    func saveArticle() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Articles", in: context)
        let articleObject = NSManagedObject(entity: entity!, insertInto: context) as! Articles
        articles.forEach { (article) in
            articleObject.articleText = article.articleText
            articleObject.urlSlug = article.urlSLug
            articleObject.viewsCount = Int32(article.viewsCount)
            articleObject.title = article.title
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
        
        
    }
    
    
    
    // Методы TableView
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ArticleCell
        let article = articles[indexPath.row]
        cell.configure(with: article)
        if indexPath.row == articles.count - 1 {
            if(!isLoading) {
                isLoading = true
                loadArticles()
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count;
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        urlSlug = articles[indexPath.row].urlSLug
        
        articles[indexPath.row].viewsCount += 1
        self.tableView.reloadRows(at: [indexPath], with: .automatic)
        
        performSegue(withIdentifier: "ShowArticleDetails", sender: self)
    }

}



