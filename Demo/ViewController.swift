//
//  ViewController.swift
//  Demo
//
//  Created by Mark G on 9/22/19.
//  Copyright © 2019 Mark G. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let controller = FirstViewController()
        present(controller, animated: true, completion: nil)
    }

}

