//
//  ResultViewController.swift
//  Cecilia
//
//  Created by Peter Kazakov on 01.02.2020.
//  Copyright © 2020 Peter Kazakov. All rights reserved.
//

import UIKit

protocol ResultViewControllerDelegate: class {
    func restartGame()
}

class ResultViewController: UIViewController {
    
    private let comparesonView = ImageComparisonView()
    private let newGameButton = UIButton()
    
    public var lhsImage = UIImage()
    public var rhsImage = UIImage()
    
     weak var delegate: ResultViewControllerDelegate?
    
    // MARK: - ViewController override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        comparesonView.backgroundColor = .white
        comparesonView.lhs = lhsImage
        comparesonView.rhs = rhsImage
        
        newGameButton.setTitle("New game", for: .normal)
        newGameButton.backgroundColor = .orange
        newGameButton.addTarget(self, action: #selector(newGameButtonAction(_:)), for: .touchUpInside)
        
        subviewsSetup()
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
        
        self.view.layoutIfNeeded()
    }
}
