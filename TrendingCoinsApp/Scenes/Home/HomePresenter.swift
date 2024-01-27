//
//  HomePresenter.swift
//  TrendingCoinsApp
//
//  Created by Владислав on 23.01.2024.
//

import Foundation
import UIKit

protocol HomePresentationLogic {
    func presentFetchedCryptoData(_ data: CryptoData, iconUrls: [String: String])
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
    let changePercent24HrColor: UIColor
    let supply: String
    let marketCapUsd: String
    let volumeUsd24Hr: String
    let iconUrl: String?
}

struct HomeErrorViewModel {
    let message: String
}

final class HomePresenter: HomePresentationLogic {
    
    weak var viewController: HomeDisplayLogic?
    
    func presentFetchedCryptoData(_ data: CryptoData, iconUrls: [String: String]) {
        let cryptoViewModels = data.data.map { crypto in
            let iconUrl = iconUrls[crypto.symbol.lowercased()]
            let changePercentColor = colorForChangePercent(crypto.changePercent24Hr ?? "")
            let formattedChangePercent = formatChangePercent(crypto.changePercent24Hr)
            return CryptoViewModel(
                id: crypto.rank,
                name: crypto.name,
                symbol: crypto.symbol,
                priceUsd: "$ " + (formatDecimalString(crypto.priceUsd) ?? crypto.priceUsd + " USD"),
                changePercent24Hr: formattedChangePercent,
                changePercent24HrColor: changePercentColor,
                supply: crypto.supply,
                marketCapUsd: crypto.marketCapUsd ?? "",
                volumeUsd24Hr: crypto.volumeUsd24Hr ?? "",
                iconUrl: iconUrl
            )
        }
        let viewModel = HomeCryptoDataViewModel(cryptos: cryptoViewModels)
        viewController?.displayFetchedCryptoData(viewModel)
    }
    
    private func colorForChangePercent(_ changePercent: String) -> UIColor {
        guard let value = Double(changePercent.replacingOccurrences(of: "%", with: "")) else { return .gray }
        
        switch value {
        case let x where x > 0:
            return .green
        case let x where x < 0:
            return .red
        default:
            return .gray
        }
    }
    
    func presentError(_ error: NetworkManagerError) {
        let viewModel = HomeErrorViewModel(message: error.localizedDescription)
        viewController?.displayError(viewModel)
    }
    
    private func formatDecimalString(_ string: String) -> String? {
        guard let value = Double(string) else { return nil }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: value))
    }
    
    private func formatChangePercent(_ changePercent: String?) -> String {
        guard let changePercent = changePercent, let value = Double(changePercent) else {
            return "0.00%"
        }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.positivePrefix = formatter.plusSign
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: value / 100)) ?? "\(value)%"
    }
}
