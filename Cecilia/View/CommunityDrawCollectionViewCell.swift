//
//  CommunityDrawCollectionViewCell.swift
//  Cecilia
//
//  Created by Peter Kazakov on 02.02.2020.
//  Copyright © 2020 Peter Kazakov. All rights reserved.
//

import UIKit

class CommunityDrawCollectionViewCell: UICollectionViewCell {
    
    static let identifier: String = "CommunityDrawCollectionViewCell"
    static let width: CGFloat = (SCREEN_WIDTH / 5).rounded()
    static let height: CGFloat = (SCREEN_WIDTH / 3).rounded()
    
    public var draw = UIImageView()
    
    // MARK: - UICollectionViewCell override methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        
        subviewsSetup()
        
        draw.contentMode = .scaleAspectFill
        draw.clipsToBounds = true
        draw.layer.cornerRadius = 5.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - SubviewProtocol protocol implementation
extension CommunityDrawCollectionViewCell: SubviewProtocol {
    func subviewsSetup() {
        insertSubview(draw, at: 1)
        
        draw.translatesAutoresizingMaskIntoConstraints = false
        draw.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5.0).isActive = true
        draw.topAnchor.constraint(equalTo: topAnchor, constant: 5.0).isActive = true
        draw.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5.0).isActive = true
        draw.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5.0).isActive = true
        
        layoutIfNeeded()
    }
}
