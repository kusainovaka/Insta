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
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var array: [AddPhotoCollectionCellModel] = [
        .init(type: .empty), .init(type: .empty),
        .init(type: .empty), .init(type: .empty),
        .init(type: .empty), .init(type: .empty)
    ]

//    private var selectedImaged = [UIImage?]()
    private var dataModels = [ChoosePhotoCellModel]()

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
        ].forEach { $0.isActive = true }
    
        
        let sixee = (UIScreen.main.bounds.width - 15) / 3
        let firstLine = getLine()
        previewImageView.addSubview(firstLine)
        [ firstLine.topAnchor.constraint(equalTo: previewImageView.topAnchor),
          firstLine.bottomAnchor.constraint(equalTo: previewImageView.bottomAnchor),
          firstLine.widthAnchor.constraint(equalToConstant: 1),
          firstLine.leftAnchor.constraint(equalTo: previewImageView.leftAnchor, constant: sixee),
        ].forEach { $0.isActive = true }
        
        let secondLine = getLine()
        previewImageView.addSubview(secondLine)
        [ secondLine.topAnchor.constraint(equalTo: previewImageView.topAnchor),
          secondLine.bottomAnchor.constraint(equalTo: previewImageView.bottomAnchor),
          secondLine.widthAnchor.constraint(equalToConstant: 1),
          secondLine.rightAnchor.constraint(equalTo: previewImageView.rightAnchor, constant: -sixee),
        ].forEach { $0.isActive = true }
        
        
        let bottomFirst = getLine()
        previewImageView.addSubview(bottomFirst)
        [ bottomFirst.rightAnchor.constraint(equalTo: previewImageView.rightAnchor),
          bottomFirst.leftAnchor.constraint(equalTo: previewImageView.leftAnchor),
          bottomFirst.heightAnchor.constraint(equalToConstant: 1),
          bottomFirst.topAnchor.constraint(equalTo: previewImageView.topAnchor, constant: sixee),
        ].forEach { $0.isActive = true }
        
        let bottomSecond = getLine()
        previewImageView.addSubview(bottomSecond)
        [ bottomSecond.rightAnchor.constraint(equalTo: previewImageView.rightAnchor),
          bottomSecond.leftAnchor.constraint(equalTo: previewImageView.leftAnchor),
          bottomSecond.heightAnchor.constraint(equalToConstant: 1),
          bottomSecond.bottomAnchor.constraint(equalTo: previewImageView.bottomAnchor, constant: -sixee),
        ].forEach { $0.isActive = true }
    }
    
    func getLine() -> UIView {
        let lineView = UIView()
        lineView.backgroundColor = .white
        lineView.translatesAutoresizingMaskIntoConstraints = false
        return lineView
    }
    
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
        navigationController?.popViewController(animated: true)
    }
    
    @objc func didTapOnClose() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func didTapOnPreview() {
        let previewVC = PreviewViewController()
        var previewImages = [UIImage]()
        array.forEach { model in
            if model.type == .selected, let image = model.image {
                previewImages.append(image)
            }
        }
        previewVC.previewImages = previewImages
        navigationController?.pushViewController(previewVC, animated: true)
    }
    
    private func getImages() {
        let assets = PHAsset.fetchAssets(with: .image, options: nil)
        let manager = PHImageManager.default()
        var isBegin = true
        
        assets.enumerateObjects({ (object, number, stop) in
            let size = CGSize(width: self.cellSize, height: self.cellSize)
            manager.requestImage(for: object, targetSize: size, contentMode: .aspectFill, options: nil) { [weak self] image, info in
                if isBegin {
                    self?.eqallDataModel(with: image, id: number)
                }
            }
        })
       
        isBegin = dataModels.isEmpty
        
        if let firstImage = dataModels.first?.image {
            previewImageView.image = firstImage
            dataModels[0].isSelect = true
            test()
        }
    }
    
    func eqallDataModel(with image: UIImage?, id: Int) {
        let isContains = dataModels.first { $0.id == id }
        if isContains == nil {
            let model = ChoosePhotoCellModel(id: id, image: image, isSelect: false)
            dataModels.append(model)
        }
    }
    
    func test() {
        // MARK: Set selected
        guard !dataModels.isEmpty else {
            array[0].type = .add
            collectionView.reloadData()
            
            return
        }
        var selectedIndex: Int?

        for (imageArray, model) in dataModels.enumerated() {
            for (arrayIndex, _) in array.enumerated() {
                if imageArray == arrayIndex {
                    if model.isSelect {
                        array[arrayIndex].image = model.image
                        array[arrayIndex].type = .selected
                        selectedIndex = arrayIndex + 1
                    } else {
                        array[arrayIndex].image = nil
                        let lastIndex = array.count - 1
                        if arrayIndex != lastIndex {
                            if let some = selectedIndex {
                                array[some].type = .add
                            } else {
                                array[arrayIndex + 1].type = .empty
                            }
                        }
                    }
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
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let some = array[indexPath.row]
        switch some.type {
            case .add:
                let choosePhotoVC = ChoosePhotoViewController()
                choosePhotoVC.modalPresentationStyle = .overFullScreen
                choosePhotoVC.dataModels = dataModels
                choosePhotoVC.delegate = self
                navigationController?.present(choosePhotoVC, animated: true, completion: nil)
            case .selected:
                guard let image = some.image else { return }
                previewImageView.image = image
            case .empty:
                break
        }
    }
}

extension AddPhotoViewController: ChoosePhotoViewControllerDelegate {
    func didSelect(images: [ChoosePhotoCellModel]) {
        dataModels = images
        
        let some = dataModels.first { $0.isSelect == true }?.image
        previewImageView.image = some
        test()
    }
}

extension AddPhotoViewController: AddPhotoCollectionCellDelegate {
    func delete(with cell: AddPhotoCollectionCell) {
        guard let index = collectionView.indexPath(for: cell) else { return }
        dataModels[index.row].isSelect = false
        
        if index.row != 0 {
            array[index.row - 1].type = .empty
            previewImageView.image = array[index.row - 1].image
        } else {
//            array[0].type = .add
//            previewImageView.image = nil
        }
        
        collectionView.reloadData()
        test()
    }
}
