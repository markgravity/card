//
//  FirstViewController.swift
//  Demo
//
//  Created by Mark G on 9/22/19.
//  Copyright © 2019 Mark G. All rights reserved.
//

import UIKit
import Card

class FirstViewController: CardContainerViewController {
    @IBOutlet weak var card: Card!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let controller = storyboard.instantiateViewController(withIdentifier: "\(DetailViewController.self)")
//        let nav = UINavigationController(rootViewController: controller)
//        addChild(nav)
//        view.addSubview(nav.view)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [unowned self] in
            let controller = self.storyboard!.instantiateViewController(withIdentifier: "\(DetailViewController.self)")
            self.present(self.card, on:controller as! CardDetailViewController)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
