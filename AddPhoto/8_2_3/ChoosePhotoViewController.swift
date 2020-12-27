//
//  ChoosePhotoViewController.swift
//  AddPhoto
//
//  Created by Kamila on 25.12.2020.
//

import UIKit
import Photos

class ChoosePhotoViewController: UIViewController {
    
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
    private let cellSize = (UIScreen.main.bounds.width - 24 - 12) / 4
    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let space: CGFloat = 6
        flowLayout.itemSize = CGSize(width: cellSize, height: cellSize)
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(ChoosePhotoCell.self, forCellWithReuseIdentifier: "ChoosePhotoCell")
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: cellSize, right: 0)
        return collectionView
    }()

    private var data = [ChoosePhotoCellModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.colors.block_8_2_1_background

        layoutUI()
        getImages()
    }
    
    private func layoutUI() {
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
        addShadow()
    }
    
    func addShadow() {
        let shadowView = UIView()
        shadowView.translatesAutoresizingMaskIntoConstraints = false
        shadowView.backgroundColor = .clear
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [
          UIColor(red: 0.961, green: 0.961, blue: 0.961, alpha: 0).cgColor,
          UIColor(red: 0.961, green: 0.961, blue: 0.961, alpha: 1).cgColor
        ]
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
        
        view.addSubview(shadowView)
//        shadowView.backgroundColor = .orange
        [shadowView.leftAnchor.constraint(equalTo: view.leftAnchor),
         shadowView.rightAnchor.constraint(equalTo: view.rightAnchor),
         shadowView.topAnchor.constraint(equalTo: addButton.centerYAnchor),
//         shadowView.heightAnchor.constraint(equalToConstant: 44),
         shadowView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ].forEach { $0.isActive = true }
//        layoutIfNeeded()
//        shadowView.layoutIfNeeded()
        gradient.frame = shadowView.frame
//        gradient.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: 57.5)
 
        shadowView.layer.insertSublayer(gradient, at: 0)
    }
    
    @objc private func closeAction() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapOnAddButton() {
        dismiss(animated: true, completion: nil)
    }
    
    func getImages() {
        var isBegin = true
        let assets = PHAsset.fetchAssets(with: .image, options: nil)
        assets.enumerateObjects({ (object, number, stop) in
            let manager = PHImageManager.default()
            let size = CGSize(width: self.cellSize, height: self.cellSize)
            manager.requestImage(for: object, targetSize: size, contentMode: .aspectFill, options: nil) { [weak self] image, info in
                if isBegin {
                    let model = ChoosePhotoCellModel(id: number, image: image,isSelect: false)
                    self?.data.append(model)
                }
            }
        })
        isBegin = false
        collectionView.reloadData()
    }
}

extension ChoosePhotoViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChoosePhotoCell", for: indexPath) as? ChoosePhotoCell else { return .init() }
        let model = data[indexPath.row]
        cell.config(with: model)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCount = data.filter { $0.isSelect == true }.count
        if selectedCount >= 4, !data[indexPath.row].isSelect {
            return
        } else {
            data[indexPath.row].isSelect.toggle()
            collectionView.reloadData()
        }
    }
}
