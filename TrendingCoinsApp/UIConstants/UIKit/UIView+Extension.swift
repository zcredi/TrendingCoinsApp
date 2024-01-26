//
//  UIView+Extension.swift
//  TrendingCoinsApp
//
//  Created by Владислав on 26.01.2024.
//

import UIKit

extension UIView {
    convenience init(cornerRadius: CGFloat = 0, backgroundColor: UIColor? = .clear) {
        self.init(frame: .zero)
        self.clipsToBounds = true
        self.layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.1).cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = cornerRadius
        self.backgroundColor = backgroundColor
    }
}
