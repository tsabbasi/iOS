//
//  ViewController.swift
//  FireBaseDemo
//
//  Created by Taha Abbasi on 2/2/16.
//  Copyright © 2016 TahaAbbasi. All rights reserved.
//

import UIKit

// 1. Import Firebase
import Firebase

// Facebook
import FBSDKLoginKit

class ViewController: UIViewController {

    
    // MARK: - Regular Signup Login and message
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view, typically from a nib.
//
//        
//        // 2. Create a root reference to your Firebase app
//        
////        var myRootRef = Firebase(url: "https://amber-inferno-4294.firebaseio.com/")
//        
//        
//        
//        
//        // TODO: - Realtime Data!!!!
//        
//        // Set a value just like this - It's json data value with no key
////        myRootRef.setValue("Realtime Data send and read")
////        
//        
//        // Retrieve data like this
////        myRootRef.observeEventType(.Value) { (snapshot : FDataSnapshot!) -> Void in
////            
////            print("\(snapshot.key) -> \(snapshot.value)")
//        
//            // it will print data in real time like this
//        // nil -> Realtime Data send and read
//        // there is no key because we didn't specify one and the value is displayed
////
////        }
//        
//        
//        // TODO: - User Signup
//        
////        myRootRef.createUser("tahaabbasi@me.com", password: "test") { (error : NSError!, result : [NSObject : AnyObject]!) -> Void in
////            
////            if error != nil {
////                
////                print("Create User Error VC \(error)")
////                
////            } else {
////                
////                // TODO: - iflet around this in prod
////                let uid = result["uid"] as? String
////                print("Successfully created user account with uid: \(uid)")
////            }
////            
////            
//        }
    
        // TODO: - User Login Regular
        
//        myRootRef.authUser("tahaabbasi@me.com", password: "test") { (error : NSError!, authData : FAuthData!) -> Void in
//            
//            if error != nil {
//                
//                print("User Login Error VC \(error)")
//                
//            } else {
//                
//                // TODO: - iflet around this in     
//                print(authData)
//                let uid = authData.uid
//                print("Successfully Logged in with UID: \(uid)")
//                
//            }
//            
//        }
        
        
        
//    }
    
    // FaceBook: - Sign up - Login
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let myRootRef = Firebase(url: "https://amber-inferno-4294.firebaseio.com/")
        let facebookLogin = FBSDKLoginManager()
//        myRootRef.unauth()
        
        let handle = myRootRef.observeAuthEventWithBlock { (authData : FAuthData!) -> Void in
            if authData != nil {
                // user authenticated
                print("User exists with \(authData)")
            } else {
                // No user is signed in
                
                facebookLogin.logInWithReadPermissions(["public_profile", "email"]) { (facebookResult : FBSDKLoginManagerLoginResult!, facebookError : NSError!) -> Void in
                    
                    if facebookError != nil {
                        print("Facebook login failed. Error \(facebookError)")
                    } else if facebookResult.isCancelled {
                        print("Facebook login was cancelled")
                    } else {
                        let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
                        
                        myRootRef.authWithOAuthProvider("facebook", token: accessToken, withCompletionBlock: { (error : NSError!, authData : FAuthData!) -> Void in
                            
                            if error != nil {
                                
                                print("Login failed \(error)")
                                
                            } else {
                                
                                print("Logged in! \(authData)")
                                
//                                storing user informaiton into database here go see https://www.firebase.com/docs/ios/guide/user-auth.html at the Storing User Data sections
                                
                                let newUser = [
                                    "provider": authData.provider,
                                    "displayName": authData.providerData["displayName"] as? NSString as? String
                                ]
                                // Create a child path with a key set to the uid underneath the "users" node
                                // This creates a URL path like the following:
                                //  - https://<YOUR-FIREBASE-APP>.firebaseio.com/users/<uid>
                                myRootRef.childByAppendingPath("users")
                                    .childByAppendingPath(authData.uid).setValue(newUser)
                            
                            }
                            
                            
                        })
                    }
                }
            }
        }
        
        myRootRef.removeAuthEventObserverWithHandle(handle)
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

