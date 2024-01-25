//
//  NetworkManager.swift
//  TrendingCoinsApp
//
//  Created by Владислав on 23.01.2024.
//

import Foundation

protocol NetworkProtocol {
    func fetchData<T: Decodable>(
        url: URL,
        completion: @escaping (Result<T, NetworkManagerError>) -> Void
    )
}

enum NetworkManagerError: Error {
    case badData
       case badResponse
       case badRequest
       case badDecode
       case unknown(String)
}

final class NetworkService: NetworkProtocol {

    private let decoder = JSONDecoder()

    init() {
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }

    // Этот метод получает данные из сети и декодирует их в указанный тип модели
    func fetchData<T: Decodable>(
        url: URL,
        completion: @escaping (Result<T, NetworkManagerError>) -> Void
    ) {
        // Создаем задачу для получения данных
        print("Fetching data from URL: \(url.absoluteString)")
        URLSession.shared.dataTask(with: url) { data, response, error in
            // Проверяем, есть ли ошибка или данные
            guard let data = data, error == nil else {
                print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
                if let error = error as? NetworkManagerError {
                    completion(.failure(error))
                } else {
                    completion(.failure(.unknown(error?.localizedDescription ?? "Unknown error")))
                }
                return
            }

            // Пытаемся декодировать данные
            do {
                let decodedData = try self.decoder.decode(T.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(error as! NetworkManagerError))
            }
        }
        // Запускаем задачу
        .resume()
    }
}


