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
    
    func fetchData<T: Decodable>(
        url: URL,
        completion: @escaping (Result<T, NetworkManagerError>) -> Void
    ) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                completion(.failure(.badData))
                return
            }
            
            do {
                let decodedData = try self.decoder.decode(T.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(.badDecode))
            }
        }.resume()
    }
}
