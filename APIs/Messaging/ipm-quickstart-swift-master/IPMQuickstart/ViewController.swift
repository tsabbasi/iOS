import UIKit
import SlackTextViewController

class ViewController: SLKTextViewController {
    // IP Messaging client instance - will create on initialization
    var client: TwilioIPMessagingClient? = nil
    // Handle to the default general channel
    var generalChannel: TWMChannel? = nil
    // Identity that was assigned to us by the server
    var identity = ""
    // A list of all the messages displayed in the UI
    var messages: [TWMMessage] = []
    
    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerClass(MessageTableViewCell.self, forCellReuseIdentifier: "MessageTableViewCell")
        self.inverted = false
        
        // Fetch Access Token form the server and initialize IPM Client - this assumes you are running
        // the PHP starter app on your local machine, as instructed in the quick start guide
        let deviceId = UIDevice.currentDevice().identifierForVendor!.UUIDString
        let urlString = "http://xcode.abbasiindustries.com/PMessage/token.php?device=\(deviceId)"
//        let urlString = "http://localhost:8000/token.php?device=\(deviceId)"
        let defaultChannel = "general"
        
        // Get JSON from server
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config, delegate: nil, delegateQueue: nil)
        let url = NSURL(string: urlString)
        let request  = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "GET"
        
        // Make HTTP request
        session.dataTaskWithRequest(request, completionHandler: { data, response, error in
            if (data != nil) {
                // Parse result JSON
                let json = JSON(data: data!)
                let token = json["token"].stringValue
                self.identity = json["identity"].stringValue
                
                // Set up Twilio IPM client and join the general channel
                self.client = TwilioIPMessagingClient.ipMessagingClientWithToken(token, delegate: self)
                
                // Auto-join the general channel
                self.client?.channelsListWithCompletion { result, channels in
                    if (result == .Success) {
                        if let channel = channels.channelWithUniqueName(defaultChannel) {
                            // Join the general channel if it already exists
                            self.generalChannel = channel
                            self.generalChannel?.joinWithCompletion({ result in
                                print("Channel joined with result \(result)")
                            })
                        } else {
                            // Create the general channel (for public use) if it hasn't been created yet
                            channels.createChannelWithFriendlyName("General Chat Channel", type: .Public) {
                                (channelResult, channel) -> Void in
                                if result == .Success {
                                    self.generalChannel = channel
                                    self.generalChannel?.joinWithCompletion({ result in
                                        self.generalChannel?.setUniqueName(defaultChannel, completion: { result in
                                            print("channel unqiue name set")
                                        })
                                    })
                                }
                            }
                        }
                    }
                }
                
                // Update UI on main thread
                dispatch_async(dispatch_get_main_queue()) {
                    self.navigationItem.prompt = "Logged in as \"\(self.identity)\""
                    self.navigationItem.title = "#general"
                }
            } else {
                print("Error fetching token :\(error)")
            }
        }).resume()
        
        // Set up UI controls
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 64.0
        self.tableView.separatorStyle = .None
    }
    
    // MARK: Setup IP Messaging Channel
    func joinChannel() {
        self.generalChannel?.joinWithCompletion() {
            (result) -> Void in
            if result == .Success {
                //self.channel?.delegate = self
                //self.loadMessages()
            }
        }
    }
    
    func joinChannelAndSetUniqueName(name: String) {
        self.generalChannel?.joinWithCompletion() { result in
            if result == .Success {
                self.generalChannel?.setUniqueName(name) { result in
                    //self.channel?.delegate = self
                    //self.loadMessages()
                }
            }
        }
    }
    
    override func didPressRightButton(sender: AnyObject!) {
        self.textView.refreshFirstResponder()
        
        let message = self.generalChannel?.messages.createMessageWithBody(self.textView.text)
        self.generalChannel?.messages.sendMessage(message){
            (result) -> Void in
            if result != .Success {
                print("Error sending message")
            } else {
                self.textView.text = ""
            }
        }
    }
    
    func loadMessages() {
        self.messages.removeAll()
        let messages = self.generalChannel?.messages.allObjects()
        self.addMessages(messages!)
    }
    
    func addMessages(messages: [TWMMessage]) {
        self.messages.appendContentsOf(messages)
        self.messages.sortInPlace { $1.timestamp > $0.timestamp }
        
        dispatch_async(dispatch_get_main_queue()) {
            () -> Void in
            self.tableView.reloadData()
            if self.messages.count > 0 {
                self.scrollToBottomMessage()
            }
        }
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
        
        let message = self.messages[indexPath.row]
        
        cell.nameLabel.text = message.author
        cell.bodyLabel.text = message.body
        cell.selectionStyle = .None
        
        return cell
    }
    
    // MARK: UITableViewDataSource Delegate
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
}

// MARK: Twilio IP Messaging Delegate
extension ViewController: TwilioIPMessagingClientDelegate {
    // Called whenever a channel we've joined receives a new message
    func ipMessagingClient(client: TwilioIPMessagingClient!, channel: TWMChannel!,
        messageAdded message: TWMMessage!) {
            self.addMessages([message])
    }
    
    func ipMessagingClient(client: TwilioIPMessagingClient!, channelHistoryLoaded channel: TWMChannel!) {
        self.loadMessages()
    }
    
    func ipMessagingClient(client: TwilioIPMessagingClient!, typingStartedOnChannel channel: TWMChannel!, member: TWMMember!) {
        self.typingIndicatorView.insertUsername(member.identity())
    }
    
    func ipMessagingClient(client: TwilioIPMessagingClient!, typingEndedOnChannel channel: TWMChannel!, member: TWMMember!) {
        self.typingIndicatorView.removeUsername(member.identity())
    }
    
    override func textViewDidChange(textView: UITextView) {
        self.generalChannel?.typing()
    }
}