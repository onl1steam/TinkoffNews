//
//  ArticleDetailsViewController.swift
//  TinkoffNews
//
//  Created by Рыжков Артем on 16/05/2019.
//  Copyright © 2019 Рыжков Артем. All rights reserved.
//

import UIKit

class ArticleDetailsViewController: UIViewController {
    
    var segueId: String = ""
    @IBOutlet weak var idLabel: UILabel!

    override func viewDidLoad() {
        idLabel.text = segueId
    }
}
