//
//  TimerView.swift
//  Cecilia
//
//  Created by Peter Kazakov on 01.02.2020.
//  Copyright © 2020 Peter Kazakov. All rights reserved.
//

import UIKit

class TimerView: UIView {
    
    private let slider = Slider()
    private var label = UILabel()
    
    // MARK: - UIView override methods
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        backgroundColor = .clear
        
        subviewsSetup()
        
        label.numberOfLines = 1
        label.textAlignment = .center
        label.text = "20 сек."
        label.textColor = UIColor(named: "label_color_01")
        label.font = UIFont(name: "ComicSansMS-Bold", size: 36)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - TimerView methods
    public func updateTimer(value: Int) {
        slider.value = 0.05 * Float(value)
        label.text = "\(value) сек."
    }
}

extension TimerView: SubviewProtocol {
    func subviewsSetup() {
        self.widthAnchor.constraint(equalToConstant: SCREEN_WIDTH).isActive = true
        self.heightAnchor.constraint(equalToConstant: 75.0).isActive = true
        
        self.insertSubview(slider, at: 1)
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.widthAnchor.constraint(equalToConstant: (SCREEN_WIDTH/2).rounded()).isActive = true
        slider.heightAnchor.constraint(equalToConstant: 22.0).isActive = true
        slider.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        slider.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10.0).isActive = true
        
        self.insertSubview(label, at: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: slider.topAnchor, constant: -10.0).isActive = true
        label.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        label.heightAnchor.constraint(equalToConstant: 34.0).isActive = true
        
        layoutIfNeeded()
    }
}
