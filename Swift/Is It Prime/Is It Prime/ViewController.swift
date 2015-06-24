//
//  ViewController.swift
//  Is It Prime
//
//  Created by Taha Abbasi on 6/11/15.
//  Copyright (c) 2015 TahaAbbasi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var numberInputTextField: UITextField?
    @IBOutlet weak var resultLabel: UILabel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func isItPrimeButtonPressed() {
        
        if let number = numberInputTextField?.text.toInt() {
            isPrime(number)
        } else {
            showAlert()
        }
        
    }
    
    func isPrime(num: Int) {
        
        if num == 1 {
            resultLabel?.text = "Not a Prime Number"
        } else if num == 2 {
            resultLabel?.text = "Prime Number"
        } else if num == 0 {
            resultLabel?.text = "Zero is neither prime nor composite. The number 0 divided by any number except for 0 is 0. This would suggest that 0 is a composite number, but it does not have factors in the way that other composite numbers do. Prime and composite numbers must be positive, so 0 is neither prime nor composite."
        }
        
        if num != 2 && num != 1 && num != 0 {
            var isPrimeNumber = true
            for i in 2..<num {
                if num % i == 0 {
                    resultLabel?.text = "Not a Prime Number"
                    isPrimeNumber = false
                } else {
                    resultLabel?.text = "Prime Number"
                    isPrimeNumber = true
                }
            }
            
        }
    }
    
    func showAlert() {
        var alert = UIAlertController(title: "Oops!", message: "Please enter a number and try again.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }

}

