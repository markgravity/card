//
//  DetailViewController.swift
//  Demo
//
//  Created by Mark G on 9/22/19.
//  Copyright © 2019 Mark G. All rights reserved.
//

import UIKit
import Card
class DetailViewController: CardDetailViewController {
    @IBOutlet weak var textView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func layout(in rect: CGRect) {
        super.layout(in: rect)
        textView.frame = contentView.bounds
    }

}
