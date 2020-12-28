//
//  AddPhotoViewController.swift
//  AddPhoto
//
//  Created by Kamila on 23.12.2020.
//

import UIKit
import Photos

class AddPhotoViewController: UIViewController {
    
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
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 10.0
        scrollView.zoomScale = 1.0
        scrollView.contentMode = .center
        scrollView.layer.cornerRadius = 8
        scrollView.backgroundColor = Colors.colors.block_2_1_registation_title
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let previewImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = Colors.colors.block_2_1_registation_title
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let gridView = PhotoGridView()
    private let addButton: ButtonWithShadow = {
        let button = ButtonWithShadow()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Добавить", for: .normal)
        button.backgroundColor = Colors.colors.block_2_1_button_active
        button.setTitleColor(Colors.colors.block_8_2_1_button_text, for: .normal)
        button.addTarget(self, action: #selector(didTapOnAddButton), for: .touchUpInside)
        return button
    }()
    
    private var array: [AddPhotoCollectionCellModel] = [
        .init(type: .empty), .init(type: .empty),
        .init(type: .empty), .init(type: .empty),
        .init(type: .empty), .init(type: .empty)
    ]
    private var dataModels = [ChoosePhotoCellModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        setupConstraints()
        getImages()
        addGesture()
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
        
        view.addSubview(scrollView)
        [ scrollView.topAnchor.constraint(equalTo: previewButton.bottomAnchor, constant: 23),
          scrollView.bottomAnchor.constraint(equalTo: collectionView.topAnchor, constant: -6),
          scrollView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -6),
          scrollView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 6),
        ].forEach { $0.isActive = true }
        
        scrollView.addSubview(previewImageView)
        [ previewImageView.topAnchor.constraint(equalTo: previewButton.bottomAnchor, constant: 23),
          previewImageView.bottomAnchor.constraint(equalTo: collectionView.topAnchor, constant: -6),
          previewImageView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -6),
          previewImageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 6),
        ].forEach { $0.isActive = true }
        
        scrollView.addSubview(gridView)
        [ gridView.topAnchor.constraint(equalTo: previewImageView.topAnchor),
          gridView.bottomAnchor.constraint(equalTo: previewImageView.bottomAnchor),
          gridView.leftAnchor.constraint(equalTo: previewImageView.leftAnchor),
          gridView.rightAnchor.constraint(equalTo: previewImageView.rightAnchor)
        ].forEach { $0.isActive = true }
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
    
    func addGesture() {
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(startZooming(_:)))
        previewImageView.addGestureRecognizer(pinchGesture)
    }
    
    @objc func startZooming(_ sender: UIPinchGestureRecognizer) {
        
        if sender.state == .began || sender.state == .changed {
            let currentScale = self.previewImageView.frame.size.width / self.previewImageView.bounds.size.width
            let newScale = currentScale*sender.scale
            let transform = CGAffineTransform(scaleX: newScale, y: newScale)
            self.previewImageView.transform = transform
            sender.scale = 1
            
            if sender.state == .ended {
                previewImageView.transform = CGAffineTransform.identity
            }
            
        }
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
        
        checkSelected()
    }
    
    func checkSelected() {
        array.removeAll()
        // Selected
        for (_, model) in dataModels.enumerated() where model.isSelect {
            let photoModel = AddPhotoCollectionCellModel(type: .selected, image: model.image)
            array.append(photoModel)
        }
        let maxImageCount = 6
        if array.count != maxImageCount {
            array.append(.init(type: .add))
            let unSelectedCount = maxImageCount - array.count
            if unSelectedCount != 0 {
                for _ in 1...unSelectedCount {
                    array.append(.init(type: .empty))
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
    
    private func showAlert() {
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
        let model = array[indexPath.row]
        switch model.type {
            case .add:
                let choosePhotoVC = ChoosePhotoViewController()
                choosePhotoVC.modalPresentationStyle = .overFullScreen
                choosePhotoVC.dataModels = dataModels.sorted(by:{ $0.id > $1.id })
                choosePhotoVC.delegate = self
                navigationController?.present(choosePhotoVC, animated: true, completion: nil)
            case .selected:
                guard let image = model.image else { return }
                previewImageView.image = image
            case .empty:
                break
        }
    }
}

extension AddPhotoViewController: ChoosePhotoViewControllerDelegate {
    func didSelect(images: [ChoosePhotoCellModel]) {
        dataModels = images.sorted(by:{ $0.isSelect && !$1.isSelect })
        
        let firstImage = dataModels.first { $0.isSelect == true }?.image
        previewImageView.image = firstImage
        test()
    }
}

extension AddPhotoViewController: AddPhotoCollectionCellDelegate {
    func delete(with cell: AddPhotoCollectionCell) {
        guard let cellIndex = collectionView.indexPath(for: cell) else { return }
        let arrayModel = array[cellIndex.row]
        for (index, model) in dataModels.enumerated() where model.image == arrayModel.image {
            dataModels[index].isSelect = false
        }
        let lastImage = dataModels.filter { $0.isSelect == true }.last?.image
        previewImageView.image = lastImage
        test()
    }
}
