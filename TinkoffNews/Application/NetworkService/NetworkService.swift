//
//  NetworkService.swift
//  TinkoffNews
//
//  Created by Рыжков Артем on 15/05/2019.
//  Copyright © 2019 Рыжков Артем. All rights reserved.
//

import Foundation

class NetworkService {
    
    private init() {}
    
    static let shared = NetworkService()
    
    public func getArticles(url: URL, completion: @escaping(Any) -> ()) {
        let session = URLSession.shared
        
        session.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            do {
                // options []
                let loadedData = try JSONSerialization.jsonObject(with: data, options: []) as! [String: AnyObject]
                let response = loadedData["response"] as! [String: AnyObject]
                let json = response["news"]!
                DispatchQueue.main.async {
                    completion(json)
                }
            } catch {
                print(error)
            }
        }.resume()
    }
    
    // TODO: Article get function
    public func getArticleInfo() {
        
    }
}
