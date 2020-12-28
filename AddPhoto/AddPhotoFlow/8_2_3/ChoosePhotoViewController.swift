//
//  ChoosePhotoViewController.swift
//  AddPhoto
//
//  Created by Kamila on 25.12.2020.
//

import UIKit
import Photos

protocol ChoosePhotoViewControllerDelegate {
    func didSelect(images: [ChoosePhotoCellModel])
}

class ChoosePhotoViewController: UIViewController {
    
    private let cellSize = (UIScreen.main.bounds.width - 24 - 12) / 4
    private let closeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "close-icon"), for: .normal)
        button.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Colors.colors.block_2_1_stack_button
        label.font = UIFont(name: "Roboto-Regular", size: 18)
        label.text = "Выберите до 6 фотографий"
        return label
    }()
    
    private let addButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 8
        button.setTitle("Добавить", for: .normal)
        button.backgroundColor = Colors.colors.block_2_1_button_active
        button.setTitleColor(Colors.colors.block_8_2_1_button_text, for: .normal)
        button.addTarget(self, action: #selector(didTapOnAddButton), for: .touchUpInside)
        return button
    }()
    var delegate: ChoosePhotoViewControllerDelegate?
    
    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let space: CGFloat = 6
        flowLayout.itemSize = CGSize(width: cellSize, height: cellSize)
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(ChoosePhotoCollectionCell.self,
                                forCellWithReuseIdentifier: ChoosePhotoCollectionCell.id)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: cellSize, right: 0)
        return collectionView
    }()
    
    var dataModels = [ChoosePhotoCellModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.colors.block_8_2_1_background
        
        setupConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkPermissionToPhotoLibrary()
    }
    
    private func setupConstraints() {
        view.addSubview(closeButton)
        [closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
         closeButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 18),
         closeButton.heightAnchor.constraint(equalToConstant: 22),
         closeButton.widthAnchor.constraint(equalToConstant: 22)
        ].forEach { $0.isActive = true }
        
        view.addSubview(titleLabel)
        [titleLabel.topAnchor.constraint(equalTo: closeButton.topAnchor),
         titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ].forEach { $0.isActive = true }
        
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        [collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
         collectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -6),
         collectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 6),
         collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ].forEach { $0.isActive = true }
        
        view.addSubview(addButton)
        [addButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25),
         addButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30),
         addButton.heightAnchor.constraint(equalToConstant: 67),
         addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
        ].forEach { $0.isActive = true }
    }
    
    @objc private func closeAction() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapOnAddButton() {
        delegate?.didSelect(images: dataModels)
        dismiss(animated: true, completion: nil)
    }
    
    private func getImages() {
        var isBegin = true
        let assets = PHAsset.fetchAssets(with: .image, options: nil)
        let manager = PHImageManager.default()

        assets.enumerateObjects({ object, number, _ in
            let size = CGSize(width: self.cellSize, height: self.cellSize)
            manager.requestImage(for: object, targetSize: size, contentMode: .aspectFill, options: nil) { [weak self] image, _ in
                if isBegin {
                    let model = ChoosePhotoCellModel(id: number, image: image, isSelect: false)
                    self?.dataModels.append(model)
                    self?.collectionView.reloadData()
                }
            }
        })

        isBegin = dataModels.isEmpty
        collectionView.reloadData()
    }
    
    func checkPermissionToPhotoLibrary() {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
            case .authorized:
                guard dataModels.isEmpty else { return }
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

extension ChoosePhotoViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChoosePhotoCollectionCell.id, for: indexPath) as? ChoosePhotoCollectionCell else { return .init() }
        let model = dataModels[indexPath.row]
        cell.config(with: model)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCount = dataModels.filter { $0.isSelect == true }.count
        
        if selectedCount >= 6, !dataModels[indexPath.row].isSelect {
            return
        } else {
            dataModels[indexPath.row].isSelect.toggle()
            collectionView.reloadData()
        }
    }
}
