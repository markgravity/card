//
//  Card.swift
//  Card
//
//  Created by Mark G on 9/21/19.
//  Copyright © 2019 Mark G. All rights reserved.
//

import UIKit

open class Card: UIView {
    public static let Config = CardConfig()
    public var isFullScreen = false
    
    @IBInspectable public var radius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = radius
        }
    }
    @IBOutlet public weak var backgroundImageView: UIImageView!
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        backgroundImageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
}

