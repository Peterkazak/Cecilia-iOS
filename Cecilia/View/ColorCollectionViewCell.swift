//
//  ColorCollectionViewCell.swift
//  Cecilia
//
//  Created by Peter Kazakov on 01.02.2020.
//  Copyright © 2020 Peter Kazakov. All rights reserved.
//

import UIKit

class ColorCollectionViewCell: UICollectionViewCell {
    
    static let identifier: String = "ColorCollectionViewCell"
    static let width: CGFloat = (SCREEN_WIDTH / 7).rounded() - 7 // Magic numbers C:
    static let height: CGFloat = (SCREEN_WIDTH / 7).rounded() - 7
    
    // MARK: - UICollectionViewCell override methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = false
        backgroundColor = .white
        layer.cornerRadius = (ColorCollectionViewCell.width/2).rounded()
        subviewsSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - SubviewProtocol protocol implementation
extension ColorCollectionViewCell: SubviewProtocol {
    func subviewsSetup() {
        layoutIfNeeded()
    }
}
