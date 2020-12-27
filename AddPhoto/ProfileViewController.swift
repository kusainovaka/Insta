//
//  ProfileViewController.swift
//  AddPhoto
//
//  Created by Kamila on 20.12.2020.
//

import UIKit
import AVFoundation

class ProfileViewController: UIViewController {
    private let addButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .orange
        button.setTitle("Добавить фото", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        layoutUI()
    }
    
    private func layoutUI() {
        view.addSubview(addButton)
        addButton.addTarget(self, action: #selector(didTapOnButton), for: .touchUpInside)
        [addButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
         addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
         addButton.heightAnchor.constraint(equalToConstant: 100),
         addButton.widthAnchor.constraint(equalToConstant: 100),
        ].forEach { $0.isActive = true }
    }
    
    @objc func didTapOnButton() {
        AVCaptureDevice.requestAccess(for: .video) { [weak self] success in
            DispatchQueue.main.async { [weak self] in
                if success {
                    let addPhotoViewController = AddPhotoViewController()
                    self?.navigationController?.pushViewController(addPhotoViewController, animated: true)
                } else {
                    self?.alert()
                }
            }
        }
    }
    
    func alert() {
        let title = "Доступ к камере"
        let message = "Нет доступа к камере"
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        alert.addAction(UIAlertAction(title: "Настройки", style: .default) { _ in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
            DispatchQueue.main.async {
                UIApplication.shared.open(settingsUrl)
            }
        })
        present(alert, animated: true)
    }
}

