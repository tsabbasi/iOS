//
//  PostImageViewController.swift
//  Moments
//
//  Created by Taha Abbasi on 10/28/15.
//  Copyright © 2015 TahaAbbasi. All rights reserved.
//

import UIKit
import Parse

//MARK: Choosing Image Delegates being added
class PostImageViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {

    
    //MARK: - Spinners and Alerts
    
    //MARK: Spinner
    var activityIndicator : UIActivityIndicatorView = UIActivityIndicatorView()
    
    //MARK: Alert
    
    func displayAlert(title: String, message: String) {
        
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
//        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
//            
//            self.dismissViewControllerAnimated(true, completion: nil)
//            
//        }))
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }

    
    //MARK: - Outlets and Actions
    
    //MARK: Outlets
    
    @IBOutlet var imageToPost: UIImageView!
    @IBOutlet var message: UITextField!
    @IBOutlet var keyboardHeightLayoutConstraint: NSLayoutConstraint!
    
    
    
    //MARK: Actions
    @IBAction func chooseImage(sender: AnyObject) {
        
        //MARK: - Choosing Image
        
        var image = UIImagePickerController()
        image.delegate = self
        
        //TODO: - Give user option to choose image source Camera or Photo Library
        image.sourceType = UIImagePickerControllerSourceType.Camera
        image.allowsEditing = true

        self.presentViewController(image, animated: true, completion: nil)
        
        
    }
    
    //MARK: DidFinishPickingImage method
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        imageToPost.contentMode = UIViewContentMode.ScaleAspectFit
        
        imageToPost.image = image
        
        
        
    }
    
    
    //MARK: - Posting Image
    
    @IBAction func postImage(sender: AnyObject) {
        
        
        activityIndicator = UIActivityIndicatorView(frame: self.view.frame)
        activityIndicator.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        //MARK: validation for if image was selected, and if message was typed.
        
        let defaultImage = UIImageJPEGRepresentation(UIImage(named: "Blank_woman_placeholder.svg")!, 0.2)
        
        
        let imageData = UIImageJPEGRepresentation(imageToPost.image!, 0.2)
        
        
        
        if imageData == defaultImage {
            
            displayAlert("Choose an image", message: "Please choose an image to upload")
            
            self.activityIndicator.stopAnimating()
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            
        } else {
            
            var post = PFObject(className: "Post")
            
            
            if message.text == "" {
                
                displayAlert("Enter a message", message: "Please enter a message")
                
                self.activityIndicator.stopAnimating()
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
                
            } else {
                
                post["message"] = message.text
                
                post["userId"] = PFUser.currentUser()!.objectId!
                
                
                let imageFile = PFFile(name: "image.png", data: imageData!)
                
                post["imageFile"] = imageFile
                
                post.saveInBackgroundWithBlock { (success, error) -> Void in
                    
                    self.activityIndicator.stopAnimating()
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    
                    var errorMessage = "Please try again later"
                    
                    if error == nil {
                        
                        self.displayAlert("Image Posted!", message: "Your image has been posted successfully")
                        
                        self.imageToPost.image = UIImage(named: "Blank_woman_placeholder.svg")
                        
                        self.message.text = ""
                        
                    } else {
                        
                        if let errorString = error!.userInfo["error"] as? String {
                            
                            //MARK: GenericErrorMessage
                            // here if we were able to get an error message string from parse, we will use that, otherwise the errorMessage will remain the generic 'Please try again later' message.
                            
                            errorMessage = errorString
                            
                        }
                        
                        self.displayAlert("Could not post image", message: errorMessage)
                        
                    }
                    
                }
                
            }
        }
    }
    
    
    //MARK: - Text Field Response Methods
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        message.resignFirstResponder()
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
            self.keyboardHeightLayoutConstraint?.constant = endFrame?.size.height ?? 0.0
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
            self.keyboardHeightLayoutConstraint?.constant = 103
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
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShowNotification:", name: UIKeyboardWillChangeFrameNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil)
        
        message.delegate = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
