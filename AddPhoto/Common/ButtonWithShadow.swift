//
//  ButtonWithShadow.swift
//  AddPhoto
//
//  Created by Kamila on 23.12.2020.
//

import UIKit

final class ButtonWithShadow: UIButton {
    
    private var shadowLayer: CAShapeLayer!
    
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 8
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOpacity = 3
        layer.shadowOffset = CGSize(width: -4, height: 4)
        layer.shadowRadius = 4
    }
}
