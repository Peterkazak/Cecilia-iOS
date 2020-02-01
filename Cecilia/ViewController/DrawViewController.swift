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
//    private let canvas = ScrollableCanvas(frame: CGRect(origin: .zero, size: SCREEN_SIZE))
    private let canvas = Canvas(frame: CGRect(origin: .zero, size: SCREEN_SIZE))
    private let palette = PaletteView(frame: .zero)
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
                
                guard let colors = ColorThief.getPalette(from: image!, colorCount: 7, quality: 1, ignoreWhite: true) else {
                    return
                }
                
                for i in 0..<6 { self.palette.colors[i] = colors[i].makeUIColor() }
                
                self.palette.collectionView.reloadData()
            }
        }
        
        canvas.backgroundColor = .clear
                
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
            brush!.pointStep = 2.0
            brush!.forceSensitive = 0.2
            brush!.color =  UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.1)
            brush!.forceOnTap = 0.5
            brush!.use()
        } catch {
            print("Error: Can't register brush")
        }
    }
    
    // MARK: - Event handlers
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
        
        self.view.layoutIfNeeded()
    }
}
