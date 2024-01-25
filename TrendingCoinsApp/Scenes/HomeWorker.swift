//
//  HomeWorker.swift
//  TrendingCoinsApp
//
//  Created by Владислав on 23.01.2024.
//

import Foundation

protocol HomeWorkerProtocol {
    func fetchData(completion: @escaping (Result<CryptoData, NetworkManagerError>) -> Void)
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
}
