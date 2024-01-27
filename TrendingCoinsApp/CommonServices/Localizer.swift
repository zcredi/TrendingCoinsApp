//
//  Localizer.swift
//  TrendingCoinsApp
//
//  Created by Владислав on 25.01.2024.
//

import Foundation

protocol Localizing {
    func localizedString(for key: String) -> String
}

final class Localizer: Localizing {
    func localizedString(for key: String) -> String {
        return NSLocalizedString(key, comment: "")
    }
}


