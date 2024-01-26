//
//  CoinCollectionViewCell.swift
//  TrendingCoinsApp
//
//  Created by Владислав on 24.01.2024.
//

import UIKit

class CoinCollectionViewCell: UICollectionViewCell {
    enum Constants {
        static let coinImageViewTopSpacing: CGFloat = 12.0
        static let coinImageViewLeadingSpacing: CGFloat = 20.0
        static let coinNameLabelTopSpacing: CGFloat = 16.0
        static let coinNameLabelLeadingSpacing: CGFloat = 10.0
        static let coinSymbolLabelTopSpacing: CGFloat = 2.0
        static let coinSymbolLabelLeadingSpacing: CGFloat = 10.0
        static let priceUsdLabelTopSpacing: CGFloat = 16.0
        static let priceUsdLabelTrailingSpacing: CGFloat = 20.0
        static let changePercent24HrLabelTopSpacing: CGFloat = 2.0
        static let changePercent24HrLabelTrailingSpacing: CGFloat = 20.0
    }
    
    //MARK: - UI
    
    private let coinImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "coin")
        imageView.layer.cornerRadius = 12
        return imageView
    }()
    
    private let coinNameLabel = UILabel(text: "Bitcoin", font: .SFProRegular16(), textColor: .white)
    
    private let coinSymbolLabel = UILabel(text: "BTC", font: .SFProRegular14(), textColor: UIColor(white: 1.0, alpha: 0.5))
    
    private let priceUsdLabel = UILabel(text: "$ 22 678.48", font: .SFProRegular16(), textColor: .white)
    
    private let changePercent24HrLabel = UILabel(text: "+ 4.32%", font: .SFProRegular14(), textColor: .green)
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(coinImageView)
        addSubview(coinNameLabel)
        addSubview(coinSymbolLabel)
        addSubview(priceUsdLabel)
        addSubview(changePercent24HrLabel)
    }
    
    func configure(with viewModel: CryptoViewModel, localizer: Localizing) {
        coinNameLabel.text = localizer.localizedString(for: viewModel.id)
        coinSymbolLabel.text = viewModel.symbol
        priceUsdLabel.text = viewModel.priceUsd
        changePercent24HrLabel.text = viewModel.changePercent24Hr
        updateChangePercentLabelColor()

        if let iconUrl = viewModel.iconUrl {
            DispatchQueue.global().async {
                if let url = URL(string: iconUrl), let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                    let resizedImage = self.resizeImage(image, targetSize: CGSize(width: 48, height: 48))
                    DispatchQueue.main.async {
                        self.coinImageView.image = resizedImage
                    }
                }
            }
        }
    }
    
    private func resizeImage(_ image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size

        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height

        // Определяем какое соотношение меньше, чтобы масштабировать изображение пропорционально
        let ratio = min(widthRatio, heightRatio)
        let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)

        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

        // Масштабируем изображение
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage ?? image
    }
    
    private func updateChangePercentLabelColor() {
        if let changePercentText = changePercent24HrLabel.text,
           let changePercent = Double(changePercentText.replacingOccurrences(of: "%", with: "")) {
            
            let formattedText: String
            if changePercent > 0 {
                formattedText = String(format: "+%.2f%%", changePercent)
                changePercent24HrLabel.textColor = .green
            } else if changePercent < 0 {
                formattedText = String(format: "%.2f%%", changePercent)
                changePercent24HrLabel.textColor = .red
            } else {
                formattedText = "0.00%"
                changePercent24HrLabel.textColor = .gray
            }
            
            changePercent24HrLabel.text = formattedText
        }
    }
}

//MARK: - setConstraints()
extension CoinCollectionViewCell {
    private func setConstraints() {
        coinImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            coinImageView.topAnchor.constraint(equalTo: topAnchor, constant: Constants.coinImageViewTopSpacing),
            coinImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.coinImageViewLeadingSpacing),
            coinImageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        coinNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            coinNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: Constants.coinNameLabelTopSpacing),
            coinNameLabel.leadingAnchor.constraint(equalTo: coinImageView.trailingAnchor, constant: Constants.coinNameLabelLeadingSpacing)
        ])
        
        coinSymbolLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            coinSymbolLabel.topAnchor.constraint(equalTo: coinNameLabel.bottomAnchor, constant: Constants.coinSymbolLabelTopSpacing),
            coinSymbolLabel.leadingAnchor.constraint(equalTo: coinImageView.trailingAnchor, constant: Constants.coinSymbolLabelLeadingSpacing)
        ])
        
        priceUsdLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            priceUsdLabel.topAnchor.constraint(equalTo: topAnchor, constant: Constants.priceUsdLabelTopSpacing),
            priceUsdLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.priceUsdLabelTrailingSpacing)
        ])
        
        changePercent24HrLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            changePercent24HrLabel.topAnchor.constraint(equalTo: priceUsdLabel.bottomAnchor, constant: Constants.changePercent24HrLabelTopSpacing),
            changePercent24HrLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.changePercent24HrLabelTrailingSpacing)
        ])
    }
}
