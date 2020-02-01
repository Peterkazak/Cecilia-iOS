//
//  DrawViewController.swift
//  Cecilia
//
//  Created by Peter Kazakov on 31.01.2020.
//  Copyright © 2020 Peter Kazakov. All rights reserved.
//

import UIKit
import MaLiang
import SDWebImage
import ColorThiefSwift

class DrawViewController: UIViewController {
    
    private var originalImage = UIImageView()
    private let canvas = Canvas(frame: CGRect(origin: .zero, size: SCREEN_SIZE))
    private let palette = PaletteView(frame: .zero)
    private let brushSizeSlider = Slider()
    private var brush: Brush?
    
    // MARK: - ViewController override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        NotificationCenter.default.addObserver(self, selector: #selector(setBrushColor(notification:)), name: NSNotification.Name(rawValue: "setPaletteItem"), object: nil)
        
        originalImage = UIImageView()
        originalImage.backgroundColor = .clear
        originalImage.alpha = 0.8
        originalImage.contentMode = .scaleAspectFill
        originalImage.clipsToBounds = true
        
        let url = URL(string: "https://www.artsalonholland.nl/uploads/illustraties-groot/1eef1ea5-8e64-4f62-b8de-da8ec1600d27/3012930105/Johannes-vermeer-het-meisje-met-de-parel-art-salon-holland.jpg")!
        
        originalImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
        originalImage.sd_setImage(with: url) { (image, error, cache, urls) in
            if error != nil {
                self.originalImage.image = image
            } else {
                self.originalImage.image = image
                
                guard let colors = ColorThief.getPalette(from: image!, colorCount: self.palette.colors.count, quality: 1, ignoreWhite: false) else {
                    return
                }
                
                for i in 0..<7 { self.palette.colors[i] = colors[i].makeUIColor() }
                
                self.palette.reloadColors()
            }
        }
        
        canvas.backgroundColor = .clear
        
        brushSizeSlider.setValue(0.5, animated: false)
        brushSizeSlider.addTarget(self, action: #selector(brushSizeSliderAction(_:)), for: .valueChanged)
        
        subviewsSetup()
        brushSetup()
    }
    
    @objc func setBrushColor(notification: NSNotification) {
        if let item = notification.userInfo?["paletteItem"] as? UIColor {
            self.brush?.color = item
        }
    }
    
    // MARK: - DrawViewController methods
    private func registerBrush(with imageName: String) throws -> Brush {
        let texture = try canvas.makeTexture(with: UIImage(named: imageName)!.pngData()!)
        return try canvas.registerBrush(name: imageName, textureID: texture.id)
    }
    
    private func brushSetup() {
        do {
            brush = try registerBrush(with: "brush")
            brush!.rotation = .ahead
            brush!.pointSize = 35.0
            brush!.pointStep = 1.0
            brush!.forceSensitive = 0.2
            brush!.forceOnTap = 1.2
            brush!.use()
        } catch {
            print("Error: Can't register brush")
        }
    }
    
    // MARK: - Event handlers
    @objc private func brushSizeSliderAction(_ sender: Slider) {
        self.brush?.pointSize = CGFloat(brushSizeSlider.value * 100.0)
    }
}

// MARK: - SubviewProtocol protocol implementation
extension DrawViewController: SubviewProtocol {
    func subviewsSetup() {
        view.insertSubview(originalImage, at: 0)
        originalImage.translatesAutoresizingMaskIntoConstraints = false
        originalImage.widthAnchor.constraint(equalToConstant: SCREEN_WIDTH).isActive = true
        originalImage.heightAnchor.constraint(equalToConstant: (SCREEN_WIDTH + 200.0).rounded()).isActive = true
        originalImage.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        originalImage.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        
        view.insertSubview(canvas, at: 1)
        canvas.frame = view.frame
        
        view.insertSubview(palette, at: 2)
        palette.translatesAutoresizingMaskIntoConstraints = false
        palette.topAnchor.constraint(equalTo: originalImage.bottomAnchor).isActive = true
        palette.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        
        view.insertSubview(brushSizeSlider, at: 2)
        brushSizeSlider.translatesAutoresizingMaskIntoConstraints = false
        brushSizeSlider.widthAnchor.constraint(equalToConstant: SCREEN_WIDTH - 40.0).isActive  = true
        brushSizeSlider.heightAnchor.constraint(equalToConstant: 50.0).isActive  = true
        brushSizeSlider.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        brushSizeSlider.topAnchor.constraint(equalTo: palette.bottomAnchor).isActive = true
        
        self.view.layoutIfNeeded()
    }
}
