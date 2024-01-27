//
//  CoinView.swift
//  TrendingCoinsApp
//
//  Created by Владислав on 24.01.2024.
//

import UIKit

protocol CoinViewDelegate: AnyObject {
    func coinView(_ coinView: CoinView, didSelectCryptoViewModel viewModel: CryptoViewModel)
    func refreshDataForCoinView(_ coinView: CoinView)
}

final class CoinView: UIView {
    enum Constants {
        static let idCoinCell: String = "idCoinCell"
    }
    
    weak var delegate: CoinViewDelegate?
    private let refreshControl = UIRefreshControl()
    
    //MARK: - UI
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    var cryptos: [CryptoViewModel] = [] {
        didSet {
            reloadData()
        }
    }
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        collectionView.register(CoinCollectionViewCell.self, forCellWithReuseIdentifier: Constants.idCoinCell)
        setupViews()
        setConstraints()
        addRefreshControl()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Обновление коллекции на главном потоке
    func reloadData() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    private func setupViews() {
        backgroundColor = .none
        addSubview(collectionView)
    }
}

//MARK: - setConstraints()
private extension CoinView {
    private func setConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
    }
}

//MARK: - RefreshControl
extension CoinView {
     func addRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }
    
    @objc func refreshData() {
        delegate?.refreshDataForCoinView(self)
    }
    
    func endRefreshing() {
        refreshControl.endRefreshing()
    }
}
