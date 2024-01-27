//
//  UILabel+Extension.swift
//  TrendingCoinsApp
//
//  Created by Владислав on 23.01.2024.
//

import UIKit

extension UILabel {
    convenience init(text: String = "") {
        self.init()
        self.numberOfLines = 0
        self.text = text
        self.font = .SFProRegular16()
        self.textColor = .white
        self.adjustsFontSizeToFitWidth = true
        self.minimumScaleFactor = 0.5
    }
    
    convenience init(text: String? = "", font: UIFont?, textColor: UIColor, numberOfLines: Int = 0) {
        self.init()
        self.numberOfLines = numberOfLines
        self.text = text
        self.font = font
        self.textColor = textColor
    }
}
