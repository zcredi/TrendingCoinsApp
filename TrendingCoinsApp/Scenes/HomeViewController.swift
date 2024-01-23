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
    var interactor: HomeBusinessLogic?

    // UI-компоненты, например, таблица или коллекция
    // ...

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCryptoData()
    }

    func fetchCryptoData() {
        interactor?.fetchCryptoData()
    }

    // MARK: - HomeDisplayLogic
    func displayFetchedCryptoData(_ viewModel: HomeCryptoDataViewModel) {
        // Обновление UI с данными
    }

    func displayError(_ viewModel: HomeErrorViewModel) {
        // Отображение ошибки
    }

    // Дополнительные методы для настройки UI
    // ...
}
