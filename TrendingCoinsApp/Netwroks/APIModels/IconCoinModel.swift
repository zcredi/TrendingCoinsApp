//
//  IconCoinModel.swift
//  TrendingCoinsApp
//
//  Created by Владислав on 25.01.2024.
//

import Foundation

// MARK: - CryptoCurrencyElement
struct CryptoCurrencyElement: Codable {
    let assetId: String
    let url: String
}

typealias CryptoCurrencyIcon = [CryptoCurrencyElement]
