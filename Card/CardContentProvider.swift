//
//  CardContentViewController.swift
//  Card
//
//  Created by Mark G on 9/21/19.
//  Copyright © 2019 Mark G. All rights reserved.
//

import UIKit

public protocol CardContentProvider {
    var cardNavigationController: CardNavigationViewController? { get set }
    var scrollView: UIScrollView! { get set }
    
    func layout(in rect:CGRect)
}

public protocol CardDetailProvider: CardContentProvider {
    var card: Card! { get set }
    var contentView: UIView! { get set }
}

public typealias CardContentViewController = UIViewController&CardContentProvider
