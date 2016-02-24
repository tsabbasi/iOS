//
//  ViewController.swift
//  DidYouKnow
//
//  Created by Taha Abbasi on 5/25/15.
//  Copyright (c) 2015 TahaAbbasi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var funFactLabel: UILabel!
    @IBOutlet weak var funFactButton: UIButton!
    
    let factBook = FactBook()
    let colorWheel = ColorWheel()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        funFactLabel.text = factBook.randomFact()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func showFunFact() {
        funFactLabel.text = factBook.randomFact()
        let randomColor = colorWheel.randomColor()
        view.backgroundColor = randomColor
        funFactButton.tintColor = randomColor
        
    }
}

