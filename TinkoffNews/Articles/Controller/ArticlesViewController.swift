//
//  ViewController.swift
//  TinkoffNews
//
//  Created by Рыжков Артем on 15/05/2019.
//  Copyright © 2019 Рыжков Артем. All rights reserved.
//

import UIKit

class ArticlesViewController: UITableViewController {
    
    private var articles = [Article]()
    
    private var pageOffset = 0
    private let pageSize = 20
    
    private var isLoading: Bool = false
    
    private var segueId: String = ""
    
    override func viewDidLoad() {
        // Add Refresh Control
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refresh(_:)), for: UIControl.Event.valueChanged)
    }
    
    @objc func refresh(_: AnyObject) {
        pageOffset = 0
        ArticleNetworkService.getArticles(from: pageOffset, pageSize: pageSize) { (response) in
            self.articles = response.articles
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        }
        print("Refreshing")
    }
    
    private func loadArticles() {
        pageOffset += pageSize
        ArticleNetworkService.getArticles(from: pageOffset, pageSize: pageSize) { (response) in
            self.articles += response.articles
            self.tableView.reloadData()
        }
        isLoading = false
    }
    
    // Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowArticleDetails" {
            if let destinationVC = segue.destination as? ArticleDetailsViewController {
                destinationVC.segueId = "id is \(segueId)"
            }
        }
    }
    
    // TableView methods
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
        segueId = articles[indexPath.row].articleId
        
        articles[indexPath.row].viewsCount += 1
        self.tableView.reloadRows(at: [indexPath], with: .automatic)
        
        
        performSegue(withIdentifier: "ShowArticleDetails", sender: self)
    }

}



