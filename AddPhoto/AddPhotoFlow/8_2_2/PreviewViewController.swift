//
//  PreviewViewController.swift
//  AddPhoto
//
//  Created by Kamila on 27.12.2020.
//

import UIKit

class PreviewViewController: UIViewController {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "close-icon"), for: .normal)
        button.addTarget(self, action: #selector(didTapOnClose), for: .touchUpInside)
        return button
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .equalCentering
        let spacing: CGFloat = 16
        stackView.spacing = spacing
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: spacing)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    var previewImages = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        
        setupConstraints()
        setupFirstPreviewImage()
        addGestureRecognizer()
    }
    
    private func setupFirstPreviewImage () {
        guard let firstImage = previewImages.first else { return }
        imageView.image = firstImage
    }
    
    private func setupConstraints() {
        view.addSubview(imageView)
        imageView.backgroundColor = .white
        [imageView.topAnchor.constraint(equalTo: view.topAnchor),
         imageView.rightAnchor.constraint(equalTo: view.rightAnchor),
         imageView.leftAnchor.constraint(equalTo: view.leftAnchor),
         imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ].forEach { $0.isActive = true }
        
        view.addSubview(closeButton)
        [closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
         closeButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 18),
         closeButton.heightAnchor.constraint(equalToConstant: 22),
         closeButton.widthAnchor.constraint(equalToConstant: 22)
        ].forEach { $0.isActive = true }
        
        view.addSubview(stackView)
        [stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
         stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
         stackView.heightAnchor.constraint(equalToConstant: 42)
        ].forEach { $0.isActive = true }
        setupStackView()
    }
    
    private func addGestureRecognizer() {
        let swipeRight = UISwipeGestureRecognizer(target: self,
                                                  action: #selector(rightGestureAction))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self,
                                                 action: #selector(leftGestureAction))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
    }
    
    private func setupStackView() {
        stackView.subviews.forEach {
            stackView.removeArrangedSubview($0)
        }
        for (index, image) in previewImages.enumerated() {
            let stackButton = UIButton()
            stackButton.translatesAutoresizingMaskIntoConstraints = false
            stackButton.setImage(image, for: .normal)
            stackButton.addTarget(self, action: #selector(didTapOnButton), for: .touchUpInside)
            setupButtonColor(with: stackButton, isSelected: index == 0)
            let smallSize = (UIScreen.main.bounds.width - (16 *  7)) / 6
            let standartSize: CGFloat = 42
            let size: CGFloat = UIScreen.needToScaleDownConstraints ? smallSize : standartSize
            stackButton.layer.cornerRadius = size / 2
            stackButton.imageView?.layer.cornerRadius =  size / 2
            [stackButton.heightAnchor.constraint(equalToConstant: standartSize),
             stackButton.widthAnchor.constraint(equalToConstant: size)
            ].forEach { $0.isActive = true }
            
            stackView.addArrangedSubview(stackButton)
        }
    }
    
    @objc func didTapOnClose() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func leftGestureAction() {
        let last = stackView.subviews.count - 1
        showNextPhoto(with: last, isRight: false)
    }
    
    @objc func rightGestureAction() {
        showNextPhoto(with: 0, isRight: true)
    }
    
    func showNextPhoto(with last: Int, isRight: Bool) {
        var nextIndex: Int?
        
        for (index, subView) in stackView.subviews.enumerated() {
            guard let button = subView as? UIButton else { return }
            if button.isSelected {
                setupButtonColor(with: button, isSelected: false)
                let directionIndex = isRight ? index - 1 : index + 1
                nextIndex = last != index ? directionIndex : index
            }
            
            if let buttonIndex = nextIndex,
               let nextButton = stackView.subviews[buttonIndex] as? UIButton {
                setupButtonColor(with: nextButton, isSelected: true)
                imageView.image = nextButton.imageView?.image
            }
        }
    }
    
    @objc private func didTapOnButton(_ sender: UIButton) {
        stackView.arrangedSubviews.forEach { subView in
            guard let button = subView as? UIButton else { return }
            setupButtonColor(with: button, isSelected: button === sender)
            if button === sender {
                imageView.image = button.imageView?.image
            }
        }
    }
    
    private func setupButtonColor(with button: UIButton, isSelected: Bool) {
        button.isSelected = isSelected
        if isSelected {
            button.layer.borderWidth = 2
            button.layer.borderColor = Colors.colors.block_2_1_button_active.cgColor
        } else {
            button.layer.borderWidth = 0
            button.layer.borderColor = UIColor.clear.cgColor
        }
    }
}
