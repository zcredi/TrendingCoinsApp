//
//  Gradient+Extension.swift
//  TrendingCoinsApp
//
//  Created by Владислав on 23.01.2024.
//

import UIKit

extension UIView {
    func applyRadialGradients() {
        // Удаляем все существующие слои градиента и затемнения
        layer.sublayers?.filter { $0 is CAGradientLayer || $0.name == "overlayLayer" }.forEach { $0.removeFromSuperlayer() }

        // Создаем радиальные градиентные слои с указанными цветами и координатами
        let gradientLayer1 = createRadialGradientLayer(
            colors: [UIColor(red: 0.88, green: 0.2, blue: 0.99, alpha: 1).cgColor, UIColor.clear.cgColor],
            center: CGPoint(x: bounds.maxX, y: bounds.maxY), // Позиция 1
            radius: bounds.width * 1 // Радиус 1
        )

        let gradientLayer2 = createRadialGradientLayer(
            colors: [UIColor(red: 0.99, green: 0.47, blue: 0.2, alpha: 1).cgColor, UIColor.clear.cgColor],
            center: CGPoint(x: bounds.minX, y: bounds.midY), // Позиция 2
            radius: bounds.width * 1 // Радиус 2
        )

        let gradientLayer3 = createRadialGradientLayer(
            colors: [UIColor(red: 0.2, green: 0.28, blue: 0.99, alpha: 1).cgColor, UIColor.clear.cgColor],
            center: CGPoint(x: bounds.size.width * -0.5, y: bounds.size.height * -0.5), // Позиция 3
            radius: bounds.width * 5 // Радиус 3
        )

        // Добавляем слои градиента в порядке наложения
        layer.insertSublayer(gradientLayer3, at: 0) // Третий цвет
        layer.insertSublayer(gradientLayer2, above: gradientLayer3) // Второй цвет
        layer.insertSublayer(gradientLayer1, above: gradientLayer2) // Первый цвет

        // Добавляем затемняющий слой
        let overlayLayer = CALayer()
        overlayLayer.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8).cgColor
        overlayLayer.frame = bounds
        layer.addSublayer(overlayLayer)
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
        return gradientLayer
    }
}
