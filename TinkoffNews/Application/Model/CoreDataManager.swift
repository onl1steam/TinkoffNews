//
//  CoreDataManager.swift
//  TinkoffNews
//
//  Created by Рыжков Артем on 18/05/2019.
//  Copyright © 2019 Рыжков Артем. All rights reserved.
//

import UIKit
import CoreData

class CoreDataManager {
    private init() {
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        articles = [Article]()
    }
    
    static let shared = CoreDataManager()
    var articles: [Article]
    
    
    let appDelegate: AppDelegate
    let context: NSManagedObjectContext
    
    
    // Получение данных и сохранение в бд и временное хранилище
    func deliverArticles(articles: [Article]) {
        self.articles = articles
        CoreDataManager.shared.saveArticles()
    }
    
    // Обновление счетчика просмотров и сохранение
    func updateArticleViewsCount(at article: Article) {
        for item in articles {
            if (item.urlSlug == article.urlSlug) {
                item.viewsCount = article.viewsCount
            }
        }
        CoreDataManager.shared.saveArticles()
    }
    
    // Загрузка количества просмотров из БД
    func updateArticleViewsCountFromDB(for articles: inout [Article]) {
        articles.forEach { (article) in
            if let articleObject = findArticleBySlug(urlSlug: article.urlSlug) {
                article.viewsCount = articleObject.value(forKey: "viewsCount") as! Int
            }
        }
    }
    
    // Сохранение статей в БД
    func saveArticles() {
        let entity = NSEntityDescription.entity(forEntityName: "Articles", in: context)
        
        for article in articles {
            
            // Если запись уже существует только обновляем ее
            if let articleObject = findArticleBySlug(urlSlug: article.urlSlug) {
                articleObject.setValue(article.title, forKey: "title")
                articleObject.setValue(article.articleText, forKey: "articleText")
                articleObject.setValue(article.viewsCount, forKey: "viewsCount")
                continue
            }
            
            // Если нет, то добавляем новую запись в БД
            let newArticle = NSManagedObject(entity: entity!, insertInto: context) as! Articles
            newArticle.setValue(article.title, forKey: "title")
            newArticle.setValue(article.articleText, forKey: "articleText")
            newArticle.setValue(article.urlSlug, forKey: "urlSlug")
            newArticle.setValue(article.viewsCount, forKey: "viewsCount")
        }
        // Сохранение данных
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // Сохранение текста статьи
    func saveArticleText(urlSlug: String, articleText: String) {
        articles.forEach { (article) in
            if article.urlSlug == urlSlug {
                article.articleText = articleText
            }
        }
        CoreDataManager.shared.saveArticles()
    }
    
    // Загрузка данных из бд
    func fetchData() -> [Article] {
        let fetchRequest: NSFetchRequest<Articles> = Articles.fetchRequest()

        do {
            let data = try context.fetch(fetchRequest)
            data.forEach { (articleData) in
                if let article = Article(article: articleData) {
                    articles.append(article)
                }
            }
        } catch {
            print(error.localizedDescription)
        }
        return articles
    }
    
    // Нахождение статьи по значению urlSlug
    func findArticleBySlug(urlSlug: String) -> NSManagedObject? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Articles")
        var resultObject: NSManagedObject? = nil
        do
        {
            let results = try context.fetch(request) as! [NSManagedObject]
            results.forEach { (result) in
                if let slug = result.value(forKey: "urlSlug") as? String {
                    if slug == urlSlug {
                        resultObject = result
                    }
                }
            }
        }
        catch
        {
            print(error.localizedDescription)
        }
        return resultObject
    }
    
    // Поиск текста из статьи по значению urlSlug
    func getArticleTextBySlug(urlSlug: String) -> String? {
        
        var foundInArticles = false
        var resultObject: String? = nil
        
        // Сначала ищем в сохраненных
        articles.forEach { (article) in
            if article.urlSlug == urlSlug {
                if article.articleText != "" {
                    resultObject = article.articleText
                    foundInArticles = true
                }
            }
        }
        
        // После ищем в БД
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Articles")
        if !foundInArticles {
            do
            {
                let results = try context.fetch(request) as! [NSManagedObject]
                results.forEach { (result) in
                    if let slug = result.value(forKey: "urlSlug") as? String {
                        if slug == urlSlug {
                            resultObject = result.value(forKey: "articleText") as? String
                            saveArticleText(urlSlug: slug, articleText: resultObject! )
                        }
                    }
                }
            }
            catch
            {
                print(error.localizedDescription)
            }
        }
        return resultObject
    }
    
    
}
