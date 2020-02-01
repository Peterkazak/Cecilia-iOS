//
//  UIImage.swift
//  Cecilia
//
//  Created by Peter Kazakov on 01.02.2020.
//  Copyright © 2020 Peter Kazakov. All rights reserved.
//

import UIKit

extension UIImage {
    class func blendImages(_ lhs: UIImage,_ rhs: UIImage) -> Data? {
        let viewRect = CGRect(origin: .zero, size: CANVAS_SIZE)
        let imgView = UIImageView(frame: viewRect)
        let imgView2 = UIImageView(frame: viewRect)

        imgView.contentMode = .scaleAspectFill
        imgView2.contentMode = .scaleAspectFit

        imgView.image = lhs
        imgView2.image = rhs

        let contentView = UIView(frame: viewRect)
        contentView.addSubview(imgView)
        contentView.addSubview(imgView2)

        UIGraphicsBeginImageContextWithOptions(CANVAS_SIZE, true, 0)
        contentView.drawHierarchy(in: contentView.bounds, afterScreenUpdates: true)
        guard let context = UIGraphicsGetImageFromCurrentImageContext(), let data = context.jpegData(compressionQuality: 1.0) else {
            return nil
        }

        UIGraphicsEndImageContext()

        return data
    }
}
