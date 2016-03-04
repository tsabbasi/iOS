//
//  ViewController.swift
//  MessageMe
//
//  Created by Taha Abbasi on 2/28/16.
//  Copyright © 2016 Web N App. All rights reserved.
//

import UIKit
import PubNub
import SlackTextViewController
import SwiftyJSON

class ViewController: SLKTextViewController, PNObjectEventListener {
    
    var client = PubNub()
    var userName = UIDevice.currentDevice().identifierForVendor!.UUIDString
    var userChannel = "\(UIDevice.currentDevice().identifierForVendor!.UUIDString)Channel"
    var threadChannel = "threadTest"
    
    // Each message that is sent
    var messagePacket = [String : String]()
    // A list of all the messages displayed in the UI
    var messages = [[String: String]]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.tableView.registerClass(MessageTableViewCell.self, forCellReuseIdentifier: "MessageTableViewCell")
        self.inverted = false
        
        
        
        // TODO: Username Logic
        
        print(userName)
        print(userChannel)
        
        let configuration = PNConfiguration(publishKey: "pub-c-d860bb70-33c9-497d-86e2-17898714fbe4", subscribeKey: "sub-c-fff59fa4-c78f-11e5-8408-0619f8945a4f")
        client = PubNub.clientWithConfiguration(configuration)
        print("VC Client \(client)")
        client.subscribeToChannels([userChannel, threadChannel], withPresence: true)
        print("VC Channels \(client.channels())")
//        devicePushToken = NSUserDefaults.standardUserDefaults().objectForKey("DeviceToken") as! NSData
        
        
        
        client.addListener(self)
        
        loadMessages()
        
        // Set up UI controls
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 64.0
        self.tableView.separatorStyle = .None
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func didPressRightButton(sender: AnyObject!) {
        self.textView.refreshFirstResponder()
        
        let message = self.textView.text
        messagePacket.removeAll()
        messagePacket["username"] = userName
        messagePacket["message"] = message
        sendMessage(messagePacket)
        
        
    }
    
    func sendMessage(messagePacket : [String : String]) {
        let apns = ["pn_apns": ["aps" : ["alert" : "Message from \(messagePacket["username"])", "badge" : 1, "sound" : "PushTone.caf"]], "messagePacket": messagePacket]
        
        client.publish(apns, toChannel: threadChannel) { (result: PNPublishStatus!) -> Void in
            
            //        client.publish(messagePacket, toChannel: channel) { (result : PNPublishStatus!) -> Void in
            
            if !result.error {
                self.textView.text = ""
            } else {
                print("VC Send SendMessage publish error \(result.errorData)")
            }
            
        }
        
    }
    
    func sendPushMessage(intendedUsersChannelName : String, messagePacket : [String : String]) {
        let apns = ["pn_apns": ["aps" : ["alert" : "Message from \(messagePacket["username"])", "badge" : 1, "sound" : "PushTone.caf"]], "messagePacket": messagePacket]
        
        client.publish(apns, toChannel: intendedUsersChannelName) { (result: PNPublishStatus!) -> Void in
            
            //        client.publish(messagePacket, toChannel: channel) { (result : PNPublishStatus!) -> Void in
            
            if !result.error {
                self.textView.text = ""
            } else {
                print("VC SendPushMessage publish error \(result.errorData)")
            }
            
        }
        
    }
    
    func loadMessages() {
        self.messages.removeAll()
        client.historyForChannel(threadChannel) { (result: PNHistoryResult!, status : PNErrorStatus!) -> Void in
            
            if status == nil {
                // Handle downloaded history using:
                //   result.data.start - oldest message time stamp in response
                //   result.data.end - newest message time stamp in response
                //   result.data.messages - list of messages
                
//                print(result.data.messages)
//                self.addMessages(messages!)
                

                var downloadedMessages = [[String : String]]()
                
                let allData = result.data.messages
//                if let messages = result.data.messages[0] {
//                    
//                }
                for messages in allData {
                    downloadedMessages.append(messages["messagePacket"] as! [String : String])
                }
//                var packet = messages["messagePacket"] as! [String : String]
//                var name = packet["username"]
//                var body = packet["message"]
//                print("All Data\n\n \(alldata)")
//                print("First Message\n\n \(messages)")
//                print("Message Packet\n\n \(packet)")
//                print("Name\n\n \(name)")
//                print("Message\n\n \(body)")
                
                
                
//                let messages = result.data.messages
//                
//                let allMessages = messages as! [[String: String]]
//                
//                print("All Messages:\n\(allMessages)\n")
                self.addMessages(downloadedMessages)
                
            } else {
                
                // Handle message history download error. Check 'category' property
                // to find out possible reason because of which request did fail.
                // Review 'errorData' property (which has PNErrorData data type) of status
                // object to get additional information about issue.
                //
                // Request can be resent using: status.retry()
                
            }
            
        }
//        let messages = self.generalChannel?.messages.allObjects()
//        self.addMessages(messages!)
    }
    
    
    func addMessages(messages: [[String: String]]) {
        self.messages.appendContentsOf(messages)
//        self.messages.sortInPlace { $1.timestamp > $0.timestamp }
        
        dispatch_async(dispatch_get_main_queue()) {
            () -> Void in
            self.tableView.reloadData()
            if self.messages.count > 0 {
                self.scrollToBottomMessage()
            }
        }
    }
    
    func addMessage(message: [String: String]) {
        self.messages.append(message)
        //        self.messages.sortInPlace { $1.timestamp > $0.timestamp }
        
        dispatch_async(dispatch_get_main_queue()) {
            () -> Void in
            self.tableView.reloadData()
            if self.messages.count > 0 {
                self.scrollToBottomMessage()
            }
        }
    }

    
    
    func client(client: PubNub!, didReceiveMessage message: PNMessageResult!) {
        
//        self.messageLabel.text = (message.data.message as! String)
        print(message.data.message)
        let dataPacket = message.data.message
        let messagePacket = dataPacket["messagePacket"] as! [String: String]
//
//        print("Current Message:\n\(message)\n")
        self.addMessage(messagePacket)
        
    }
    
    
    // MARK: UI Logic
    // Scroll to bottom of table view for messages
    func scrollToBottomMessage() {
        if self.messages.count == 0 {
            return
        }
        let bottomMessageIndex = NSIndexPath(forRow: self.tableView.numberOfRowsInSection(0) - 1,
            inSection: 0)
        self.tableView.scrollToRowAtIndexPath(bottomMessageIndex, atScrollPosition: .Bottom,
            animated: true)
    }
    
    // MARK: UITableView Delegate
    // Return number of rows in the table
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    // Create table view rows
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MessageTableViewCell", forIndexPath: indexPath) as! MessageTableViewCell
        
//        let message = self.messages[indexPath.row]
//        
//        cell.nameLabel.text = message.author
//        cell.bodyLabel.text = message.body
        
        let message = self.messages[indexPath.row]
        
        cell.nameLabel.text = message["username"]
        cell.bodyLabel.text = message["message"]
        cell.selectionStyle = .None
        
        return cell
    }
    
    // MARK: UITableViewDataSource Delegate
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
}
