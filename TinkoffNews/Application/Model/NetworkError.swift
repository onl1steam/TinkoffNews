//
//  NetworkError.swift
//  TinkoffNews
//
//  Created by Рыжков Артем on 15/05/2019.
//  Copyright © 2019 Рыжков Артем. All rights reserved.
//

import UIKit

// Обработка ошибок
enum NetworkError: Error {
    case noInternetConnection
    case errorWhileParsing
    
    static func getErrorDescription(_ error: NetworkError) -> (String, String) {
        switch error {
        case .noInternetConnection:
            return ("Ошибка сети", "Потеряно соединение с Интернет, проверьте подключение к сети и попробуйте еще раз.")
        case .errorWhileParsing:
            return ("Ошибка сети", "Ошибка полученных данных. Попробуйте еще раз.")
        }
    }
}
