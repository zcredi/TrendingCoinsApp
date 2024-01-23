//
//  HomePresenter.swift
//  TrendingCoinsApp
//
//  Created by Владислав on 23.01.2024.
//

import Foundation

protocol HomePresentationLogic {
    func presentFetchedCryptoData(_ data: CryptoData)
    func presentError(_ error: NetworkError)
}

struct HomeCryptoDataViewModel {
    // Свойства, представляющие данные для отображения
}

struct HomeErrorViewModel {
    let message: String
}

final class HomePresenter: HomePresentationLogic {
    weak var viewController: HomeDisplayLogic?

    func presentFetchedCryptoData(_ data: CryptoData) {
        let viewModel = HomeCryptoDataViewModel(/* передать данные из CryptoData */)
        viewController?.displayFetchedCryptoData(viewModel)
    }

    func presentError(_ error: NetworkError) {
        let viewModel = HomeErrorViewModel(message: error.localizedDescription)
        viewController?.displayError(viewModel)
    }
}
