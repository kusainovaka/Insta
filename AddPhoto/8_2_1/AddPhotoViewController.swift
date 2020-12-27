//
//  AddPhotoViewController.swift
//  AddPhoto
//
//  Created by Kamila on 23.12.2020.
//

import UIKit

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavBar()
    }
    
    private func setupConstraints() {
        view.backgroundColor = Colors.colors.block_8_2_1_background
        view.addSubview(addButton)
        [addButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25),
         addButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30),
         addButton.heightAnchor.constraint(equalToConstant: 67),
         addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
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
}

private extension AddPhotoViewController {
    @objc func didTapOnAddButton() {
        let choosePhotoVC = ChoosePhotoViewController()
        choosePhotoVC.modalPresentationStyle = .overFullScreen
        navigationController?.present(choosePhotoVC, animated: true, completion: nil)
        //        navigationController?.pushViewController(choosePhotoVC,
        //                                                 animated: true)
    }
    
    @objc func didTapOnClose() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func didTapOnPreview() {
        navigationController?.popViewController(animated: true)
    }
}
