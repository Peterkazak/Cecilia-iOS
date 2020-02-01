//
//  PictureView.swift
//  Cecilia
//
//  Created by Peter Kazakov on 02.02.2020.
//  Copyright © 2020 Peter Kazakov. All rights reserved.
//

import UIKit

class PictureView: UIView {
    
    private var bagetImageView = UIImageView()
    public var pictureImageView = UIImageView()
    
    // MARK: - UIView override methods
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        backgroundColor = .clear
        
        bagetImageView.image = UIImage(named: "baget\(Int.random(in: 1..<3))")!
        bagetImageView.contentMode = .scaleToFill
        bagetImageView.clipsToBounds = true
        pictureImageView.contentMode = .scaleAspectFill
        pictureImageView.clipsToBounds = true
        
        subviewsSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - PictureView methods
    
}

extension PictureView: SubviewProtocol {
    func subviewsSetup() {
        insertSubview(bagetImageView, at: 1)
        bagetImageView.translatesAutoresizingMaskIntoConstraints = false
        bagetImageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        bagetImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        bagetImageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        bagetImageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        insertSubview(pictureImageView, at: 0)
        pictureImageView.translatesAutoresizingMaskIntoConstraints = false
        pictureImageView.leadingAnchor.constraint(equalTo: bagetImageView.leadingAnchor, constant: 5.0).isActive = true
        pictureImageView.topAnchor.constraint(equalTo: bagetImageView.topAnchor, constant: 5.0).isActive = true
        pictureImageView.trailingAnchor.constraint(equalTo: bagetImageView.trailingAnchor, constant: -5.0).isActive = true
        pictureImageView.bottomAnchor.constraint(equalTo: bagetImageView.bottomAnchor, constant: -5.0).isActive = true
                
        layoutIfNeeded()
    }
}
