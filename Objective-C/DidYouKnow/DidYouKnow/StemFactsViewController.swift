//
//  StemFactsViewController.swift
//  DidYouKnow
//
//  Created by Taha Abbasi on 7/9/15.
//  Copyright (c) 2015 TahaAbbasi. All rights reserved.
//

import UIKit

class StemFactsViewController: UIViewController, FactBookProtocolSwift {
    
    @IBOutlet var stemFactLabel: UILabel!
    @IBOutlet var stemFactButton: UIButton!
    
    
    var spinner : UIActivityIndicatorView = UIActivityIndicatorView()
    
    @IBOutlet var toolBar: UIToolbar!
    
    
    var networkAvailable : Bool = true
    
    var colorWheel : ColorWheel = ColorWheel()
    var factBook : FactBookSwift = FactBookSwift()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        factBook.delegate = self
        
        factBook.getFactsFromServer()
        
        spinner = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        spinner.center = self.view.center
        self.view.addSubview(spinner)
        spinner.startAnimating()
        
        
        var randomColor : UIColor = colorWheel.getColor()
        self.view.backgroundColor = randomColor
        self.stemFactButton.tintColor = randomColor
        self.toolBar.barTintColor = UIColor.whiteColor()
        self.toolBar.tintColor = randomColor
        
        
        self.stemFactLabel.text = "Welcome To Fun Facts By Taha, Tuba, Janelle & Deshaun."
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func showStemFact() {
        
        if (networkAvailable) {
            
            var randomColor : UIColor = colorWheel.getColor()
            self.view.backgroundColor = randomColor
            self.stemFactButton.tintColor = randomColor
            self.toolBar.tintColor = randomColor
            
            
            // setting the fact when the fact button is clicked
            self.stemFactLabel.text = factBook.getStemFacts(self)
            
            
        } else {
            self.errorDownloadingFacts()
        }
        
    }
    
    
    @IBAction func goHome(sender: AnyObject) {
        
        var topviewController = UIApplication.sharedApplication().keyWindow?.rootViewController
        
        topviewController?.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    // MARK: - FactBookProtocol methods
    
    func factsAreReady() {
        
        // setting the first fact after facts are downloaded
        self.stemFactLabel.text = factBook.getStemFacts(self)
        
        // remove the spinner
        spinner.removeFromSuperview()
        
    }
    
    func errorDownloadingFacts() {
        
        
        networkAvailable = false
        
        self.stemFactLabel.text = "Error getting facts"
        
        var alert : AlertView = AlertView()
        
        var alertController : UIAlertController = alert.alert(alertTitle: "Error Downloading Facts", alertMessage: "Sorry, there was an error downloading facts. Please try restarting the app, or try again later.")
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
        
        
    }
    
}
