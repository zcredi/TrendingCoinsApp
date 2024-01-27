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

final class DefaultSceneFactory: SceneFactory {
    func makeHomeScene() -> UIViewController {
        let viewController = HomeViewController()
        let interactor = HomeInteractor()
        let presenter = HomePresenter()
        let router = HomeRouter()
        
        let networkManager = NetworkService()
        let worker = HomeWorker(networkService: networkManager)

        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        router.viewController = viewController
        interactor.worker = worker
        presenter.viewController = viewController

        return viewController
    }
}
