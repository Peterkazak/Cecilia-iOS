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
    
    private var timerView = TimerView()
    private var originalImage = UIImageView()
    private let canvas = Canvas(frame: CGRect(origin: .zero, size: CANVAS_SIZE))
    private let palette = PaletteView(frame: .zero)
    private let brushSizeSwitch = BrushSizeSwitch(frame: .zero)
    private var brush: Brush?
    
    var timer = Timer()
    var timerCounter = 20
    
    // MARK: - ViewController override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        NotificationCenter.default.addObserver(self, selector: #selector(setBrushColor(notification:)), name: NSNotification.Name(rawValue: "setPaletteItem"), object: nil)
        
        timerView.backgroundColor = .cyan
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerCounterHandler), userInfo: nil, repeats: true)
        
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
        
        brushSizeSwitch.addTarget(self, action: #selector(brushSizeSwitchAction(_:)), for: .valueChanged)
        
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
    
    private func gameOver() {
        let viewController = ResultViewController()
        viewController.delegate = self
        viewController.lhsImage = originalImage.image!
        viewController.rhsImage = UIImage.init(data: UIImage.blendImages(originalImage.image!, canvas.snapshot()!)!)!
        viewController.modalPresentationStyle = .overFullScreen
        present(viewController, animated: true, completion: nil)
    }
        
    // MARK: - Event handlers
    @objc private func brushSizeSwitchAction(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0: self.brush?.pointSize = 8.0
        case 1: self.brush?.pointSize = 22.0
        case 2: self.brush?.pointSize = 45.0
        default: break
        }
    }
    
    @objc private func timerCounterHandler() {
        if timerCounter > 0 {
            timerCounter -= 1
            timerView.label.text = "\(timerCounter) sec"
        } else {
            gameOver()
        }
    }
}

// MARK: - SubviewProtocol protocol implementation
extension DrawViewController: SubviewProtocol {
    func subviewsSetup() {
        
        view.insertSubview(timerView, at: 0)
        timerView.translatesAutoresizingMaskIntoConstraints = false
        timerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        timerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.insertSubview(originalImage, at: 0)
        originalImage.translatesAutoresizingMaskIntoConstraints = false
        originalImage.widthAnchor.constraint(equalToConstant: SCREEN_WIDTH).isActive = true
        originalImage.heightAnchor.constraint(equalToConstant: CANVAS_SIZE.height).isActive = true
        originalImage.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        originalImage.topAnchor.constraint(equalTo: timerView.bottomAnchor).isActive = true
        
        view.insertSubview(canvas, at: 1)
        canvas.frame.origin = .zero
        
        view.insertSubview(palette, at: 2)
        palette.translatesAutoresizingMaskIntoConstraints = false
        palette.topAnchor.constraint(equalTo: originalImage.bottomAnchor).isActive = true
        palette.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        
        view.insertSubview(brushSizeSwitch, at: 2)
        brushSizeSwitch.translatesAutoresizingMaskIntoConstraints = false
        brushSizeSwitch.topAnchor.constraint(equalTo: palette.bottomAnchor).isActive = true
        brushSizeSwitch.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        brushSizeSwitch.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        brushSizeSwitch.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        
        self.view.layoutIfNeeded()
    }
}

extension DrawViewController: ResultViewControllerDelegate {
    func restartGame() {
        self.canvas.clear()
        self.timer.invalidate()
        self.timerCounter = 20
        self.timerView.label.text = "\(self.timerCounter) sec"
    }
}
