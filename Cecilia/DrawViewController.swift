//
//  DrawViewController.swift
//  Cecilia
//
//  Created by Peter Kazakov on 31.01.2020.
//  Copyright © 2020 Peter Kazakov. All rights reserved.
//

import UIKit
import MaLiang

class DrawViewController: UIViewController {
    
    let canvas = Canvas(frame: CGRect(origin: .zero, size: SCREEN_SIZE))
    
    var color: UIColor { return UIColor(red: 144, green: 144, blue: 144, alpha: 0.5) }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        subviewsSetup()
        brushSetup()
    }
    
    private func registerBrush(with imageName: String) throws -> Brush {
        let texture = try canvas.makeTexture(with: UIImage(named: imageName)!.pngData()!)
        return try canvas.registerBrush(name: imageName, textureID: texture.id)
    }
    
    private func brushSetup() {
        do {
            let brush = try registerBrush(with: "brush")
            brush.rotation = .ahead
            brush.pointSize = 35.0
            brush.pointStep = 2.0
            brush.forceSensitive = 0.2
            brush.color =  UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.1)
            brush.forceOnTap = 0.5
            brush.use()
        } catch {
            print("Error: Can't register brush")
        }
    }
}

extension DrawViewController: ViewControllerProtocol {
    func subviewsSetup() {
        self.view.addSubview(canvas)
        canvas.frame = self.view.frame
    }
}
