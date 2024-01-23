//
//  HomeWorker.swift
//  TrendingCoinsApp
//
//  Created by Владислав on 23.01.2024.
//

import Foundation

protocol HomeWorkerProtocol {
    func fetchData(headers: [String: String]?, completion: @escaping (Result<CryptoData, NetworkError>) -> Void)
}
final class HomeWorker: HomeWorkerProtocol {
    
    let networkService: NetworkProtocol

    init(networkService: NetworkProtocol) {
        self.networkService = networkService
    }

    func fetchData(headers: [String: String]? = nil, completion: @escaping (Result<CryptoData, NetworkError>) -> Void) {
        guard let url = URL(string: "https://api.coincap.io/v2/assets") else {
            completion(.failure(.urlError))
            return
        }
        networkService.fetchData(url: url, headers: headers, completion: completion)
    }
}
