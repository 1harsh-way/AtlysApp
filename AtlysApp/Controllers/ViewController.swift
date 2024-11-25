//
//  ViewController.swift
//  AtlysApp

import UIKit

class ViewController: UIViewController {
    
    private var carouselView: CarouselView?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // MARK: More images can be added here.
        
        let carouselViewModel = CarouselViewModel(images: [
            ImagesViewModel(imageName: "uae"),
            ImagesViewModel(imageName: "indonesia"),
            ImagesViewModel(imageName: "egypt")
        ])
        
        self.carouselView = CarouselView(model: carouselViewModel)
        
        guard let carouselView else { return }
        
        carouselView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(carouselView)
        
        NSLayoutConstraint.activate([
            carouselView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            carouselView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            carouselView.topAnchor.constraint(equalTo: view.topAnchor),
            carouselView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.7, delay: 0, options: .curveEaseInOut) {
            self.carouselView?.beginScroll(page: 1)
        }
    }
}
