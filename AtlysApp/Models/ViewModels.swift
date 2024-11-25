//
//  ViewModels.swift
//  AtlysApp

import UIKit

struct ImagesViewModel {
    let imageName: String
    var uiImage: UIImage? { UIImage(named: self.imageName) }
}

struct CarouselViewModel {
    let images: [ImagesViewModel]
}
