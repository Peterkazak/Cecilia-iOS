//
//  BrushSizeSwitch.swift
//  Cecilia
//
//  Created by Peter Kazakov on 01.02.2020.
//  Copyright © 2020 Peter Kazakov. All rights reserved.
//

import UIKit

class BrushSizeSwitch: UISegmentedControl {
    private var generator: UIImpactFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)
    
    private var items: [UIImage] = [UIImage(named: "brush1")!, UIImage(named: "brush2")!, UIImage(named: "brush3")!]
    
    private var stackView = UIStackView()
    
    // MARK: - UISegmentedControl override methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        
        addTarget(self, action: #selector(brushSizeSwitchAction(_:)), for: .valueChanged)
        generator.prepare()
    
        insertSubview(stackView, at: 2)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 4.0
        
        for i in 0..<items.count {
            let image = UIImageView(image: items[i])
            if i == 2 { image.alpha = 0.2 }
            image.translatesAutoresizingMaskIntoConstraints = false
            image.widthAnchor.constraint(equalToConstant: (SCREEN_WIDTH - 40.0)/3).isActive = true
            stackView.addArrangedSubview(image)
            insertSegment(withTitle: "", at: i, animated: false)
        }
        
        selectedSegmentIndex = 2
    }
        
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Event handlers
    @objc private func brushSizeSwitchAction(_ sender: UISegmentedControl) {
        generator.impactOccurred()
        for i in 0..<items.count { stackView.arrangedSubviews[i].alpha = 1.0 }
        stackView.arrangedSubviews[sender.selectedSegmentIndex].alpha = 0.2
    }
}
