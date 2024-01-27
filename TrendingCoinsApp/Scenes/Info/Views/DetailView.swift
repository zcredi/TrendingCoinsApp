//
//  DetailView.swift
//  TrendingCoinsApp
//
//  Created by Владислав on 26.01.2024.
//

import UIKit

final class DetailView: UIView {
    enum Constants {
        static let priceAndChangeStackViewTopSpacing: CGFloat = 20
        static let priceAndChangeStackViewLeadingSpacing: CGFloat = 20
        static let priceAndChangeStackViewTrailingSpacing: CGFloat = 98
        static let threeStackViewTopSpacing: CGFloat = 20
        static let threeStackViewSideSpacing: CGFloat = 20
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
        guard let viewModel = viewModel else { return }
        
        priceLabel.text = formatLargeNumber(viewModel.priceUsd)
        changeLabel.text = formatLargeNumber(viewModel.changePercent24Hr)
        changeLabel.textColor = viewModel.changePercent24HrColor
        
        marketCapUsdLabel.text = formatLargeNumber(viewModel.marketCapUsd)
        supplyUsdLabel.text = formatLargeNumber(viewModel.supply)
        volumeUsdLabel.text = formatLargeNumber(viewModel.volumeUsd24Hr)
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
        threeStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            priceAndChangeStackView.topAnchor.constraint(equalTo: topAnchor, constant: Constants.priceAndChangeStackViewTopSpacing),
            priceAndChangeStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.priceAndChangeStackViewLeadingSpacing),
            priceAndChangeStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.priceAndChangeStackViewTrailingSpacing),
            
            threeStackView.topAnchor.constraint(equalTo: priceAndChangeStackView.bottomAnchor, constant: Constants.threeStackViewTopSpacing),
            threeStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.threeStackViewSideSpacing),
            threeStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.threeStackViewSideSpacing)
        ])
        
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

//MARK: - Collection
private extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

//MARK: - formatLargeNumber
private extension DetailView {
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
