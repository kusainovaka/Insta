//
//  AddPhotoCollectionCell.swift
//  AddPhoto
//
//  Created by Kamila on 27.12.2020.
//

import UIKit

class AddPhotoCollectionCell: UICollectionViewCell {
    
    static var id = "AddPhotoCollectionCell"
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let deleteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "delete-icon"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        layoutUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.layer.cornerRadius = 8
        layer.cornerRadius = 8
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        deleteButton.isHidden = true
    }
    
    private func layoutUI() {
        contentView.addSubview(imageView)
        [imageView.leftAnchor.constraint(equalTo: leftAnchor),
         imageView.rightAnchor.constraint(equalTo: rightAnchor),
         imageView.topAnchor.constraint(equalTo: topAnchor),
         imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ].forEach { $0.isActive = true }
        
        contentView.addSubview(deleteButton)
        [deleteButton.rightAnchor.constraint(equalTo: rightAnchor),
         deleteButton.bottomAnchor.constraint(equalTo: bottomAnchor),
         deleteButton.widthAnchor.constraint(equalToConstant: 31),
         deleteButton.heightAnchor.constraint(equalToConstant: 31)
        ].forEach { $0.isActive = true }
    }
    
    func config(with model: AddPhotoCollectionCellModel) {
        deleteButton.isHidden = model.image == nil
        switch model.type {
            case .empty:
                imageView.image = nil
                deleteButton.isHidden = true
                backgroundColor = Colors.colors.block_2_1_registation_title
            case .add:
                imageView.image = UIImage(named: "add-icon")
                imageView.contentMode = .center
                deleteButton.isHidden = true
                backgroundColor = Colors.colors.block_2_1_registation_title
            case .selected:
                imageView.image = model.image
                imageView.contentMode = .scaleAspectFill
                deleteButton.isHidden = false
                backgroundColor = Colors.colors.block_2_1_registation_title
        }
    }
}
