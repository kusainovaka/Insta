//
//  AddPhotoViewController.swift
//  AddPhoto
//
//  Created by Kamila on 23.12.2020.
//

import UIKit
import Photos

class AddPhotoViewController: UIViewController {
    
    private let addButton: ButtonWithShadow = {
        let button = ButtonWithShadow()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Добавить", for: .normal)
        button.backgroundColor = Colors.colors.block_2_1_button_active
        button.setTitleColor(Colors.colors.block_8_2_1_button_text, for: .normal)
        button.addTarget(self, action: #selector(didTapOnAddButton), for: .touchUpInside)
        return button
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "close-icon"), for: .normal)
        button.addTarget(self, action: #selector(didTapOnClose), for: .touchUpInside)
        return button
    }()
    
    private let previewButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Предпросмотр", for: .normal)
        button.setTitleColor(Colors.colors.block_2_1_button_active, for: .normal)
        button.addTarget(self, action: #selector(didTapOnPreview), for: .touchUpInside)
        return button
    }()
    
    private let cellSize = (UIScreen.main.bounds.width - 24 - 12) / 3
    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let space: CGFloat = 6
        flowLayout.itemSize = CGSize(width: cellSize, height: cellSize)
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(AddPhotoCollectionCell.self,
                                forCellWithReuseIdentifier: AddPhotoCollectionCell.id)
        return collectionView
    }()
    
    private let previewImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .red
        imageView.layer.cornerRadius = 8
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var array: [AddPhotoCollectionCellModel] = [
        .init(type: .empty), .init(type: .empty),
        .init(type: .empty), .init(type: .empty),
        .init(type: .empty), .init(type: .empty)
    ]
    
    private var selectedImaged = [UIImage?]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        setupConstraints()
        getImages()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkPermissionToPhotoLibrary()
    }
    
    private func setupConstraints() {
        view.backgroundColor = Colors.colors.block_8_2_1_background
        view.addSubview(addButton)
        [addButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25),
         addButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30),
         addButton.heightAnchor.constraint(equalToConstant: 67),
         addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
        ].forEach { $0.isActive = true }
        
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        [ collectionView.bottomAnchor.constraint(equalTo: addButton.topAnchor, constant: -6),
          collectionView.heightAnchor.constraint(equalToConstant: (cellSize + 6) * 2 ),
          collectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -6),
          collectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 6),
        ].forEach { $0.isActive = true }
        
        view.addSubview(previewImageView)
        [ previewImageView.topAnchor.constraint(equalTo: previewButton.bottomAnchor, constant: 23),
          previewImageView.bottomAnchor.constraint(equalTo: collectionView.topAnchor, constant: -6),
          previewImageView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -6),
          previewImageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 6),
        ].forEach { $0.isActive = true }    }
    
    func setupNavBar() {
        navigationController?.isNavigationBarHidden = true
        view.addSubview(closeButton)
        [closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
         closeButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 18),
         closeButton.heightAnchor.constraint(equalToConstant: 22),
         closeButton.widthAnchor.constraint(equalToConstant: 22)
        ].forEach { $0.isActive = true }
        
        view.addSubview(previewButton)
        [previewButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
         previewButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -6),
         previewButton.heightAnchor.constraint(equalToConstant: 26),
         previewButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 130)
        ].forEach { $0.isActive = true }
    }
}

private extension AddPhotoViewController {
    @objc func didTapOnAddButton() {
    }
    
    @objc func didTapOnClose() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func didTapOnPreview() {
        let previewVC = PreviewViewController()
        var previewImages = [UIImage]()
        array.forEach { model in
            if let image = model.image {
                previewImages.append(image)
            }
        }
        previewVC.previewImages = previewImages
        navigationController?.pushViewController(previewVC, animated: true)
    }
    
    private func getImages() {
        let assets = PHAsset.fetchAssets(with: .image, options: nil)
        let manager = PHImageManager.default()
        
        assets.enumerateObjects({ (object, number, stop) in
            let size = CGSize(width: self.cellSize, height: self.cellSize)
            manager.requestImage(for: object, targetSize: size, contentMode: .aspectFill, options: nil) { [weak self] image, info in
                if self?.selectedImaged.isEmpty == true {
                    self?.selectedImaged.append(image)
                    self?.previewImageView.image = image
                    self?.test()
                }
            }
        })
    }
    
    func test() {
        // MARK: Set selected
        guard !selectedImaged.isEmpty else {
            array[0].type = .add
        
            collectionView.reloadData()
            return
        }
        
        for (imageArray, model) in selectedImaged.enumerated() {
            for (arrayIndex, _) in array.enumerated() {
                if imageArray == arrayIndex {
                    array[arrayIndex].image = model
                    array[arrayIndex].type = .selected
                    break
                }
            }
        }
        
        test2()
    }
    
    func test2() {
        for (index, model) in array.enumerated() {
            let lastIndex = array.count - 1
            if model.type == .add {
                array[index].type = .empty
            }
            
            if index != lastIndex {
                if model.type == .selected {
                    array[index + 1].type = .add
                }
            }
        }
        collectionView.reloadData()
    }
    
    func checkPermissionToPhotoLibrary() {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
            case .authorized:
                getImages()
            case .denied, .notDetermined, .restricted:
                PHPhotoLibrary.requestAuthorization() { [weak self] status in
                    if status != .authorized {
                        self?.showAlert()
                    }
                }
            default:
                break
        }
    }
    
    private func  showAlert() {
        DispatchQueue.main.async {
            let title = "Доступ к камере"
            let message = "Нет доступа к камере"
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
            alert.addAction(UIAlertAction(title: "Настройки", style: .default) { _ in
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
                UIApplication.shared.open(settingsUrl)
            })
            self.present(alert, animated: true)
        }
    }
}

extension AddPhotoViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return array.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddPhotoCollectionCell.id, for: indexPath) as? AddPhotoCollectionCell else { return .init() }
        cell.config(with: array[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let some = array[indexPath.row]
        switch some.type {
            case .add:
                let choosePhotoVC = ChoosePhotoViewController()
                choosePhotoVC.modalPresentationStyle = .overFullScreen
                navigationController?.present(choosePhotoVC, animated: true, completion: nil)
            case .selected:
                guard let image = some.image else { return }
                previewImageView.image = image
            case .empty:
                break
        }
    }
}
