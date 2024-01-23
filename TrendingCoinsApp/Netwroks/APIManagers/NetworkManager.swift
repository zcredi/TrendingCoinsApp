//
//  NetworkManager.swift
//  TrendingCoinsApp
//
//  Created by Владислав on 23.01.2024.
//

import Foundation

protocol NetworkProtocol {
    func fetchData<T: Codable>(
        url: URL,
        headers: [String: String]?,
        completion: @escaping (Result<T, NetworkError>) -> Void
    )
}

enum NetworkError: Error, LocalizedError {
    case urlError
    case noData
    case decodingError
    
    var errorDescription: String? {
        switch self {
        case .urlError:
            return "URL формирование ошибки."
        case .noData:
            return "Ответ не содержит данных."
        case .decodingError:
            return "Ошибка декодирования данных."
        }
    }
}

final class NetworkService: NetworkProtocol {
    init() {}
    
    func fetchData<T: Codable>(
        url: URL,
        headers: [String: String]? = nil,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        headers?.forEach { request.addValue($1, forHTTPHeaderField: $0) }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if error != nil {
                    completion(.failure(.urlError))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
                    completion(.failure(.urlError))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(.noData))
                    return
                }
                
                do {
                    let decodedData = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(decodedData))
                } catch {
                    completion(.failure(.decodingError))
                }
            }
        }.resume()
    }
}
