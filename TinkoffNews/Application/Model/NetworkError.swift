//
//  NetworkError.swift
//  TinkoffNews
//
//  Created by Рыжков Артем on 15/05/2019.
//  Copyright © 2019 Рыжков Артем. All rights reserved.
//

import UIKit

enum NetworkError: Error {
    case noInternetConnection
    case someErrorOccured
    
    static func getErrorDescription(_ error: NetworkError) -> (String, String) {
        switch error {
        case .noInternetConnection:
            return ("Ошибка сети", "Потеряно соединение с Интернет, проверьте подключение к сети и попробуйте еще раз.")
        case .someErrorOccured:
            return ("Ошибка", "Неизвестная ошибка, попробуйте загрузить данные позже.")
        }
    }
}
