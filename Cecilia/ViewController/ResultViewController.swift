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
    
    private let completedLabel = UILabel()
    private let pictureView = PictureView()
    private let comparesonView = ImageComparisonView()
    private let newGameButton = UIButton()
    
    private var collectionView: UICollectionView!
    private let flowLayout = UICollectionViewFlowLayout()
    
    public var lhsImage = UIImage()
    public var rhsImage = UIImage()
    public var imageId: Int = 1
    
    weak var delegate: ResultViewControllerDelegate?
    
    private var communtiyDrawing: [CommunityDrawing] = []
    
    // MARK: - ViewController override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "bg_01")
        
        collectionViewSetup()
        subviewsSetup()
        
        completedLabel.numberOfLines = 1
        completedLabel.textAlignment = .center
        completedLabel.text = "COMPLETED!"
        completedLabel.textColor = UIColor(named: "label_color_01")
        completedLabel.font = UIFont(name: "ComicSansMS-Bold", size: 36)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        comparesonView.backgroundColor = .white
        comparesonView.lhs = lhsImage
        comparesonView.rhs = rhsImage
                
        let attributedString = NSAttributedString(string: "PLAY!", attributes: [NSAttributedString.Key.font: UIFont(name: "ComicSansMS-Bold", size: 28)!, .foregroundColor : UIColor(named: "label_color_01")!])
        newGameButton.setAttributedTitle(attributedString, for: .normal)
        newGameButton.backgroundColor = UIColor(named: "timer_slider")
        newGameButton.layer.cornerRadius = 20.0
        newGameButton.layer.borderWidth = 8.0
        newGameButton.layer.borderColor = UIColor(named: "label_color_01")?.cgColor
        newGameButton.addTarget(self, action: #selector(newGameButtonAction(_:)), for: .touchUpInside)
        
        GameSessionService.shared.getSourceDrawingsBy(id: self.imageId, completion: { (draws) in
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
        
        view.insertSubview(completedLabel, at: 0)
        completedLabel.translatesAutoresizingMaskIntoConstraints = false
        completedLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10.0).isActive = true
        completedLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        completedLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        completedLabel.heightAnchor.constraint(equalToConstant: 35.0).isActive = true
        
        view.insertSubview(pictureView, at: 1)
        pictureView.translatesAutoresizingMaskIntoConstraints = false
        pictureView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        pictureView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        pictureView.topAnchor.constraint(equalTo: completedLabel.bottomAnchor, constant: 10.0).isActive = true
//        pictureView.bottomAnchor.constraint(equalTo: collectionView.topAnchor , constant: -200.0).isActive = true
        pictureView.heightAnchor.constraint(equalToConstant: (SCREEN_HEIGHT/1.8).rounded()).isActive = true
        
        pictureView.insertSubview(comparesonView, at: 0)
        comparesonView.translatesAutoresizingMaskIntoConstraints = false
        comparesonView.leadingAnchor.constraint(equalTo: pictureView.leadingAnchor, constant: 5.0).isActive = true
        comparesonView.topAnchor.constraint(equalTo: pictureView.topAnchor, constant: 5.0).isActive = true
        comparesonView.trailingAnchor.constraint(equalTo: pictureView.trailingAnchor, constant: -5.0).isActive = true
        comparesonView.bottomAnchor.constraint(equalTo: pictureView.bottomAnchor, constant: -5.0).isActive = true
        
        view.insertSubview(collectionView, at: 0)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.heightAnchor.constraint(equalToConstant: (SCREEN_WIDTH / 2.5).rounded()).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: pictureView.bottomAnchor, constant: 10.0).isActive = true

        view.insertSubview(newGameButton, at: 1)
        newGameButton.translatesAutoresizingMaskIntoConstraints = false
        newGameButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        newGameButton.widthAnchor.constraint(equalToConstant: (SCREEN_WIDTH/1.5).rounded()).isActive = true
        newGameButton.heightAnchor.constraint(equalToConstant: 64.0).isActive = true
        newGameButton.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 10.0).isActive = true
        newGameButton.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -10.0).isActive = true
        
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
