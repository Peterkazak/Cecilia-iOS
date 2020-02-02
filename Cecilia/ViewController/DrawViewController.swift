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
    private var canvas = Canvas(frame: CGRect(origin: .zero, size: CANVAS_SIZE))
    private let palette = PaletteView(frame: .zero)
    private let brushSizeSwitch = BrushSizeSwitch(frame: .zero)
    private var brush: Brush?
    
    private let pictureView = PictureView()
    private var sourceImage: RandomSource!

    var timer: DispatchSourceTimer?
    var timerCounter = 20
    
    // MARK: - ViewController override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "bg_01")
        
        NotificationCenter.default.addObserver(self, selector: #selector(setBrushColor(notification:)), name: NSNotification.Name(rawValue: "setPaletteItem"), object: nil)
        
        canvas.backgroundColor = .clear
        pictureView.pictureImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        
        timerSetup()
        
        brushSizeSwitch.addTarget(self, action: #selector(brushSizeSwitchAction(_:)), for: .valueChanged)
        
        subviewsSetup()
        brushSetup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.restartGame()
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
    
    private func getRandomSource() {
        GameSessionService.shared.getRandomSource(completion: { (source) in
            self.sourceImage = source
            self.pictureView.pictureImageView.sd_setImage(with: URL(string: source.imageUrl)!) { (image, error, cache, urls) in
                if error != nil {
                    self.pictureView.pictureImageView.image = image
                } else {
                    self.pictureView.pictureImageView.image = image
                    
                    guard let colors = ColorThief.getPalette(from: image!, colorCount: self.palette.colors.count, quality: 1, ignoreWhite: false) else {
                        return
                    }
                    
                    for i in 0..<7 { self.palette.colors[i] = colors[i].makeUIColor() }
                    
                    self.palette.reloadColors()
                }
            }
        }) { (error) in
            print("Error: \(error.localizedDescription)")
        }
    }
    
    private func timerSetup() {
        timer = DispatchSource.makeTimerSource(queue: .main)
        timer?.schedule(deadline: .now(), repeating: 1.0)

        timer?.setEventHandler { [weak self] in
            guard let viewController = self else { return }
            
            if viewController.timerCounter > 0 {
                viewController.timerCounter -= 1
                viewController.timerView.updateTimer(value: self?.timerCounter ?? 0)
            } else {
                viewController.gameOver()
            }
        }
    }
    
    private func startTimer() {
        timer?.resume()
    }

    private func stopTimer() {
        timer?.suspend()
    }
    
    private func gameOver() {
        self.stopTimer()
        let resultImage = UIImage.init(data: UIImage.blendImages(pictureView.pictureImageView.image!, canvas.snapshot()!)!)!
        let viewController = ResultViewController()
        viewController.delegate = self
        viewController.lhsImage = pictureView.pictureImageView.image!
        viewController.rhsImage = resultImage
        viewController.imageId = sourceImage.id
        viewController.modalPresentationStyle = .overFullScreen
        
        GameSessionService.shared.storeDrawingBy(id: sourceImage.id, image: resultImage)
        
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
            timerView.updateTimer(value: timerCounter)
        } else {
            gameOver()
        }
    }
    
    @objc func setBrushColor(notification: NSNotification) {
        if let item = notification.userInfo?["paletteItem"] as? UIColor {
            self.brush?.color = item
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
        
        view.insertSubview(palette, at: 1)
        palette.translatesAutoresizingMaskIntoConstraints = false
        palette.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        palette.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        
        view.insertSubview(brushSizeSwitch, at: 2)
        brushSizeSwitch.translatesAutoresizingMaskIntoConstraints = false
        brushSizeSwitch.bottomAnchor.constraint(equalTo: palette.topAnchor, constant: -10.0).isActive = true
        brushSizeSwitch.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.0).isActive = true
        brushSizeSwitch.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20.0).isActive = true
        brushSizeSwitch.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        
        view.insertSubview(pictureView, at: 3)
        pictureView.translatesAutoresizingMaskIntoConstraints = false
        pictureView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        pictureView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        pictureView.topAnchor.constraint(equalTo: timerView.bottomAnchor, constant: 10.0).isActive = true
        pictureView.bottomAnchor.constraint(equalTo: brushSizeSwitch.topAnchor , constant: -15.0).isActive = true
        
        pictureView.insertSubview(canvas, at: 1)
        
        self.view.layoutIfNeeded()
    }
}

extension DrawViewController: ResultViewControllerDelegate {
    func restartGame() {
        self.canvas.clear()
        self.timerCounter = 20
        self.timerView.updateTimer(value: timerCounter)
        self.startTimer()
        self.getRandomSource()
    }
}
