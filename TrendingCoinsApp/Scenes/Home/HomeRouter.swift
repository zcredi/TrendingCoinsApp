//
//  HomeRouter.swift
//  TrendingCoinsApp
//
//  Created by Владислав on 27.01.2024.
//

import Foundation

protocol HomeRoutingLogic {
    func navigateToDetail(with viewModel: CryptoViewModel)
}

final class HomeRouter: HomeRoutingLogic {
    weak var viewController: HomeViewController?

    func navigateToDetail(with viewModel: CryptoViewModel) {
        let detailVC = DetailViewController()
        detailVC.configure(with: viewModel)
        viewController?.navigationController?.pushViewController(detailVC, animated: true)
    }
}
