/**
* Copyright (c) 2015-present, Parse, LLC.
* All rights reserved.
*
* This source code is licensed under the BSD-style license found in the
* LICENSE file in the root directory of this source tree. An additional grant
* of patent rights can be found in the PATENTS file in the same directory.
*/

import UIKit
import Parse

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    //MARK: - Spinners and Alerts
    
    ////////////////
    // Creating and using spinners and alerts
    ///////////////
    
    
    //MARK: Spinners
    
    var activityIndicator : UIActivityIndicatorView = UIActivityIndicatorView()
    
    @IBAction func pause(sender: AnyObject) {
        
        activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        // This part stops the user from being able to do anything in the app while the activity indicator is still displayed
        // This is useful in some cases, but for the purposes of this app I am commenting it out
//        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
    }
    
    @IBAction func restore(sender: AnyObject) {
        
        
        activityIndicator.stopAnimating()
//        UIApplication.sharedApplication().endIgnoringInteractionEvents()
        
    }
    
    
    //MARK: Alerts
    
    @available(iOS 8.0, *)
    @IBAction func createAlert(sender: AnyObject) {
        
        var alert = UIAlertController(title: "Hey there!", message: "Are you sure?", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
        }))
        
        
        self.presentViewController(alert, animated: true, completion: nil)
        
        
    }
    
    
    
    //MARK: -
    
    //MARK: - Retrieving Images form Photo Library and Camera
    
    ////////////////
    // Retrieving Images form Photo Library and Camera
    ///////////////
    
    // In order to navigate from one app to the other, in our case from our app to the photos app. We need the UINavigationControllerDelegate.
    // Additinally to pick the image we need the UIImagePickerControllerDelegate.
    // So make sure to import UINavigationControllerDelegate, UIImagePickerControllerDelegate
    
    
    
    
    @IBOutlet var importedImage: UIImageView!
    
    
    //MARK: action associated with import Image button
    @IBAction func importImage(sender: AnyObject) {
        
        
        // This is code to take the image from the camera
        
        var image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.Camera
        image.allowsEditing = false
        
        self.presentViewController(image, animated: true, completion: nil)
        
    }
    
    
    // This is code that will get trigered once the image is picked
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        print("Image Selected")
        
        
        // Dismissing the UIImagePicker Controller
        self.dismissViewControllerAnimated(true, completion: nil)
        
        
        // Setting the importedImage imageView to the imported image from the camera
        importedImage.image = image
        
    }
    
    
    //MARK: -
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        ////////////////
        // Parse Saving an object example
        ///////////////
        
        
        //MARK: - Creation And Saving
        
//        var product = PFObject(className: "Products")
//        
//        product["name"] = "Ice Cream"
//        
//        product["description"] = "Vanilla Chocolate Cone"
//        
//        product["price"] = 4.99
//        
//        product.saveInBackgroundWithBlock { (success, error) -> Void in
//            
//            if (success) {
//                
//                print("Product saved with ID \(product.objectId)")
//                
//            } else {
//                
//                print(error)
//                
//            }
//            
//        }
        
        
        //MARK: - Retrieving and Updating Objects
        
//        var query = PFQuery(className: "Products")
//        
//        query.getObjectInBackgroundWithId("68QwKkUueK") { (object : PFObject?, error : NSError? ) -> Void in
//            
//            if error != nil {
//                
//                print(error)
//                
//            } else if let product = object {
//                
//                // Simply print the retrieved Object
//                
////                print(object)
//                
//                // Print a specific item from the retrieved object, by using the key to look up the item
//                
////                print(object?.objectForKey("description"))
//                
//                // Updating the retrieved objects values to something else
//                
//                product["description"] = "Veggie Lovers"
//                
//                product["price"] = 12.99
//                
//                product.saveInBackground()
//
//                
//            }
//            
//        }
        
        
        
        //MARK: -
        
        
        
    }

    
}
