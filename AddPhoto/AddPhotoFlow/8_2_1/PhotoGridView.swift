//
//  PhotoGridView.swift
//  AddPhoto
//
//  Created by Kamila on 28.12.2020.
//

import UIKit

class PhotoGridView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
        
        layoutUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutUI() {
        let size = (UIScreen.main.bounds.width - 15) / 3
        
        let topFirst = getLine()
        addSubview(topFirst)
        [ topFirst.topAnchor.constraint(equalTo: topAnchor),
          topFirst.bottomAnchor.constraint(equalTo: bottomAnchor),
          topFirst.widthAnchor.constraint(equalToConstant: 1),
          topFirst.leftAnchor.constraint(equalTo: leftAnchor, constant: size),
        ].forEach { $0.isActive = true }
        
        let topSecond = getLine()
        addSubview(topSecond)
        [ topSecond.topAnchor.constraint(equalTo: topAnchor),
          topSecond.bottomAnchor.constraint(equalTo: bottomAnchor),
          topSecond.widthAnchor.constraint(equalToConstant: 1),
          topSecond.rightAnchor.constraint(equalTo: rightAnchor, constant: -size),
        ].forEach { $0.isActive = true }
        
        let bottomFirst = getLine()
        addSubview(bottomFirst)
        [ bottomFirst.rightAnchor.constraint(equalTo: rightAnchor),
          bottomFirst.leftAnchor.constraint(equalTo: leftAnchor),
          bottomFirst.heightAnchor.constraint(equalToConstant: 1),
          bottomFirst.topAnchor.constraint(equalTo: topAnchor, constant: size),
        ].forEach { $0.isActive = true }
        
        let bottomSecond = getLine()
        addSubview(bottomSecond)
        [ bottomSecond.rightAnchor.constraint(equalTo: rightAnchor),
          bottomSecond.leftAnchor.constraint(equalTo: leftAnchor),
          bottomSecond.heightAnchor.constraint(equalToConstant: 1),
          bottomSecond.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -size),
        ].forEach { $0.isActive = true }
    }
    
    private func getLine() -> UIView {
        let lineView = UIView()
        lineView.backgroundColor = .white
        lineView.translatesAutoresizingMaskIntoConstraints = false
        return lineView
    }
}
