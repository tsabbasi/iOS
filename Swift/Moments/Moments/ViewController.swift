//
//  ViewController.swift
//  Moments
//
//  Created by Taha Abbasi on 10/28/15.
//  Copyright © 2015 TahaAbbasi. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController, UITextFieldDelegate {
    
    
    
    //MARK: - Spinners and Alerts
    
    //MARK: Spinner
    var activityIndicator : UIActivityIndicatorView = UIActivityIndicatorView()
    
    //MARK: Alert
    
    func displayAlert(title: String, message: String) {
        
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - Outlets and IBActions
    
    //MARK: Outlets
    
    @IBOutlet var username: UITextField!
    
    @IBOutlet var password: UITextField!
    
    @IBOutlet var proceed: UIButton!
    
    @IBOutlet var changeView: UIButton!
    
    @IBOutlet var registeredText: UILabel!
    
    @IBOutlet var keyboardHeightLayoutConstraint: NSLayoutConstraint!
    
    //MARK: Actions
    
    //MARK:SignUp
    
    @IBAction func signUp(sender: AnyObject) {
        
        //MARK: SignUp Field Validation
        
        if username.text == "" || password.text == "" {

            displayAlert("Error In Form", message: "Please enter a username and password")
            
        } else {
            
            // Adding the spinner to the view prior to starting the signup operation. Also stopping the app from accepting interaction events while this work is being done.
            activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            
            // Generic error message to be used later if Sign Up fails and we cannot retrieve the errorString Go to Mark GenericErrorMessage to see its usage
            var errorMessage = "Please try again later"
            
            // Checking if app is in SignUp Mode or Login Mode and then trigerring the appropriate Parse commands
            
            if signupActive == true {
                
                //MARK: SignUp Parse Code
                
                // Now creating the user (PFUser) object in parse and setting the user name and password in the Parse database by retrieving the data entered by the user in the username and password text fields in the app.
                
                var user = PFUser()
                user.username = username.text
                user.password = password.text
                
                
                
                user.signUpInBackgroundWithBlock({ (success, error) -> Void in
                    
                    // Stop the activity indicator at this point regardless of success or failure
                    self.activityIndicator.stopAnimating()
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    
                    if error == nil {
                        
                        
                        // Since the error was equal to nil the Sign Up was successful
                        self.performSegueWithIdentifier("login", sender: self)
                        
                    } else {
                        
                        
                        // Since the error was not nil, there was an error in Sign Up.
                        // We are attempting to retrieve the error by first checking if an error was received using if let
                        
                        if let errorString = error!.userInfo["error"] as? String {
                            
                            //MARK: GenericErrorMessage
                            // here if we were able to get an error message string from parse, we will use that, otherwise the errorMessage will remain the generic 'Please try again later' message.
                            
                            errorMessage = errorString
                            
                        }
                        
                        // Displaying the error to the user in an alert
                        self.displayAlert("Failed SignUp", message: errorMessage)
                        
                    }
                    
                })
                
            } else {
                
                //MARK: Login Parse Code
                PFUser.logInWithUsernameInBackground(username.text!, password: password.text!, block: { (user, error) -> Void in
                    
                    // Stop the activity indicator at this point regardless of success or failure
                    self.activityIndicator.stopAnimating()
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    
                    if user != nil {
                        
                        // Logged In!
                        self.performSegueWithIdentifier("login", sender: self)
                        
                    } else {
                        
                        // Since the error was not nil, there was an error in Sign Up.
                        // We are attempting to retrieve the error by first checking if an error was received using if let
                        
                        if let errorString = error!.userInfo["error"] as? String {
                            
                            //MARK: GenericErrorMessage
                            // here if we were able to get an error message string from parse, we will use that, otherwise the errorMessage will remain the generic 'Please try again later' message.
                            
                            errorMessage = errorString
                            
                        }
                        
                        // Displaying the error to the user in an alert
                        self.displayAlert("Failed Login", message: errorMessage)
                        
                    }
                    
                })
                
            }
                
        }
    }
    
    //MARK: LogIn
    
    // This is a variable that will be used to check if the app is in Login Mode or SignUp mode.
    var signupActive = true
    
    @IBAction func logIn(sender: AnyObject) {
        
        // When the LogIn button is pressed, we will be switching the text and view options to LogIn Options vs SignUp options.
        // We will also be changing the actual Login button text to "SignUp" so the user can toggle back to the SignUp View from the LogIn view.
        
        // Checking the mode of the app
        
        if signupActive == true {
            
            proceed.setTitle("Login", forState: UIControlState.Normal)
            
            registeredText.text = "Not registered?"
            
            changeView.setTitle("Sign Up", forState: UIControlState.Normal)
            
            signupActive = false
            
        } else {
            
            proceed.setTitle("Sign Up", forState: UIControlState.Normal)
            
            registeredText.text = "Already Registered?"
            
            changeView.setTitle("Login", forState: UIControlState.Normal)
            
            signupActive = true
            
        }
        
    }
    
    
    
    
    //MARK: -
    
    
    //MARK: - Checking weather the user is logged in already
    
    
    override func viewDidAppear(animated: Bool) {
        
        // This will check if the user is already logged in, if so it will perform the segue with the identifier "login"
        // and take the user to the User List view
        
        if PFUser.currentUser() != nil {
            
            self.performSegueWithIdentifier("login", sender: self)
            
        }
        
    }
    
    
    //MARK: - Text Field Response Methods
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        username.resignFirstResponder()
        password.resignFirstResponder()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
        
    }
    
    
    //MARK: - Keyboard appearance and dissappearance handling view
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
    //MARK: Keyboard Show View Update
    func keyboardWillShowNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue()
            let duration:NSTimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.unsignedLongValue ?? UIViewAnimationOptions.CurveEaseInOut.rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            self.keyboardHeightLayoutConstraint?.constant = (((endFrame?.size.height)!) * -1)/2
            UIView.animateWithDuration(duration,
                delay: NSTimeInterval(0),
                options: animationCurve,
                animations: { self.view.layoutIfNeeded() },
                completion: nil)
        }
    }
    
    //MARK: Keyboard Hide View Update
    func keyboardWillHide(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue()
            let duration:NSTimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.unsignedLongValue ?? UIViewAnimationOptions.CurveEaseInOut.rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            self.keyboardHeightLayoutConstraint?.constant = -30
            UIView.animateWithDuration(duration,
                delay: NSTimeInterval(0),
                options: animationCurve,
                animations: { self.view.layoutIfNeeded() },
                completion: nil)
        }
    }
    
    
    
    
    
    //MARK: -
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //MARK: Keyboard Observers
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShowNotification:", name: UIKeyboardWillChangeFrameNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil)
        
        username.delegate = self
        password.delegate = self
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

