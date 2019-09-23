//
//  UIView.swift
//  Card
//
//  Created by Mark G on 9/22/19.
//  Copyright © 2019 Mark G. All rights reserved.
//

import UIKit

extension UIView {

    func autoPinEdgesToSuperviewEdges() {
        translatesAutoresizingMaskIntoConstraints = false
        superview?.addConstraints([
            .init(item: self, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .top, multiplier: 1, constant: 0),
            .init(item: self, attribute: .bottom, relatedBy: .equal, toItem: superview, attribute: .bottom, multiplier: 1, constant: 0),
            .init(item: self, attribute: .trailing, relatedBy: .equal, toItem: superview, attribute: .trailing, multiplier: 1, constant: 0),
            .init(item: self, attribute: .leading, relatedBy: .equal, toItem: superview, attribute: .leading, multiplier: 1, constant: 0)
        ])
    }

}
