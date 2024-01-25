//
//  HomeInteractor.swift
//  TrendingCoinsApp
//
//  Created by Владислав on 23.01.2024.
//

import Foundation

protocol HomeBusinessLogic {
    func fetchCryptoData()
    func performSearch()
}

final class HomeInteractor: HomeBusinessLogic {
    var presenter: HomePresentationLogic?
    var worker: HomeWorkerProtocol?

    func fetchCryptoData() {
        worker?.fetchData { [weak self] cryptoResult in
            switch cryptoResult {
            case .success(let cryptoData):
                self?.worker?.fetchIcons { iconsResult in
                    switch iconsResult {
                    case .success(let icons):
                        var iconUrls = [String: String]()
                        for icon in icons {
                            iconUrls[icon.assetId.lowercased()] = icon.url
                        }
                        self?.presenter?.presentFetchedCryptoData(cryptoData, iconUrls: iconUrls)
                    case .failure(let error):
                        self?.presenter?.presentError(error)
                    }
                }
            case .failure(let error):
                self?.presenter?.presentError(error)
            }
        }
    }
    
    func performSearch() {
            // Логика поиска или переход к экрану поиска
        }
}
