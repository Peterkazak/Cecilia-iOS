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
    
    private var items: [String] = ["1", "2", "3"]
    
    // MARK: - UISegmentedControl override methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        selectedSegmentIndex = 1
        for i in 0..<items.count { insertSegment(withTitle: items[i], at: i, animated: false) }
        addTarget(self, action: #selector(brushSizeSwitchAction(_:)), for: .valueChanged)
        generator.prepare()
    }
        
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Event handlers
    @objc private func brushSizeSwitchAction(_ sender: UISegmentedControl) {
        self.generator.impactOccurred()
    }
}
