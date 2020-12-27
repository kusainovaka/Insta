//
//  ChoosePhotoCell.swift
//  AddPhoto
//
//  Created by Kamila on 26.12.2020.
//

import UIKit

class ChoosePhotoCell: UICollectionViewCell {
    
    static var id = "ChoosePhotoCell"
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let selectedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "select-icon")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let coverView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        setSelect(with: false)
    }
    
    private func layoutUI() {
        contentView.addSubview(imageView)
        [imageView.leftAnchor.constraint(equalTo: leftAnchor),
         imageView.rightAnchor.constraint(equalTo: rightAnchor),
         imageView.topAnchor.constraint(equalTo: topAnchor),
         imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ].forEach { $0.isActive = true }
        
        contentView.addSubview(coverView)
        [coverView.leftAnchor.constraint(equalTo: leftAnchor),
         coverView.rightAnchor.constraint(equalTo: rightAnchor),
         coverView.topAnchor.constraint(equalTo: topAnchor),
         coverView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ].forEach { $0.isActive = true }
        
        contentView.addSubview(selectedImageView)
        [selectedImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -8),
         selectedImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
         selectedImageView.widthAnchor.constraint(equalToConstant: 22),
         selectedImageView.heightAnchor.constraint(equalToConstant: 15)
        ].forEach { $0.isActive = true }
    }
    
    func config(with model: ChoosePhotoCellModel) {
        imageView.image = model.image
        setSelect(with: model.isSelect)
    }
    
    func setSelect(with selected: Bool) {
        selectedImageView.isHidden = !selected
        coverView.isHidden = !selected
    }
}
