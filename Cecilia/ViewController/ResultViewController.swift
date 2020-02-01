//
//  ResultViewController.swift
//  Cecilia
//
//  Created by Peter Kazakov on 01.02.2020.
//  Copyright © 2020 Peter Kazakov. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {
    
    private let comparesonView = ImageComparisonView()
    
    public var image1 = UIImage(named: "img1")
    public var image2 = UIImage(named: "img2")
    
    // MARK: - ViewController override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        comparesonView.backgroundColor = .orange
        
        comparesonView.lhs = image1!
        comparesonView.rhs = image2!
        
        subviewsSetup()
    }
    
    // MARK: - ResultViewController methods
    
    // MARK: - Event handlers
    
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
        self.view.layoutIfNeeded()
    }
}
