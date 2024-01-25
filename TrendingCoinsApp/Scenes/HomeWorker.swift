//
//  HomeWorker.swift
//  TrendingCoinsApp
//
//  Created by Владислав on 23.01.2024.
//

import Foundation

protocol HomeWorkerProtocol {
    func fetchData(completion: @escaping (Result<CryptoData, NetworkManagerError>) -> Void)
    func fetchIcons(completion: @escaping (Result<CryptoCurrencyIcon, NetworkManagerError>) -> Void)
}

final class HomeWorker: HomeWorkerProtocol {
    
    private let networkService: NetworkService

    init(networkService: NetworkService) {
        self.networkService = networkService
    }

    func fetchData(completion: @escaping (Result<CryptoData, NetworkManagerError>) -> Void) {
        guard let url = URL(string: "https://api.coincap.io/v2/assets") else {
            completion(.failure(.badRequest))
            return
        }

        networkService.fetchData(url: url, completion: completion) 
    }
    
    func fetchIcons(completion: @escaping (Result<CryptoCurrencyIcon, NetworkManagerError>) -> Void) {
        guard let url = URL(string: "https://rest.coinapi.io/v1/assets/icons/48?apiKey=88AEEF8B-799C-47BF-AE8F-1EE63FFA9D02") else {
            completion(.failure(.badRequest))
            return
        }

        networkService.fetchData(url: url) { (result: Result<CryptoCurrencyIcon, NetworkManagerError>) in
                print("Fetch Icons Result: \(result)")
                completion(result)
            }
    }
}
