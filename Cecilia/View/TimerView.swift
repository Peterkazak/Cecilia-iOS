//
//  TimerView.swift
//  Cecilia
//
//  Created by Peter Kazakov on 01.02.2020.
//  Copyright © 2020 Peter Kazakov. All rights reserved.
//

import UIKit

class TimerView: UIView {
    
    public let slider = UISlider()
    public var label = UILabel()
    
    // MARK: - UIView override methods
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        subviewsSetup()
        
        label.numberOfLines = 1
        label.textAlignment = .center
        label.text = "20 сек."
        label.textColor = UIColor(named: "label_color_01")
        label.font = UIFont(name: "ComicSansMS-Bold", size: 36)
        
        slider.setThumbImage(UIImage(), for: .normal)
        slider.maximumTrackTintColor = .blue
        slider.minimumTrackTintColor = .green
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TimerView: SubviewProtocol {
    func subviewsSetup() {
        self.widthAnchor.constraint(equalToConstant: SCREEN_WIDTH).isActive = true
        self.heightAnchor.constraint(equalToConstant: 90.0).isActive = true
        
        self.insertSubview(slider, at: 1)
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
        slider.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        slider.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        slider.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        self.insertSubview(label, at: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: slider.topAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        label.heightAnchor.constraint(equalToConstant: 36.0).isActive = true
        
        layoutIfNeeded()
    }
}
