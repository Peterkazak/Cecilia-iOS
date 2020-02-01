//
//  PaletteView.swift
//  Cecilia
//
//  Created by Peter Kazakov on 01.02.2020.
//  Copyright © 2020 Peter Kazakov. All rights reserved.
//

import UIKit

class PaletteView: UIView {
    
    public var colors: [UIColor] = []
    private let collectionView: UICollectionView!
    private let flowLayout = UICollectionViewFlowLayout()
    
    // MARK: - UIView override methods
    override init(frame: CGRect) {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        for _ in 0..<7 { self.colors.append(UIColor.lightGray) }
        
        super.init(frame: frame)
        
        backgroundColor = .clear

        subviewsSetup()
        
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = UICollectionViewFlowLayout.automaticSize
        flowLayout.minimumInteritemSpacing = 7.0
        flowLayout.minimumLineSpacing = 7.0
        flowLayout.minimumInteritemSpacing = 7.0
        flowLayout.minimumLineSpacing = 7.0
        flowLayout.invalidateLayout()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInsetAdjustmentBehavior = .automatic
        collectionView.isMultipleTouchEnabled = false
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = .clear
        collectionView.register(ColorCollectionViewCell.self, forCellWithReuseIdentifier: ColorCollectionViewCell.identifier)
        collectionView.reloadData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    // MARK: - PaletteView methods
    public func reloadColors() -> Void {
        self.collectionView.reloadData()
    }
}

// MARK: - SubviewProtocol protocol implementation
extension PaletteView: SubviewProtocol {
    func subviewsSetup() {
        self.addSubview(collectionView)
        
        self.widthAnchor.constraint(equalToConstant: SCREEN_WIDTH).isActive = true
        self.heightAnchor.constraint(equalToConstant: (SCREEN_WIDTH/6.5).rounded()).isActive = true
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: self.topAnchor, constant: 3.5).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -3.5).isActive = true
        
        layoutIfNeeded()
    }
}

// MARK: - UICollectionView Protocol extension
extension PaletteView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    // MARK: UICollectionView DataSource methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCollectionViewCell.identifier, for: indexPath) as! ColorCollectionViewCell
        cell.backgroundColor = colors[indexPath.row]
        return cell
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // MARK: UICollectionView Delegate methods
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        NotificationCenter.default.post(name: NSNotification.Name("setPaletteItem"), object: nil, userInfo: ["paletteItem" : colors[indexPath.row]])
    }
    
    // MARK: UICollectionViewDelegateFlowLayout Delegate methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0.0, left: 3.5, bottom: 0.0, right: 0.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 7.0
    }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ColorCollectionViewCell.width, height: ColorCollectionViewCell.height)
    }
}


