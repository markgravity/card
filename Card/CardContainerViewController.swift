//
//  CardContainerViewController.swift
//  Card
//
//  Created by Mark G on 9/21/19.
//  Copyright © 2019 Mark G. All rights reserved.
//

import UIKit

open class CardContainerViewController: UIViewController {
    public var presentingCard: Card?
    
    open override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    open func present(_ card: Card, on viewController: CardDetailViewController) {
        let navigationController = CardNavigationViewController(rootViewController: viewController)
        navigationController.card = card
        presentingCard = card
        present(navigationController, animated: true, completion: nil)
    }
}
