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
        worker?.fetchData(headers: nil) { [weak self] result in
            switch result {
            case .success(let data):
                self?.presenter?.presentFetchedCryptoData(data)
            case .failure(let error):
                self?.presenter?.presentError(error)
            }
        }
    }
    
    func performSearch() {
            // Логика поиска или переход к экрану поиска
        }
}
