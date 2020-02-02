//
//  ResultViewController.swift
//  Cecilia
//
//  Created by Peter Kazakov on 01.02.2020.
//  Copyright © 2020 Peter Kazakov. All rights reserved.
//

import UIKit
import SDWebImage

protocol ResultViewControllerDelegate: class {
    func restartGame()
}

class ResultViewController: UIViewController {
    
    private let comparesonView = ImageComparisonView()
    private let newGameButton = UIButton()
    
    private var collectionView: UICollectionView!
    private let flowLayout = UICollectionViewFlowLayout()
    
    public var lhsImage = UIImage()
    public var rhsImage = UIImage()
    
    weak var delegate: ResultViewControllerDelegate?
    
    private var communtiyDrawing: [CommunityDrawing] = []
    
    // MARK: - ViewController override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        collectionViewSetup()
        subviewsSetup()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        comparesonView.backgroundColor = .white
        comparesonView.lhs = lhsImage
        comparesonView.rhs = rhsImage
        
        newGameButton.setTitle("New game", for: .normal)
        newGameButton.backgroundColor = .orange
        newGameButton.addTarget(self, action: #selector(newGameButtonAction(_:)), for: .touchUpInside)
        
        GameSessionService.shared.getSourceDrawingsBy(id: 1, completion: { (draws) in
            self.communtiyDrawing.removeAll()
            for item in draws { self.communtiyDrawing.append(item) }
            self.collectionView.reloadData()
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    // MARK: - ResultViewController methods
    
    // MARK: - Event handlers
    @objc func newGameButtonAction(_ sender: UIButton) {
        dismiss(animated: false, completion: { self.delegate?.restartGame() })
    }
}

// MARK: - SubviewProtocol protocol implementation
extension ResultViewController: SubviewProtocol {
    func subviewsSetup() {
        view.insertSubview(comparesonView, at: 0)
        comparesonView.translatesAutoresizingMaskIntoConstraints = false
        comparesonView.widthAnchor.constraint(equalToConstant: SCREEN_WIDTH).isActive = true
        comparesonView.heightAnchor.constraint(equalToConstant: SCREEN_HEIGHT).isActive = true
        comparesonView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        comparesonView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        
        view.insertSubview(newGameButton, at: 1)
        newGameButton.translatesAutoresizingMaskIntoConstraints = false
        newGameButton.widthAnchor.constraint(equalToConstant: (SCREEN_WIDTH/2).rounded()).isActive = true
        newGameButton.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        newGameButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40.0).isActive = true
        newGameButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.insertSubview(collectionView, at: 2)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.heightAnchor.constraint(equalToConstant: (SCREEN_WIDTH / 2.5).rounded()).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        self.view.layoutIfNeeded()
    }
    
    internal func collectionViewSetup() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        
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
        collectionView.isScrollEnabled = true
        collectionView.backgroundColor = UIColor(named: "bg_01")
        collectionView.register(CommunityDrawCollectionViewCell.self, forCellWithReuseIdentifier: CommunityDrawCollectionViewCell.identifier)
        collectionView.reloadData()
    }
}

// MARK: - UICollectionView Protocol extension
extension ResultViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    // MARK: UICollectionView DataSource methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return communtiyDrawing.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CommunityDrawCollectionViewCell.identifier, for: indexPath) as! CommunityDrawCollectionViewCell
        let url = URL(string: communtiyDrawing[indexPath.row].imageUrl)!
        cell.draw.sd_imageIndicator = SDWebImageActivityIndicator.gray
        cell.draw.sd_setImage(with: url, placeholderImage: UIImage(named: "img1"), options: [.continueInBackground], completed: nil)
        return cell
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // MARK: UICollectionView Delegate methods
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("LOL")
    }
    
    // MARK: UICollectionViewDelegateFlowLayout Delegate methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0.0, left: 3.5, bottom: 0.0, right: 0.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 7.0
    }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: CommunityDrawCollectionViewCell.width,
                      height: CommunityDrawCollectionViewCell.height)
    }
}
