//
//  JokesViewController.swift
//  DidYouKnow
//
//  Created by Taha Abbasi on 7/9/15.
//  Copyright (c) 2015 TahaAbbasi. All rights reserved.
//

import UIKit

class JokesViewController: UIViewController, FactBookProtocolSwift {
    
    @IBOutlet var jokesLabel: UILabel!
    @IBOutlet var jokesButton: UIButton!
    @IBOutlet var favorite: UIImageView!
    
    
    var spinner : UIActivityIndicatorView = UIActivityIndicatorView()
    
    @IBOutlet var toolBar: UIToolbar!
    
    
    var networkAvailable : Bool = true
    
    var colorWheel : ColorWheel = ColorWheel()
    var factBook : FactBookSwift = FactBookSwift()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("favoriteTapped:"))
        favorite.userInteractionEnabled = true
        favorite.addGestureRecognizer(tapGestureRecognizer)
        
        factBook.delegate = self
        
        factBook.getFactsFromServer()
        
        spinner = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        spinner.center = self.view.center
        self.view.addSubview(spinner)
        spinner.startAnimating()
        
        
        let randomColor : UIColor = colorWheel.getColor()
        self.view.backgroundColor = randomColor
        self.jokesButton.tintColor = randomColor
        self.toolBar.barTintColor = UIColor.whiteColor()
        self.toolBar.tintColor = randomColor
        
        
        self.jokesLabel.text = "Welcome To Fun Facts By Taha, Tuba, Janelle & Deshaun."
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func favoriteTapped(img: AnyObject) {
        
        //        self.view.makeToast(self.funFactLabel.text!)
        //        self.view.makeToast("Favorited!")
        
        let saveFavoriteResult = factBook.storeFacts(self.jokesLabel.text!)
        
        switch saveFavoriteResult {
        case "Favorite Added":
            toasting("Favorited", message: "Click Home - > My Favorites to view your favorited items.", duration: 1.5, imageName: "minion-success.png")
            
        case "Already Favorite":
            toasting("Oops!", message: "Looks like this fact is already in your Favorites.\n\nClick Home - > My Favorites to view your favorited items.", duration: 5.0, imageName: "minion-duh.png")
            
        case "Failed To Save":
            toasting("Oh No!", message: "Looks like someone's been sleeping on the job...We couldn't save your fact. Please try again.", duration: 3.0, imageName: "minion-fail.png")
            
        default:
            toasting("Umm..", message: "Something went wrong, lets try that again", duration: 3.0, imageName: "minion-fail.png")
        }
    }
    
    
    
    
    func toasting(title: String, message: String, duration: NSTimeInterval, imageName: String) {
        
        self.view.makeToast(message, duration: duration, position: .Bottom, title: title, image: UIImage(named: imageName), style:nil) { (didTap: Bool) -> Void in
            if didTap {
//                print("completion from tap")
            } else {
//                print("completion without tap")
            }
            
        }
    }
    
    
    @IBAction func showJoke() {
        
        if (networkAvailable) {
            
            let randomColor : UIColor = colorWheel.getColor()
            self.view.backgroundColor = randomColor
            self.jokesButton.tintColor = randomColor
            self.toolBar.barTintColor = UIColor.whiteColor()
            self.toolBar.tintColor = randomColor
            
            
            // setting the fact when the fact button is clicked
            self.jokesLabel.text = factBook.getJokes(self)
            
        } else {
            self.errorDownloadingFacts()
        }
        
    }
    
    
    @IBAction func goHome(sender: AnyObject) {
        
        let topviewController = UIApplication.sharedApplication().keyWindow?.rootViewController
        
        topviewController?.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    // MARK: - FactBookProtocol methods
    
    func factsAreReady() {
        
        // setting the first fact after facts are downloaded
        self.jokesLabel.text = factBook.getJokes(self)
        
        // remove the spinner
        spinner.removeFromSuperview()
        
    }
    
    func errorDownloadingFacts() {
        
        
        networkAvailable = false
        
        self.jokesLabel.text = "Error getting facts"
        
        let alert : AlertView = AlertView()
        
        let alertController : UIAlertController = alert.alert(alertTitle: "Error Downloading Facts", alertMessage: "Sorry, there was an error downloading facts. Please try restarting the app, or try again later.")
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
        
        
    }
    
}
