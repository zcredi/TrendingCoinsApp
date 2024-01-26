//
//  Array + Extension.swift
//  TrendingCoinsApp
//
//  Created by Владислав on 26.01.2024.
//

import Foundation

extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
