//
//  UIScreen+Extension.swift
//  AddPhoto
//
//  Created by Kamila on 27.12.2020.
//

import UIKit

extension UIScreen {
    static var needToScaleDownConstraints: Bool {
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136: //iPhone SE
                    return true
                default: break
            }
        }
        return false
    }
}
