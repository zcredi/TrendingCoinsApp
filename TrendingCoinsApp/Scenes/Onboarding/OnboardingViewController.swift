//
//  OnboardingViewController.swift
//  Movie for todayApp
//
//  Created by Владислав on 25.12.2023.
//

import UIKit

final class OnboardingViewController: UIViewController {
    
    //MARK: Variables & Dependencies
    private var pagers: [UIView] = []
    private var currentSlide = 0
    private var widthAncor: NSLayoutConstraint?
    private let shape = CAShapeLayer()
    private var currentPageIndex: CGFloat = 0
    private var fromValue: CGFloat = 0
    
    //MARK: UI Elements
    let safeAreaBackgroundView = UIView()
    
    lazy var onboardingCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.frame.width, height: view.frame.height)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.delegate = self
        collection.dataSource = self
        collection.register(SliderCell.self, forCellWithReuseIdentifier: String(describing: SliderCell.self))
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.showsHorizontalScrollIndicator = false
        collection.bounces = false
        
        return collection
    }()
    
    lazy var skipButton: UIButton = {
        let button = UIButton()
        button.setTitle("Skip", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.SFProRegular14()
        button.addTarget(self, action: #selector(skipButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var vStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .leading
        stack.spacing = 5
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    lazy var hStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 0
        stack.distribution = .equalSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    lazy var nextButton: UIView = {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(nextSlide))
        
        let nextImage = UIImageView()
        nextImage.image = UIImage(systemName: "chevron.right")
        nextImage.tintColor = .white
        nextImage.contentMode = .scaleAspectFit
        nextImage.translatesAutoresizingMaskIntoConstraints = false
        nextImage.widthAnchor.constraint(equalToConstant: 25).isActive = true
        nextImage.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        let button = UIView()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        button.widthAnchor.constraint(equalToConstant: 60).isActive = true
        button.backgroundColor = .primaryBlueAccent
        button.layer.cornerRadius = 15
        button.isUserInteractionEnabled = true
        
        button.addGestureRecognizer(tapGesture)
        button.addSubview(nextImage)
        
        nextImage.centerXAnchor.constraint(equalTo: button.centerXAnchor).isActive = true
        nextImage.centerYAnchor.constraint(equalTo: button.centerYAnchor).isActive = true
        
        return button
    }()
    
    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setStatusBar()
        setControl()
        setShape()
    }

    
    //MARK: Private Methods
    private func setStatusBar() {
        safeAreaBackgroundView.backgroundColor = UIColor.primaryDark
        safeAreaBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(safeAreaBackgroundView)
        
        NSLayoutConstraint.activate([
            safeAreaBackgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            safeAreaBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            safeAreaBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            safeAreaBackgroundView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
    }
    
    private func setShape() {
        currentPageIndex = CGFloat(1) / CGFloat(sliderData.count)
        
        let viewSize = CGSize(width: 60, height: 60)
        let cornerRadius: CGFloat = 20
        let inset: CGFloat = 5
        
        let expandedRect = CGRect(x: -inset, y: -inset, width: viewSize.width + inset * 2, height: viewSize.height + inset * 2)
        let nextStroke = UIBezierPath(roundedRect: expandedRect, cornerRadius: cornerRadius)
        
        let trackPath = CAShapeLayer()
        trackPath.path = nextStroke.cgPath
        trackPath.fillColor = UIColor.clear.cgColor
        trackPath.lineWidth = 3
        trackPath.strokeColor = UIColor.white.cgColor
        trackPath.opacity = 0.1
        nextButton.layer.addSublayer(trackPath)
        
        shape.path = nextStroke.cgPath
        shape.fillColor = UIColor.clear.cgColor
        shape.strokeColor = UIColor.primaryBlueAccent.cgColor
        shape.lineWidth = 3
        shape.lineCap = .round
        shape.strokeStart = 0
        shape.strokeEnd = 0
        
        nextButton.layer.addSublayer(shape)
    }
    
    private func setControl() {
        view.addSubview(hStack)
        
        let pagerStack = UIStackView()
        pagerStack.axis = .horizontal
        pagerStack.spacing = 5
        pagerStack.alignment = .center
        pagerStack.distribution = .fill
        pagerStack.translatesAutoresizingMaskIntoConstraints = false
        
        for tag in 1...sliderData.count {
            let pager = UIView()
            pager.tag = tag
            pager.translatesAutoresizingMaskIntoConstraints = false
            pager.backgroundColor = .white
            
            pager.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(scrollToSlide(sender: ))))
            
            pager.layer.cornerRadius = 5
            self.pagers.append(pager)
            pagerStack.addArrangedSubview(pager)
        }
        
        vStack.addArrangedSubview(pagerStack)
        vStack.addArrangedSubview(skipButton)
        
        hStack.addArrangedSubview(vStack)
        hStack.addArrangedSubview(nextButton)
        
        NSLayoutConstraint.activate([
            hStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            hStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            hStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
    }
    
    private func setupCollectionView() {
        view.addSubview(onboardingCollectionView)
        
        NSLayoutConstraint.activate([
            onboardingCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            onboardingCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            onboardingCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            onboardingCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    //MARK: ObjC Methods
    @objc func nextSlide() {
        let maxSlide = sliderData.count - 1
        if currentSlide < maxSlide {
            currentSlide += 1
            let indexPath = IndexPath(item: currentSlide, section: 0)
            onboardingCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        } else {
            completeOnboarding()
        }
    }
    
    @objc func scrollToSlide(sender: UIGestureRecognizer) {
        if let index = sender.view?.tag {
            onboardingCollectionView.scrollToItem(at: IndexPath(item: index - 1, section: 0), at: .centeredHorizontally, animated: true)
            currentSlide = index - 1
        }
    }
    
    @objc func skipButtonTapped() {
        completeOnboarding()
    }
    
    @objc func completeOnboarding() {
        UserDefaults.standard.hasCompletedOnboarding = true

        let sceneFactory = DefaultSceneFactory()
        let homeVC = sceneFactory.makeHomeScene()
        if let window = view.window {
            window.rootViewController = UINavigationController(rootViewController: homeVC)
        }
    }
}

//MARK: UICollectionViewDelegate & UICollectionViewDataSource
extension OnboardingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        sliderData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: SliderCell.self), for: indexPath) as? SliderCell {
            cell.contentView.backgroundColor = UIColor.primarySoft
            cell.titleLabel.text = sliderData[indexPath.item].title
            cell.textLabel.text = sliderData[indexPath.item].text
            cell.animationSetup(animationName: sliderData[indexPath.item].animationName)
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        currentSlide = indexPath.item
        
        pagers.forEach { page in
            let tag = page.tag
            let viewTag = indexPath.row + 1 // or item??
            
            page.constraints.forEach { constraints in
                page.removeConstraint(constraints)
            }
            
            if viewTag == tag {
                page.layer.opacity = 1
                widthAncor = page.widthAnchor.constraint(equalToConstant: 30)
            } else {
                page.layer.opacity = 0.5
                widthAncor = page.widthAnchor.constraint(equalToConstant: 10)
            }
            
            widthAncor?.isActive = true
            page.heightAnchor.constraint(equalToConstant: 10).isActive = true
            
        }
        
        let currentIndex = currentPageIndex * CGFloat(indexPath.item + 1)
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = fromValue
        animation.toValue = currentIndex
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        animation.duration = 0.5
        shape.add(animation, forKey: String(describing: animation))
        
        fromValue = currentIndex
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // try this for custom pager scroll
    }
}
