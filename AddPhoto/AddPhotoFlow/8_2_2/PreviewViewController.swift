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
        imageView.contentMode = .scaleAspectFill
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
        let spacing: CGFloat = 16
        stackView.spacing = spacing
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: spacing)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.distribution = .equalCentering
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        
        setupConstraints()
    }
    
    func setupConstraints() {
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
    
    private func setupStackView() {
        for i in 0...5 {
            let stackButton = UIButton()
            stackButton.translatesAutoresizingMaskIntoConstraints = false
            stackButton.backgroundColor = .yellow
            stackButton.addTarget(self, action: #selector(didTapOnSome), for: .touchUpInside)
            setupButtonColor(with: stackButton, isSelected: false)
            
            let size = (UIScreen.main.bounds.width - (16 *  7)) / 6
            stackButton.layer.cornerRadius = size / 2
            [stackButton.heightAnchor.constraint(equalToConstant: 42),
             stackButton.widthAnchor.constraint(equalToConstant: size)
            ].forEach { $0.isActive = true }
            
            stackView.addArrangedSubview(stackButton)
        }
    }
    
    @objc func didTapOnClose() {
        navigationController?.popViewController(animated: true)
    }
    
    private func getButton(isSelected: Bool) -> UIButton {
        let button = UIButton()
        return button
    }
    
    @objc private func didTapOnSome(_ sender: UIButton) {
        stackView.arrangedSubviews.forEach { subView in
            guard let button = subView as? UIButton else { return }
            setupButtonColor(with: button, isSelected: button === sender)
        }
    }
    
    private func setupButtonColor(with button: UIButton, isSelected: Bool) {
        if isSelected {
            button.layer.borderWidth = 2
            button.layer.borderColor = Colors.colors.block_2_1_button_active.cgColor
        } else {
            button.layer.borderWidth = 0
            button.layer.borderColor = UIColor.clear.cgColor
        }
    }
}
