//
//  Gradient+Extension.swift
//  TrendingCoinsApp
//
//  Created by Владислав on 23.01.2024.
//

import UIKit

extension UIView {
    func applyRadialGradients() {
            // Очистка предыдущих слоёв
            layer.sublayers?.filter { $0 is CAGradientLayer || $0.name == "overlayLayer" }.forEach { $0.removeFromSuperlayer() }

            // Добавление градиентных слоёв
            addGradientLayer(colors: [UIColor(red: 0.88, green: 0.2, blue: 0.99, alpha: 1).cgColor, UIColor.clear.cgColor], center: CGPoint(x: bounds.maxX, y: bounds.maxY), radius: bounds.width)
            addGradientLayer(colors: [UIColor(red: 0.99, green: 0.47, blue: 0.2, alpha: 1).cgColor, UIColor.clear.cgColor], center: CGPoint(x: bounds.minX, y: bounds.midY), radius: bounds.width)
            addGradientLayer(colors: [UIColor(red: 0.2, green: 0.28, blue: 0.99, alpha: 1).cgColor, UIColor.clear.cgColor], center: CGPoint(x: bounds.maxX, y: bounds.minY), radius: bounds.width)

            // Добавление затемняющего слоя
            let overlayLayer = CALayer()
            overlayLayer.name = "overlayLayer"
            overlayLayer.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8).cgColor
            overlayLayer.frame = bounds
            layer.addSublayer(overlayLayer)
        }

        private func addGradientLayer(colors: [CGColor], center: CGPoint, radius: CGFloat) {
            let gradientLayer = createRadialGradientLayer(colors: colors, center: center, radius: radius)
            layer.addSublayer(gradientLayer)
        }

        private func createRadialGradientLayer(colors: [CGColor], center: CGPoint, radius: CGFloat) -> CAGradientLayer {
            let gradientLayer = CAGradientLayer()
            gradientLayer.type = .radial
            gradientLayer.colors = colors
            gradientLayer.locations = [0, 1]
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1, y: 1)
            gradientLayer.bounds = CGRect(x: 0, y: 0, width: radius * 2, height: radius * 2)
            gradientLayer.position = center
            gradientLayer.name = "gradientLayer"

            // Оптимизация производительности
            gradientLayer.shouldRasterize = true
            gradientLayer.rasterizationScale = UIScreen.main.scale

            return gradientLayer
        }
}
