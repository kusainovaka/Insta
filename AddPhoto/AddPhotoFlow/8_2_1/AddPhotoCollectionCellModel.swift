//
//  AddPhotoCollectionCellModel.swift
//  AddPhoto
//
//  Created by Kamila on 27.12.2020.
//

import UIKit

enum AddPhotoCollectionCellType {
    case selected
    case empty
    case add
}

struct AddPhotoCollectionCellModel {
    var type: AddPhotoCollectionCellType
    var image: UIImage?
}
