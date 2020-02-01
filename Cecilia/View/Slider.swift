//
//  Slider.swift
//  Cecilia
//
//  Created by Peter Kazakov on 01.02.2020.
//  Copyright © 2020 Peter Kazakov. All rights reserved.
//

import UIKit

class Slider1: UISlider {
    
    fileprivate let slider = UIImage(named: "Slider")
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        tintColor = .red
        thumbTintColor = tintColor
        
        setThumbImage(slider, for: .application)
        setThumbImage(slider, for: .disabled)
        setThumbImage(slider, for: .focused)
        setThumbImage(slider, for: .highlighted)
        setThumbImage(slider, for: .normal)
        setThumbImage(slider, for: .reserved)
        setThumbImage(slider, for: .selected)

        maximumTrackTintColor = .lightGray
        minimumTrackTintColor = .blue
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UISlider override methods
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.trackRect(forBounds: bounds)
        rect.origin.x = 0.0
        rect.size.width = bounds.size.width
        rect.size.height = 3.0
        return rect
    }
    
    override func thumbRect(forBounds bounds: CGRect, trackRect rect: CGRect, value: Float) -> CGRect {
        return super.thumbRect(forBounds: bounds, trackRect: rect, value: value).offsetBy(dx: 0.0, dy: 0.0)
    }
}
