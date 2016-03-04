//
//  AppDelegate.swift
//  MessageMe
//
//  Created by Taha Abbasi on 2/28/16.
//  Copyright © 2016 Web N App. All rights reserved.
//

import UIKit
import PubNub

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var dToken : NSData?
    var client: PubNub?
    var cQueue: dispatch_queue_t?
    var userName = ViewController().userName
    var userChannel = ViewController().userChannel
    var threadChannel = ViewController().threadChannel
    var iPhone6PlusChannel = "C0147AED-F84D-4F3A-A3A6-F0E138B1F359Channel"
    var iPhone5Channel = "C585AE7E-15BA-4E21-9C9D-94F9671B0C2CChannel"
    var iPadAir2Channel = "B82EA857-618E-47D3-AFCB-1665671826C4Channel"
    
    
    override init() {
        super.init()
        
        switch userName {
            case "C0147AED-F84D-4F3A-A3A6-F0E138B1F359":
                userName = "iPhone 6 Plus"
                break
            
            case "C585AE7E-15BA-4E21-9C9D-94F9671B0C2C":
                userName = "iPhone 5"
                break
            
            case "C585AE7E-15BA-4E21-9C9D-94F9671B0C2C":
                userName = "iPad Air 2"
                break
            
            default:
                userName = ViewController().userName
        }
    }

    

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        let configuration = PNConfiguration(publishKey: "pub-c-d860bb70-33c9-497d-86e2-17898714fbe4", subscribeKey: "sub-c-fff59fa4-c78f-11e5-8408-0619f8945a4f")
        self.client = PubNub.clientWithConfiguration(configuration)
        
        
        let textAction = UIMutableUserNotificationAction()
        textAction.identifier = "TEXT_ACTION"
        textAction.title = "Reply"
        textAction.activationMode = .Background
        textAction.authenticationRequired = false
        textAction.destructive = false
        textAction.behavior = .TextInput

        let category = UIMutableUserNotificationCategory()
        category.identifier = "CATEGORY_ID"
        category.setActions([textAction], forContext: .Default)
        category.setActions([textAction], forContext: .Minimal)
        
        let categories = NSSet(object: category) as! Set<UIUserNotificationCategory>
        // In iOS 8, this when the user receives a system prompt for notifications in your app
        let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: categories)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
        UIApplication.sharedApplication().registerForRemoteNotifications()
        
        return true
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        // Sometimes it’s useful to store the device token in NSUserDefaults
        print(deviceToken)
        NSUserDefaults.standardUserDefaults().setObject(deviceToken, forKey: "DeviceToken")
        dToken = deviceToken
        print("Got channel before adding PushNotificaiton: \(userChannel)")
        self.client?.addPushNotificationsOnChannels([userChannel], withDevicePushToken: deviceToken,
            andCompletion: { (status) -> Void in
                
                if !status.error {
                    
                    // Handle successful push notification enabling on passed channels.
                    print("AD Push Added to Channel")
                }
                else {
                    
                    // Handle modification error. Check 'category' property
                    // to find out possible reason because of which request did fail.
                    // Review 'errorData' property (which has PNErrorData data type) of status
                    // object to get additional information about issue.
                    //
                    // Request can be resent using: status.retry()
                    print("AD Push NOT ADDED TO CHANNEL")
                }
        })
        

    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print("didFail! with error: \(error)")
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
//        let configuration = PNConfiguration(publishKey: "pub-c-d860bb70-33c9-497d-86e2-17898714fbe4", subscribeKey: "sub-c-fff59fa4-c78f-11e5-8408-0619f8945a4f")
//        client = PubNub.clientWithConfiguration(configuration)
//        client!.subscribeToChannels(["TestingChannel9"], withPresence: true)
        
    }
    
    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [NSObject : AnyObject], withResponseInfo responseInfo: [NSObject : AnyObject], completionHandler: () -> Void) {
        
        if identifier == "TEXT_ACTION"{
            if let response = responseInfo[UIUserNotificationActionResponseTypedTextKey],
                responseText = response as? String {
                    
                    let configuration = PNConfiguration(publishKey: "pub-c-d860bb70-33c9-497d-86e2-17898714fbe4", subscribeKey: "sub-c-fff59fa4-c78f-11e5-8408-0619f8945a4f")
                    
                    client = PubNub.clientWithConfiguration(configuration)
                    print("AD HandleAction Client \(client)")
                    client!.subscribeToChannels([userChannel, threadChannel], withPresence: true)
                    print("AD HandleAction Channels \(client!.channels())")
                        
                    //do your API call magic!!
                    self.handleMeesageResponse(responseText)
                    completionHandler()
                    
            }
        }
        
        
        
    }
    
    func handleMeesageResponse(responseText : String) {
        print("HANDLING NOW")
        let mPacket : [String: String] = ["username" : userName, "message" : responseText]
        sendMessage(threadChannel, messagePacket: mPacket)
        if userChannel == iPhone6PlusChannel {
            sendPushMessage(iPadAir2Channel, messagePacket: mPacket)
            sendPushMessage(iPhone5Channel, messagePacket: mPacket)
        } else if userChannel == iPhone5Channel {
            sendPushMessage(iPhone6PlusChannel, messagePacket: mPacket)
            sendPushMessage(iPadAir2Channel, messagePacket: mPacket)
        } else if userChannel == iPadAir2Channel {
            sendPushMessage(iPhone6PlusChannel, messagePacket: mPacket)
            sendPushMessage(iPhone5Channel, messagePacket: mPacket)
        }
        
    }
    
    func sendMessage(intededThreadChannel : String, messagePacket : [String : String]) {
        let messageJSON = ["messagePacket": messagePacket]
        print("AD sendMessage Before Publish")
        print("AD HandleAction Client \(client)")
      
        //TODO: Problem is here, the call back is not reached in background mode
        self.client!.publish(messageJSON, toChannel: intededThreadChannel) { (result: PNPublishStatus!) -> Void in
        print("AD sendMessage After Publish")
            //        client.publish(messagePacket, toChannel: channel) { (result : PNPublishStatus!) -> Void in
            
            if !result.error {
                print("SENT")
            } else {
                print("AD Send SendMessage publish error \(result.errorData)")
                result.retry()
            }
            
        }
        
    }
    
    func sendPushMessage(intendedUsersChannelName : String, messagePacket : [String : String]) {
        let apns = ["pn_apns": ["aps" : ["alert" : "Message from \(messagePacket["username"]!)", "badge" : 1, "sound" : "PushTone.caf", "category" : "CATEGORY_ID"]], "messagePacket": messagePacket]
        print("AD sendMessage Before Publish")
        print("AD HandleAction Client \(client)")
        
        //TODO: Problem is here, the call back is not reached in background mode
        self.client!.publish(apns, toChannel: intendedUsersChannelName) { (result: PNPublishStatus!) -> Void in
            print("AD sendMessage After Publish")
            //        client.publish(messagePacket, toChannel: channel) { (result : PNPublishStatus!) -> Void in
            
            if !result.error {
                print("SENT")
            } else {
                print("AD Send Button Error: message send error: \(result.errorData)")
                result.retry()
            }
            
        }
        
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

