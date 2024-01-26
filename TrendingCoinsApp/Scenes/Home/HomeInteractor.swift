//
//  HomeInteractor.swift
//  TrendingCoinsApp
//
//  Created by Владислав on 23.01.2024.
//

import Foundation

protocol HomeBusinessLogic {
    func fetchCryptoData()
    func performSearch(with searchTerm: String)
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
    
    func performSearch(with searchTerm: String) {
        if searchTerm.isEmpty {
            fetchCryptoData() // Если строка поиска пуста, загрузить исходные данные.
        } else {
            worker?.searchForCrypto(searchTerm: searchTerm) { [weak self] result in
                switch result {
                case .success(let searchResults):
                    var iconUrls = [String: String]()
                    for crypto in searchResults.data {
                        if let iconUrl = self?.worker?.iconUrl(forAssetId: crypto.symbol) {
                            iconUrls[crypto.symbol.lowercased()] = iconUrl
                        }
                    }
                    self?.presenter?.presentFetchedCryptoData(searchResults, iconUrls: iconUrls)
                case .failure(let error):
                    self?.presenter?.presentError(error)
                }
            }
        }
    }
    
    private func presentSearchResults(_ searchResults: CryptoData) {
        var iconUrls = [String: String]()
        for crypto in searchResults.data {
            if let iconUrl = self.worker?.iconUrl(forAssetId: crypto.symbol) {
                iconUrls[crypto.symbol.lowercased()] = iconUrl
            }
        }
        self.presenter?.presentFetchedCryptoData(searchResults, iconUrls: iconUrls)
    }
    
    private func loadIconsAndPresentSearchResults(_ searchResults: CryptoData, missingIconIds: [String]) {
        worker?.fetchIconsForIds(missingIconIds) { [weak self] iconsResult in
            switch iconsResult {
            case .success(_):
                self?.presentSearchResults(searchResults)
            case .failure(let error):
                self?.presenter?.presentError(error)
            }
        }
    }
}
