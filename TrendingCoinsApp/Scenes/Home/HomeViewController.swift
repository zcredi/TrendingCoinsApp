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

final class HomeViewController: UIViewController, HomeDisplayLogic, UISearchBarDelegate {
    enum Constants {
        static let coinViewTopSpacing: CGFloat = 14.0
    }
    
    var interactor: HomeBusinessLogic?
    var coinView = CoinView()
    private let searchBar = UISearchBar()
    
    private var cryptoViewModels: [CryptoViewModel] = []
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.applyRadialGradients()
        setupNavigationBar()
        setupViews()
        setConstraints()
        fetchCryptoData()
        setupSearchBar()
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
        if navigationItem.titleView == searchBar {
               hideSearchBar()
           } else {
               setupSearchBar()
           }
    }
    
    private func hideSearchBar() {
        setupNavigationBar()
           navigationItem.titleView = nil
           searchBar.text = ""
           searchBar.resignFirstResponder()
           fetchCryptoData()
       }
    
    func fetchCryptoData() {
        interactor?.fetchCryptoData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            hideSearchBar()
        }
    
    private func setupSearchBar() {
        searchBar.delegate = self
            searchBar.placeholder = "Search"
            searchBar.sizeToFit()
            searchBar.isTranslucent = false
            searchBar.setShowsCancelButton(true, animated: true)

            if let textField = searchBar.value(forKey: "searchField") as? UITextField {
                textField.textColor = .white
                textField.backgroundColor = .darkGray
                textField.attributedPlaceholder = NSAttributedString(string: "Search", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
                textField.tintColor = .white
            }

            // Скрыть заголовок и кнопки навигационной панели, когда появляется поиск
            navigationItem.titleView = searchBar
            navigationItem.leftBarButtonItem = nil
            navigationItem.rightBarButtonItem = nil
            searchBar.showsCancelButton = true
            searchBar.becomeFirstResponder()
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
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        interactor?.performSearch(with: searchText)
    }
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
