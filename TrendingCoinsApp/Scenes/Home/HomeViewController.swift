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
    var router: HomeRoutingLogic?
    
    var coinView = CoinView()
    var searchDelay: Timer?
    
    private let searchBar = UISearchBar()
    
    private var cryptoViewModels: [CryptoViewModel] = []
    
    //MARK: - UI
    private let searchView = UIView(cornerRadius: 12)
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.applyRadialGradients()
        setupNavigationBar()
        setupViews()
        setConstraints()
        fetchCryptoData()
        setDelegates()
    }
    
    private func setupViews() {
        view.addSubview(coinView)
    }
    
    private func setDelegates() {
        coinView.collectionView.delegate = self
        coinView.collectionView.dataSource = self
        coinView.delegate = self
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
        
        if let cancelButton = searchBar.value(forKey: "cancelButton") as? UIButton {
            cancelButton.setTitleColor(.white, for: .normal)
        }
        
        // Скрыть заголовок и кнопки навигационной панели, когда появляется поиск
        navigationItem.titleView = searchBar
        navigationItem.leftBarButtonItem = nil
        navigationItem.rightBarButtonItem = nil
        searchBar.showsCancelButton = true
        searchBar.becomeFirstResponder()
    }
    
    func fetchCryptoData() {
        interactor?.fetchCryptoData()
        coinView.endRefreshing()
    }
    
    func refreshDataForCoinView(_ coinView: CoinView) {
        fetchCryptoData()
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

extension HomeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchDelay?.invalidate()
        searchDelay = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false, block: { [weak self] _ in
            self?.interactor?.performSearch(with: searchText)
        })
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
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        hideSearchBar()
    }
}

//MARK: - UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cryptoViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CoinView.Constants.idCoinCell, for: indexPath) as? CoinCollectionViewCell else { return UICollectionViewCell() }
        
        let cryptoViewModel = cryptoViewModels[indexPath.row]
        cell.configure(with: cryptoViewModel, localizer: Localizer())
        cell.changePercent24HrLabel.text = cryptoViewModel.changePercent24Hr
        cell.changePercent24HrLabel.textColor = cryptoViewModel.changePercent24HrColor
        
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.height / 10
        return CGSize(width: collectionView.frame.width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.willDisplay()
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.didEndDisplay()
    }
}

//MARK: - UICollectionViewDelegate
extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cryptoViewModel = cryptoViewModels[safe: indexPath.row] else { return }
        router?.navigateToDetail(with: cryptoViewModel)
    }
}

//MARK: - CoinViewDelegate
extension HomeViewController: CoinViewDelegate {
    func coinView(_ coinView: CoinView, didSelectCryptoViewModel viewModel: CryptoViewModel) {
        let detailVC = DetailViewController()
        detailVC.configure(with: viewModel)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
