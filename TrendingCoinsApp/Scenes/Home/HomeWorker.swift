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
    func searchForCrypto(searchTerm: String, completion: @escaping (Result<CryptoData, NetworkManagerError>) -> Void)
    func iconUrl(forAssetId assetId: String) -> String?
    func fetchIconsForIds(_ ids: [String], completion: @escaping (Result<[CryptoCurrencyElement], NetworkManagerError>) -> Void)
}

final class HomeWorker: HomeWorkerProtocol {
    
    private let networkService: NetworkService
    private var iconsCache = [String: String]()

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

        networkService.fetchData(url: url) { [weak self] (result: Result<CryptoCurrencyIcon, NetworkManagerError>) in
            switch result {
            case .success(let icons):
                for icon in icons {
                    self?.iconsCache[icon.assetId.lowercased()] = icon.url
                }
                completion(.success(icons))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func iconUrl(forAssetId assetId: String) -> String? {
            return iconsCache[assetId.lowercased()]
        }
    
    func searchForCrypto(searchTerm: String, completion: @escaping (Result<CryptoData, NetworkManagerError>) -> Void) {
        let urlString = "https://api.coincap.io/v2/assets?search=\(searchTerm)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        guard let url = URL(string: urlString ?? "") else {
            completion(.failure(.badRequest))
            return
        }

        networkService.fetchData(url: url, completion: completion)
    }
    
    func fetchIconsForIds(_ ids: [String], completion: @escaping (Result<[CryptoCurrencyElement], NetworkManagerError>) -> Void) {
            // Формируем URL для запроса иконок
            let idsString = ids.joined(separator: ",")
            let urlString = "https://rest.coinapi.io/v1/assets/icons/48?filter_asset_id=\(idsString)&apiKey=88AEEF8B-799C-47BF-AE8F-1EE63FFA9D02"
            guard let url = URL(string: urlString) else {
                completion(.failure(.badRequest))
                return
            }

            // Выполнение запроса
            networkService.fetchData(url: url) { [weak self] (result: Result<[CryptoCurrencyElement], NetworkManagerError>) in
                switch result {
                case .success(let icons):
                    // Обновляем кеш иконок
                    for icon in icons {
                        self?.iconsCache[icon.assetId.lowercased()] = icon.url
                    }
                    completion(.success(icons))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
}
