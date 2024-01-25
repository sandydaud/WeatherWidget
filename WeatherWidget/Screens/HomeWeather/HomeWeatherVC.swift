//
//  HomeWeatherVC.swift
//  WeatherWidget
//
//  Created by Daud Sandy Christianto on 11/01/24.
//

import Foundation
import UIKit
import WidgetKit

class HomeWeatherVC: UIViewController {
    // MARK: variables
    var viewModel: HomeWeatherViewModel?
    private var collectionView: UICollectionView?
    private var changeBackgroundButton: UIButton?
    private var removeBackgroundButton: UIButton?
    private var errorLabel: UILabel?
    
    private let screenSize = UIScreen.main.bounds.size
    private let widgetSizes: [WidgetSize] = [
        SMALL_WIDGET_SIZE,
        MEDIUM_WIDGET_SIZE,
        LARGE_WIDGET_SIZE
    ]
    
    var pageControl : UIPageControl?
    
    // MARK: controllers
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .lightSand()
        setupNavigationBar()
        setupCollectionView()
        configurePageControl()
        setupChangeBackgroundButton()
        setupRemoveBackgroundButton()
        setupLocationLabel()
        
        viewModel = HomeWeatherViewModel(model: HomeWeatherModel())
        viewModel?.delegate = self
    }
    
    func onWeatherUpdated() {
        errorLabel?.isHidden = isHideErrorText()
        collectionView?.reloadData()
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Weather Widget"
        navigationController?.navigationBar.barTintColor = .white
        
        // add refresh button
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshAction(_:)))
        navigationItem.rightBarButtonItem = refreshButton
    }
    
    private func setupCollectionView() {
        let screenBounds = UIScreen.main.bounds
        let collectionViewHeight = screenBounds.height / 2 - 80
        
        let window = UIApplication.shared.windows.first
        let topSafeAreaInset = window?.safeAreaInsets.top ?? 0.0
        let navbarHeight = navigationController?.navigationBar.frame.height ?? 0
        let cvYPoisition = topSafeAreaInset + navbarHeight
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: screenBounds.width, height: collectionViewHeight-40)
        
        collectionView = UICollectionView(
            frame: CGRect(x: 0, y: cvYPoisition, width: screenBounds.width, height: collectionViewHeight),
            collectionViewLayout: layout
        )
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.translatesAutoresizingMaskIntoConstraints = false
        collectionView?.isPagingEnabled = true
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.backgroundColor = .clear
        collectionView?.register(WidgetCell.self, forCellWithReuseIdentifier: WidgetCell.identifier)
        
        view.addSubview(collectionView ?? UICollectionView())
    }
    
    private func configurePageControl() {
        pageControl = UIPageControl()
        pageControl?.numberOfPages = widgetSizes.count
        pageControl?.currentPage = 0
        pageControl?.pageIndicatorTintColor = .lightGray
        pageControl?.currentPageIndicatorTintColor = .black
        
        guard let pageControl = pageControl else {
            return
        }
        
        view.addSubview(pageControl)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pageControl.heightAnchor.constraint(equalToConstant: 40),
            pageControl.widthAnchor.constraint(equalToConstant: screenSize.width),
            pageControl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -(screenSize.height - 16) / 2)
        ])
    }
    
    @objc func refreshAction(_ sender: UIBarButtonItem) {
        viewModel?.requestLocationPermission() { isPermissionGiven in
            self.errorLabel?.isHidden = self.isHideErrorText()
            self.errorLabel?.text = self.viewModel?.model.errorText ?? ""
        }
    }
    
    private func setupChangeBackgroundButton() {
        changeBackgroundButton = ActionButton().createButton(
            title: "Change Background",
            icon: UIImage(named: "ImageIcon"),
            backgroundColor: .accentGreen(),
            action: #selector(changeBackground)
        )
        
        guard let button = changeBackgroundButton, let pageControl = pageControl else { return }
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.topAnchor.constraint(equalTo: pageControl.bottomAnchor, constant: 8)
        ])
    }
    
    private func setupRemoveBackgroundButton() {
        removeBackgroundButton = ActionButton().createButton(
            title: "Remove Background",
            icon: UIImage(named: "DeleteIcon"),
            backgroundColor: .kingCrimson(),
            action: #selector(removeBackground)
        )
        
        guard let button = removeBackgroundButton, let changeBackgroundButton = changeBackgroundButton else { return }
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.topAnchor.constraint(equalTo: changeBackgroundButton.bottomAnchor, constant: 8)
        ])
    }
    
    @objc func changeBackground() {
        // Implement the action to change the background here
        viewModel?.navigateToPhotoSelection(vc: self)
    }
    
    @objc func removeBackground() {
        // Implement the action to change the background here
        viewModel?.removeBackground()
    }
    
    private func setupLocationLabel() {
        errorLabel = UILabel()
        if let text = viewModel?.model.errorText {
            errorLabel?.text = text
        }
        errorLabel?.textColor = .black
        errorLabel?.font =  UIFont.italicSystemFont(ofSize: 16)
        errorLabel?.textAlignment = .center
        errorLabel?.numberOfLines = 0
        errorLabel?.translatesAutoresizingMaskIntoConstraints = false
        errorLabel?.isHidden = isHideErrorText()
        errorLabel?.preferredMaxLayoutWidth = WIDTH_SCREEN - 16
        view.addSubview(errorLabel ?? UILabel())
        
        NSLayoutConstraint.activate([
            errorLabel!.topAnchor.constraint(equalTo: removeBackgroundButton!.bottomAnchor, constant: 20),
            errorLabel!.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    private func isHideErrorText() -> Bool {
        if let errorText = viewModel?.model.errorText {
            return errorText.isEmpty
        }
        return true
    }
}

extension HomeWeatherVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return widgetSizes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: WidgetCell.identifier, for: indexPath
        ) as? WidgetCell else {
            fatalError("Unable to dequeue subclassed cell")
        }
        
        let backgroundPhoto = FileManager.readPHAssetImageFromDisk()
        if let weather = viewModel?.model.weatherData,
           let imageData = viewModel?.model.weatherImage {
            
            cell.configure(
                with: widgetSizes[indexPath.item],
                weather: weather,
                image: imageData,
                backgroundPhoto: backgroundPhoto,
                isLoading: viewModel?.model.isLoading ?? false
            )
            return cell
        }
        
        cell.configure(
            with: widgetSizes[indexPath.item],
            weather: WeatherResponse.emptyData(),
            backgroundPhoto: backgroundPhoto,
            isLoading: viewModel?.model.isLoading ?? false
        )
        return cell
    }
}

extension HomeWeatherVC: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl?.currentPage = Int(pageNumber)
    }
}

extension HomeWeatherVC: HomeWeatherViewModelDelegate {
    func updateView() {
        onWeatherUpdated()
        WidgetCenter.shared.reloadAllTimelines()
    }
}

extension UIImage {
    func resize(targetSize: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: targetSize).image { _ in
            draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }
}
