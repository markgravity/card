//
//  CardDetailViewController.swift
//  Card
//
//  Created by Mark G on 9/23/19.
//  Copyright © 2019 Mark G. All rights reserved.
//

import UIKit

open class CardDetailViewController: UIViewController, CardContentProvider {
    
    public var cardNavigationController: CardNavigationViewController?
    var originalCardHeight: CGFloat!
    
    @IBOutlet public weak var contentView: UIView!
    @IBOutlet public weak var card: Card!
    @IBOutlet public weak var scrollView: UIScrollView!
    
    open override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        originalCardHeight = card.frame.height
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        }
        automaticallyAdjustsScrollViewInsets = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [unowned self] in
            self.cardNavigationController?.dismiss(animated: true)
        }
    }
    

    open func layout(in rect: CGRect) {
        var cardHeight: CGFloat = rect.height
        switch view.tag {
        case 1:
            cardHeight = originalCardHeight - 32
            
        case 2:
            cardHeight = originalCardHeight
            
        case 3:
            cardHeight = rect.height > originalCardHeight ? originalCardHeight : rect.height
        default:
            break
        }
        card.translatesAutoresizingMaskIntoConstraints = true
        contentView.translatesAutoresizingMaskIntoConstraints = true
        
        // Card
        card.frame.origin = .zero
        card.frame.size = CGSize(width: rect.width, height: cardHeight)
        
        // Content View
        contentView.frame.origin = CGPoint(x: 0, y: cardHeight)
        contentView.frame.size = CGSize(width: rect.width, height: rect.height - cardHeight)
        
        // Scroll View
        scrollView.frame.origin = .zero
        scrollView.frame.size = rect.size
        scrollView.contentSize = rect.size
    }
}
