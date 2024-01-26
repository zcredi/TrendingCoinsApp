//
//  DetailView.swift
//  TrendingCoinsApp
//
//  Created by Владислав on 26.01.2024.
//

import UIKit

final class DetailView: UIView {
    enum Constants {
        
    }
    
    private var viewModel: CryptoViewModel?
    
    //MARK: - UI
    private let priceLabel = UILabel(text: "$ 22 678.48", font: .systemFont(ofSize: 24), textColor: .white)
    private let changeLabel = UILabel(text: "+ 100.48 (4.32%)", font: .SFProRegular14(), textColor: .green)
    
    private let marketCapLabel = UILabel(text: "Market Cap", font: .SFProRegular12(), textColor: .gray)
    private let marketCapUsdLabel = UILabel(text: "$518.99b", font: .SFProRegular16(), textColor: .white)
    
    private let supplyLabel = UILabel(text: "Supply", font: .SFProRegular12(), textColor: .gray)
    private let supplyUsdLabel = UILabel(text: "19.38m", font: .SFProRegular16(), textColor: .white)
    
    private let volumeLabel = UILabel(text: "Volume 24Hr", font: .SFProRegular12(), textColor: .gray)
    private let volumeUsdLabel = UILabel(text: "$3.52b", font: .SFProRegular16(), textColor: .white)
    
    private var priceAndChangeStackView = UIStackView()
    private var marketCapStackView = UIStackView()
    private var supplyStackView = UIStackView()
    private var volumeStackView = UIStackView()
    private var threeStackView = UIStackView()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViewModel(_ viewModel: CryptoViewModel) {
        self.viewModel = viewModel
        updateUI()
    }
    
    private func updateUI() {
        priceLabel.text = formatLargeNumber(self.viewModel?.priceUsd ?? "")
        marketCapUsdLabel.text = formatLargeNumber(self.viewModel?.marketCapUsd ?? "")
        supplyUsdLabel.text = formatLargeNumber(self.viewModel?.supply ?? "")
        volumeUsdLabel.text = formatLargeNumber(self.viewModel?.volumeUsd24Hr ?? "")
        
        if let changePercent = Double(self.viewModel?.changePercent24Hr ?? "") {
            changeLabel.text = formatChangePercentage(changePercent)
            changeLabel.textColor = colorForChangePercentage(changePercent)
        } else {
            changeLabel.text = "0.00%"
            changeLabel.textColor = .gray
        }
    }
    
    private func setupViews() {
        priceAndChangeStackView = UIStackView(arrangedSubviews: [priceLabel, changeLabel],
                                              axis: .horizontal,
                                              spacing: 0)
        priceAndChangeStackView.distribution = .fillEqually
        priceAndChangeStackView.alignment = .center
        
        
        marketCapStackView = UIStackView(arrangedSubviews: [marketCapLabel, marketCapUsdLabel],
                                         axis: .vertical,
                                         spacing: 2)
        
        supplyStackView = UIStackView(arrangedSubviews: [supplyLabel, supplyUsdLabel],
                                      axis: .vertical,
                                      spacing: 2)
        
        volumeStackView = UIStackView(arrangedSubviews: [volumeLabel, volumeUsdLabel],
                                      axis: .vertical,
                                      spacing: 2)
        
        let divider1 = createDivider()
        let divider2 = createDivider()
        
        threeStackView = UIStackView(arrangedSubviews: [marketCapStackView, divider1, supplyStackView, divider2, volumeStackView],
                                     axis: .horizontal,
                                     spacing: 10)
        threeStackView.distribution = .equalSpacing
        threeStackView.alignment = .center
        
        threeStackView.insertArrangedSubview(divider1, at: 1)
        threeStackView.insertArrangedSubview(divider2, at: 3)
        
        addSubview(priceAndChangeStackView)
        addSubview(threeStackView)
    }
    
    private func createDivider() -> UIView {
        let divider = UIView()
        divider.backgroundColor = .white
        divider.translatesAutoresizingMaskIntoConstraints = false
        return divider
    }
}

//MARK: - setConstraints()
extension DetailView {
    private func setConstraints() {
        priceAndChangeStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            priceAndChangeStackView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            priceAndChangeStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            priceAndChangeStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -98)
        ])
        
        threeStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            threeStackView.topAnchor.constraint(equalTo: priceAndChangeStackView.bottomAnchor, constant: 20),
            threeStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            threeStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
        ])
        
        // Activate constraints for the dividers
        if let divider1 = threeStackView.arrangedSubviews[safe: 1],
           let divider2 = threeStackView.arrangedSubviews[safe: 3] {
            NSLayoutConstraint.activate([
                divider1.widthAnchor.constraint(equalToConstant: 1 / UIScreen.main.scale),
                divider1.heightAnchor.constraint(equalTo: threeStackView.heightAnchor, multiplier: 0.5),
                divider2.widthAnchor.constraint(equalToConstant: 1 / UIScreen.main.scale),
                divider2.heightAnchor.constraint(equalTo: threeStackView.heightAnchor, multiplier: 0.5),
            ])
        }
    }
}

private extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

extension DetailView {
    func formatLargeNumber(_ numberString: String) -> String {
        guard let number = Double(numberString) else { return numberString }
        
        let billion = 1_000_000_000.0
        let million = 1_000_000.0
        let thousand = 1_000.0
        
        switch number {
        case billion...:
            return String(format: "$%.2fb", number / billion)
        case million...:
            return String(format: "$%.2fm", number / million)
        case thousand...:
            return String(format: "$%.2fk", number / thousand)
        default:
            return String(format: "$%.2f", number)
        }
    }
}

extension DetailView {
    private func formatChangePercentage(_ changePercent: Double) -> String {
        return String(format: changePercent > 0 ? "+%.2f%%" : "%.2f%%", changePercent)
    }
    
    private func colorForChangePercentage(_ changePercent: Double) -> UIColor {
        if changePercent > 0 {
            return .green
        } else if changePercent < 0 {
            return .red
        } else {
            return .gray
        }
    }
}
