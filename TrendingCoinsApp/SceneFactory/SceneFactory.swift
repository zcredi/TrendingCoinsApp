//
//  SceneFactory.swift
//  TrendingCoinsApp
//
//  Created by Владислав on 23.01.2024.
//

import UIKit

public protocol SceneFactory {
    func makeHomeScene() -> UIViewController
}

class DefaultSceneFactory: SceneFactory {
    func makeHomeScene() -> UIViewController {
        let viewController = HomeViewController()
        let interactor = HomeInteractor()
        let presenter = HomePresenter()
        let worker = HomeWorker(networkService: NetworkService())

        viewController.interactor = interactor
        interactor.presenter = presenter
        interactor.worker = worker
        presenter.viewController = viewController

        return viewController
    }
}