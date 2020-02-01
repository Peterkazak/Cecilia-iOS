//
//  ImageComparisonView.swift
//  Cecilia
//
//  Created by Peter Kazakov on 01.02.2020.
//  Copyright © 2020 Peter Kazakov. All rights reserved.
//

import UIKit

public class ImageComparisonView: UIView {
    
    fileprivate var leadingConstraint: NSLayoutConstraint!
    fileprivate var originRect: CGRect!
    public var thumbColor = UIColor.white
    
    public var lhs: UIImage = UIImage() {
        didSet { imageView1.image = lhs }
    }
    
    public var rhs: UIImage = UIImage() {
        didSet { imageView2.image = rhs }
    }

    fileprivate lazy var imageView1: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    fileprivate lazy var imageView2: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    fileprivate lazy var image1Wrapper: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    fileprivate lazy var thumbWrapper: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    fileprivate lazy var thumb: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    lazy fileprivate var setupLeadingAndOriginRect: Void = {
        self.leadingConstraint.constant = self.frame.width / 2
        self.layoutIfNeeded()
        self.originRect = self.image1Wrapper.frame
    }()
    
    // MARK: - ViewController override methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        subviewsSetup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        _ = setupLeadingAndOriginRect
    }
    
    // MARK: - Event handlers
    @objc func gesture(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self)
        switch sender.state {
        case .began, .changed:
            var newLeading = originRect.origin.x + translation.x
            newLeading = max(newLeading, 20)
            newLeading = min(frame.width - 20, newLeading)
            leadingConstraint.constant = newLeading
            layoutIfNeeded()
        case .ended, .cancelled:
            originRect = image1Wrapper.frame
        default: break
        }
    }
}

extension ImageComparisonView: SubviewProtocol {
    func subviewsSetup() {
        image1Wrapper.addSubview(imageView1)
        addSubview(imageView2)
        addSubview(image1Wrapper)
        
        thumbWrapper.addSubview(thumb)
        addSubview(thumbWrapper)
        
        NSLayoutConstraint.activate([
            imageView2.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            imageView2.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            imageView2.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            imageView2.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0)
        ])
        
        leadingConstraint = image1Wrapper.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0)
        
        NSLayoutConstraint.activate([
            image1Wrapper.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            image1Wrapper.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            image1Wrapper.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            leadingConstraint
        ])
        
        NSLayoutConstraint.activate([
            imageView1.topAnchor.constraint(equalTo: image1Wrapper.topAnchor, constant: 0),
            imageView1.bottomAnchor.constraint(equalTo: image1Wrapper.bottomAnchor, constant: 0),
            imageView1.trailingAnchor.constraint(equalTo: image1Wrapper.trailingAnchor, constant: 0)
        ])
        
        NSLayoutConstraint.activate([
            thumbWrapper.topAnchor.constraint(equalTo: image1Wrapper.topAnchor, constant: 0),
            thumbWrapper.bottomAnchor.constraint(equalTo: image1Wrapper.bottomAnchor, constant: 0),
            thumbWrapper.leadingAnchor.constraint(equalTo: image1Wrapper.leadingAnchor, constant: -20),
            thumbWrapper.widthAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            thumb.centerXAnchor.constraint(equalTo: thumbWrapper.centerXAnchor, constant: 0),
            thumb.centerYAnchor.constraint(equalTo: thumbWrapper.centerYAnchor, constant: 0),
            thumb.widthAnchor.constraint(equalTo: thumbWrapper.widthAnchor, multiplier: 1),
            thumb.heightAnchor.constraint(equalTo: thumbWrapper.widthAnchor, multiplier: 1)
        ])
        
        leadingConstraint.constant = frame.width / 2
        
        thumb.layer.cornerRadius = 20
        imageView1.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
        
        let tap = UIPanGestureRecognizer(target: self, action: #selector(gesture(sender:)))
        thumbWrapper.isUserInteractionEnabled = true
        thumbWrapper.addGestureRecognizer(tap)
    }
}

