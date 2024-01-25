//
//  HomePresenter.swift
//  TrendingCoinsApp
//
//  Created by Владислав on 23.01.2024.
//

import Foundation

protocol HomePresentationLogic {
    func presentFetchedCryptoData(_ data: CryptoData)
    func presentError(_ error: NetworkManagerError)
}

struct HomeCryptoDataViewModel {
    let cryptos: [CryptoViewModel]
}

struct CryptoViewModel {
    let id: String
    let name: String
    let symbol: String
    let priceUsd: String
    let changePercent24Hr: String
}

struct HomeErrorViewModel {
    let message: String
}

final class HomePresenter: HomePresentationLogic {
    weak var viewController: HomeDisplayLogic?

    func presentFetchedCryptoData(_ data: CryptoData) {
        let cryptoViewModels = data.data.map { crypto in
            CryptoViewModel(
                id: crypto.rank,
                name: crypto.name,
                symbol: crypto.symbol,
                priceUsd: formatDecimalString(crypto.priceUsd) ?? crypto.priceUsd + " USD",
                changePercent24Hr: formatDecimalString(crypto.changePercent24Hr) ?? crypto.changePercent24Hr + "%"
            )
        }
        let viewModel = HomeCryptoDataViewModel(cryptos: cryptoViewModels)
        viewController?.displayFetchedCryptoData(viewModel)
    }

    func presentError(_ error: NetworkManagerError) {
        let viewModel = HomeErrorViewModel(message: error.localizedDescription)
        viewController?.displayError(viewModel)
    }
    
    func formatDecimalString(_ string: String) -> String? {
        guard let value = Double(string) else { return nil }
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: value))
    }
}
