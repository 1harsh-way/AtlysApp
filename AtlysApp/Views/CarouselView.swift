//
//  CarouselView.swift
//  AtlysApp

import UIKit

class CarouselView: UIView {
    
    private let imageWidth: CGFloat = 2.0 / 3.0
    private let imageSpacing: CGFloat = UIScreen.main.bounds.width * (1/6)
    
    private var imageViews = [ImageView]()
    private let scrollView = UIScrollView()
    private let pageControl = UIPageControl()
    
    private let model: CarouselViewModel
    
    init(model: CarouselViewModel) {
        self.model = model
        super.init(frame: .zero)
        setupViews()
        setupConstraints()
        setupImages()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupViews() {
        scrollView.delegate = self
        scrollView.isPagingEnabled = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(scrollView)
        
        pageControl.numberOfPages = self.model.images.count
        pageControl.tintColor = .lightGray
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        addSubview(pageControl)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.heightAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 1.0),
            scrollView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            pageControl.centerXAnchor.constraint(equalTo: centerXAnchor),
            pageControl.topAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
    }
    
    private func setupImages() {
        var previousImageView: ImageView?
        
        for image in self.model.images {
            let imageView = ImageView(model: image)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            scrollView.addSubview(imageView)
            imageViews.append(imageView)
            
            NSLayoutConstraint.activate([
                imageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: imageWidth),
                imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
                imageView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor)
            ])
            
            if let previous = previousImageView {
                imageView.leadingAnchor.constraint(equalTo: previous.trailingAnchor,
                                                   constant: -imageSpacing).isActive = true
            } else {
                imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor,
                                                   constant: (UIScreen.main.bounds.width * (1 - imageWidth)) / 2).isActive = true
            }
            
            previousImageView = imageView
        }
        
        if let lastImage = previousImageView {
            lastImage.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor,
                                                constant: -(UIScreen.main.bounds.width * (1 - imageWidth)) / 2).isActive = true
        }
    }
}

extension CarouselView: UIScrollViewDelegate {
    
    func beginScroll(page: Int) {
        let xContentOffset = (scrollView.frame.width * imageWidth * CGFloat(page)) - (imageSpacing * CGFloat(page))
        scrollView.contentOffset = CGPoint(x: xContentOffset, y: scrollView.contentOffset.y)
        let pageWidth = scrollView.frame.width * imageWidth
        let centerOffset = scrollView.contentOffset.x + (scrollView.frame.width / 2)
        
        for imageView in imageViews {
            let distance = abs(centerOffset - imageView.center.x)
            let scale = max(imageWidth, 1 - (distance / pageWidth) * imageWidth)
            imageView.transform = CGAffineTransform(scaleX: scale, y: scale)
            imageView.layer.zPosition = scale > imageWidth ? 1 : 0
        }
        
        let currentPage = Int((scrollView.contentOffset.x + (pageWidth / 2)) / pageWidth)
        pageControl.currentPage = currentPage
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.width * imageWidth
        let centerOffset = scrollView.contentOffset.x + (scrollView.frame.width / 2)
        
        for imageView in imageViews {
            let distance = abs(centerOffset - imageView.center.x)
            let scale = max(imageWidth, 1 - (distance / pageWidth) * imageWidth)
            imageView.transform = CGAffineTransform(scaleX: scale, y: scale)
            imageView.layer.zPosition = scale > imageWidth ? 1 : 0
        }
        
        let currentPage = Int((scrollView.contentOffset.x + (pageWidth / 2)) / pageWidth)
        pageControl.currentPage = currentPage
    }
}
