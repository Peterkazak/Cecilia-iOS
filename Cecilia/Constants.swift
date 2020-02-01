//
//  Constants.swift
//  Cecilia
//
//  Created by Peter Kazakov on 01.02.2020.
//  Copyright © 2020 Peter Kazakov. All rights reserved.
//

import UIKit

// MARK: - Get screen size
var SCREEN_SIZE: CGSize {
    get { return UIScreen.main.bounds.size }
}

var SCREEN_WIDTH: CGFloat {
    get { return UIScreen.main.bounds.width }
}

var SCREEN_HEIGHT: CGFloat {
    get { return UIScreen.main.bounds.height }
}

var CANVAS_SIZE: CGSize {
    get { return CGSize(width: SCREEN_WIDTH, height: (SCREEN_HEIGHT/1.5).rounded()) }
}
