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

class CoinView: UIView {
    enum Constants {
        static let idCoinCell: String = "idCoinCell"
    }
    
    weak var delegate: CoinViewDelegate?
    private let refreshControl = UIRefreshControl()
    
    //MARK: - UI
    private lazy var collectionView: UICollectionView = {
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
        setDelegates()
        addRefreshControl()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    private func setDelegates() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func setupViews() {
        backgroundColor = .none
        addSubview(collectionView)
    }
}

//MARK: - setConstraints()
extension CoinView {
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

//MARK: - UICollectionViewDataSource
extension CoinView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cryptos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.idCoinCell, for: indexPath) as? CoinCollectionViewCell else { return UICollectionViewCell() }
        
        let crypto = cryptos[indexPath.row]
        let localizer = Localizer()
        cell.configure(with: crypto, localizer: localizer)
        
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension CoinView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.height / 10 // Высота каждой ячейки равна 1/10 высоты collectionView
        return CGSize(width: collectionView.frame.width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
}

extension CoinView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cryptoViewModel = cryptos[safe: indexPath.row] else { return }
        _ = Localizer().localizedString(for: cryptoViewModel.id)
        delegate?.coinView(self, didSelectCryptoViewModel: cryptoViewModel)
    }
}

//MARK: - RefreshControl
extension CoinView {
    private func addRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }
    
    @objc private func refreshData() {
        delegate?.refreshDataForCoinView(self)
    }
    
    func endRefreshing() {
        refreshControl.endRefreshing()
    }
}
