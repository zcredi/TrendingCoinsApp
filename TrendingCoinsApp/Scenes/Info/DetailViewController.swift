//
//  DetailViewController.swift
//  TrendingCoinsApp
//
//  Created by Владислав on 25.01.2024.
//

import UIKit

final class DetailViewController: UIViewController {
    enum Constants {
        static let coinViewTopSpacing: CGFloat = 14.0
    }
    
    //MARK: - UI
    private let backButtonView = UIView(cornerRadius: 12)
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        let backButtonImage = UIImage(systemName: "chevron.left")?.withRenderingMode(.alwaysTemplate)
        button.setImage(backButtonImage, for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let detailView = DetailView()
    private let localizer = Localizer()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.applyRadialGradients()
        setupViews()
        setConstraints()
    }
    
    func configure(with viewModel: CryptoViewModel) {
        detailView.setupViewModel(viewModel)
        setupNavigationBar(withTitle: viewModel.name)
    }
    
    private func setupViews() {
        view.addSubview(detailView)
    }
    
    private func setupNavigationBar(withTitle title: String) {
        let titleLabel = UILabel()
        titleLabel.text = Localizer().localizedString(for: title)
        titleLabel.font = UIFont.SFProSemiBold24() ?? UIFont.systemFont(ofSize: 24, weight: .semibold)
        titleLabel.textColor = .white
        
        backButtonView.addSubview(backButton)
        let backButtonBarItem = UIBarButtonItem(customView: backButtonView)
        let titleLabelBarItem = UIBarButtonItem(customView: titleLabel)
        
        navigationItem.leftBarButtonItems = [backButtonBarItem, titleLabelBarItem]
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

//MARK: - setConstraints()
extension DetailViewController {
    private func setConstraints() {
        detailView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            detailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            detailView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            detailView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            detailView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButtonView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: backButtonView.topAnchor),
            backButton.bottomAnchor.constraint(equalTo: backButtonView.bottomAnchor),
            backButton.leadingAnchor.constraint(equalTo: backButtonView.leadingAnchor),
            backButton.trailingAnchor.constraint(equalTo: backButtonView.trailingAnchor),
            backButton.widthAnchor.constraint(equalToConstant: 44),
            backButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
}
