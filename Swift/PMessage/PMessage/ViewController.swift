//
//  ViewController.swift
//  PMessage
//
//  Created by Taha Abbasi on 2/27/16.
//  Copyright © 2016 Web N App. All rights reserved.
//

import UIKit
import PubNub

class ViewController: UIViewController, PNObjectEventListener {
    
    var client = PubNub()
    var channel = "TestingChannel"

    @IBOutlet weak var messageLabel: UILabel!
    @IBAction func publishButton(sender: AnyObject) {
        
        client.publish("iPhone 6 Here", toChannel: channel, withCompletion: nil)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let configuration = PNConfiguration(publishKey: "pub-c-d860bb70-33c9-497d-86e2-17898714fbe4", subscribeKey: "sub-c-fff59fa4-c78f-11e5-8408-0619f8945a4f")
        client = PubNub.clientWithConfiguration(configuration)
        client.subscribeToChannels([channel], withPresence: true)
        
        client.addListener(self)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func client(client: PubNub!, didReceiveMessage message: PNMessageResult!) {
        
        self.messageLabel.text = message.data.message as! String
        
    }

}

