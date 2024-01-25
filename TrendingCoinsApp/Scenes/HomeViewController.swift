//
//  HomeViewController.swift
//  TrendingCoinsApp
//
//  Created by Владислав on 23.01.2024.
//

import UIKit

protocol HomeDisplayLogic: AnyObject {
    func displayFetchedCryptoData(_ viewModel: HomeCryptoDataViewModel)
    func displayError(_ viewModel: HomeErrorViewModel)
}

final class HomeViewController: UIViewController, HomeDisplayLogic {
    enum Constants {
        static let coinViewTopSpacing: CGFloat = 14.0
    }
    
    var interactor: HomeBusinessLogic?
    var coinView = CoinView()
    
    private var cryptoViewModels: [CryptoViewModel] = []
    
    // UI-компоненты, например, таблица или коллекция
    // ...
    
    //    override func viewDidLayoutSubviews() {
    //            super.viewDidLayoutSubviews()
    //            view.updateGradientFrames()
    //        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.applyRadialGradients()
        setupNavigationBar()
        setupViews()
        setConstraints()
        fetchCryptoData()
    }
    
    private func setupViews() {
        view.addSubview(coinView)
        
    }
    
    private func setupNavigationBar() {
        let customTitleLabel = UILabel()
            customTitleLabel.text = "Trending Coins"
            customTitleLabel.textColor = .white
            customTitleLabel.font = UIFont.SFProSemiBold24() ?? UIFont.systemFont(ofSize: 24, weight: .semibold)
            customTitleLabel.textAlignment = .left
            customTitleLabel.sizeToFit()

            let leftItem = UIBarButtonItem(customView: customTitleLabel)
            navigationItem.leftBarButtonItem = leftItem

            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(searchButtonTapped))
            navigationItem.rightBarButtonItem?.tintColor = .white
    }
    
    @objc private func searchButtonTapped() {
        interactor?.performSearch()
    }
    
    func fetchCryptoData() {
        interactor?.fetchCryptoData()
    }
    
    // MARK: - HomeDisplayLogic
    func displayFetchedCryptoData(_ viewModel: HomeCryptoDataViewModel) {
        cryptoViewModels = viewModel.cryptos
        coinView.cryptos = cryptoViewModels
        coinView.reloadData()
    }
    
    func displayError(_ viewModel: HomeErrorViewModel) {
        // Отображение ошибки
    }
    
    // Дополнительные методы для настройки UI
    // ...
}

//MARK: - setConstraints()
extension HomeViewController {
    private func setConstraints() {
        coinView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            coinView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.coinViewTopSpacing),
            coinView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            coinView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            coinView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
