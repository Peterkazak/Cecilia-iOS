//
//  Slider.swift
//  Cecilia
//
//  Created by Peter Kazakov on 01.02.2020.
//  Copyright © 2020 Peter Kazakov. All rights reserved.
//

import UIKit

class Slider: UISlider {
        
    // MARK: - UISlider override methods
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        clipsToBounds = true
        setThumbImage(UIImage(), for: .normal)
        maximumTrackTintColor = .clear
        minimumTrackTintColor = UIColor(named: "timer_slider")
        layer.masksToBounds = true
        layer.cornerRadius = 10.0
        layer.borderWidth = 4.0
        layer.borderColor = UIColor(named: "label_color_01")?.cgColor
        value = 1.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.trackRect(forBounds: bounds)
        rect.size.height = 22.0
        rect.origin = .zero
        return rect
    }
}
