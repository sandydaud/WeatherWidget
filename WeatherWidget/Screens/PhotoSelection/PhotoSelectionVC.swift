//
//  PhotoSelectionVC.swift
//  WeatherWidget
//
//  Created by Daud Sandy Christianto on 19/01/24.
//

import Foundation
import UIKit
import Photos

class PhotoSelectionVC: UIViewController {
    var viewModel: PhotoSelectionViewModel?
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 2
        
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(PhotoCVC.self, forCellWithReuseIdentifier: "PhotoCVC")
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupUI()
        checkPhotoLibraryPermission()
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "All Photos"
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped))
        navigationItem.leftBarButtonItem = cancelButton
        
        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .white
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
        } else {
            navigationController?.navigationBar.isTranslucent = false
        }
        
    }
    
    @objc func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    func checkPhotoLibraryPermission() {
        let status = PHPhotoLibrary.authorizationStatus()
        
        switch status {
        case .authorized, .limited:
            viewModel?.fetchPhotos()
            collectionView.reloadData()
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { [weak self] status in
                guard let ws = self else { return }
                
                if status == .authorized {
                    ws.viewModel?.fetchPhotos()
                    DispatchQueue.main.async {
                        ws.collectionView.reloadData()
                    }
                } else {
                    print("Access to photo library denied or restricted.")
                }
            }
        case .denied, .restricted:
            print("Access to photo library denied or restricted.")
        @unknown default:
            fatalError("Unhandled case")
        }
    }
    
    func setupUI() {
        view.addSubview(collectionView)
        
        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: guide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}

extension PhotoSelectionVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.model.photos.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCVC", for: indexPath) as? PhotoCVC else {
            fatalError("Unable to dequeue PhotoCVC")
        }
        
        let asset = viewModel?.model.photos[indexPath.item]
        let isSelected = viewModel?.isPhotoSelected(at: indexPath.item)
        
        cell.configure(with: asset, isSelected: isSelected)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSize = (collectionView.bounds.width / 3) - 2
        return CGSize(width: itemSize, height: itemSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel?.whenPhotoSelected(indexPhoto: indexPath.item, vc: self) {
            collectionView.reloadData()
        }
    }
}

