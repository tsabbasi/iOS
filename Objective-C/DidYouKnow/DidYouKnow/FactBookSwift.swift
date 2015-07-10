import Foundation
import UIKit

@objc
protocol FactBookProtocolSwift : NSObjectProtocol {
    
    func factsAreReady()
    func errorDownloadingFacts()
    
}

@objc
class FactBookSwift: NSObject, UIAlertViewDelegate, NSURLConnectionDelegate {
    
    var factsArray = [String]()
    var versionNumber : Int = 0
    var serverFactsCategories = NSMutableDictionary()
    var randomFacts = NSMutableDictionary()
    var engineeringMemes = NSMutableDictionary()
    var stemFacts = NSMutableDictionary()
    var jokes = NSMutableDictionary()
    
    var downloadedData : NSMutableData! = nil
    var currentRandomFact = ""
    var currentMeme = ""
    var currentStemFact = ""
    var currentJoke = ""
    var randomGenerator : RandomGenerator = RandomGenerator()
    var delegate : FactBookProtocolSwift! = nil
    
    
    
    func getFactsFromServer() {
        
        var jsonFileUrl : NSURL = NSURL(string: "http://www.xcode.abbasiindustries.com/didyouknow/funFacts.json")!
        
        var urlRequest : NSURLRequest = NSURLRequest(URL: jsonFileUrl)
        
        var urlConnection : NSURLConnection = NSURLConnection(request: urlRequest, delegate: self)!
        
    }
    
    // MARK: - NSURLConnectionDataProtocol Methods
    
    
    func connection(connection: NSURLConnection, didReceiveResponse response: NSURLResponse) {
        
        downloadedData = NSMutableData()
        
    }
    
    
    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
        
        downloadedData.appendData(data)
        
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection) {
        
        var error : NSError?
        var jsonObjectDictionary: NSDictionary = (NSJSONSerialization.JSONObjectWithData(downloadedData, options: NSJSONReadingOptions.AllowFragments, error: &error) as? NSDictionary)!
        
        if error != nil {
            
            self.delegate.errorDownloadingFacts()
            return
            
        }
        
        self.versionNumber = (jsonObjectDictionary.objectForKey("Version Number") as? Int)!
        self.serverFactsCategories = (jsonObjectDictionary.objectForKey("Categories") as? NSMutableDictionary)!
        self.randomFacts = (serverFactsCategories.objectForKey("randomfacts") as? NSMutableDictionary)!
        self.engineeringMemes = (serverFactsCategories.objectForKey("engineeringMemes") as? NSMutableDictionary)!
        self.stemFacts = (serverFactsCategories.objectForKey("stemFacts") as? NSMutableDictionary)!
        self.jokes = (serverFactsCategories.objectForKey("jokes") as? NSMutableDictionary)!
        
        self.delegate.factsAreReady()
        
    }
    
    
    func connection(connection: NSURLConnection, didFailWithError error: NSError) {
        
        var settingsAlert : AlertView = AlertView()
        
        var alertController : UIAlertController = settingsAlert.settingsAlert(alertTitle: "Connection Failed", alertMessage: "Sorry, Could not connect to the server. Please make sure your Cellular Data or Wifi is turned on in Settings.")
        
        var topViewController = UIApplication.sharedApplication().keyWindow?.rootViewController
        
        topViewController?.presentViewController(alertController, animated: true, completion: nil)
        
        
    }
    
    
    func getRandomFact(currentViewController : UIViewController) -> String {
        
        currentRandomFact = randomGenerator.getRandomObjectFromArray(self.randomFacts, completionDialogTitle: "All Done!", completionDialogMessage: "Congratualations, you now know a lot more interesting facts. Check back soon for new facts. Click 'OK' to start over.", viewController: currentViewController) as! String
        
        return currentRandomFact
        
    }
    
    func getEngineeringMemes(currentViewController : UIViewController) -> String {
        
        currentMeme = randomGenerator.getRandomObjectFromArray(self.engineeringMemes, completionDialogTitle: "All Done!", completionDialogMessage: "Congratualations, you now know a lot more Engineering facts. Check back soon for new facts. Click 'OK' to start over.", viewController: currentViewController) as! String
        
        return currentMeme
        
    }
    
    
    func getStemFacts(currentViewController : UIViewController) -> String {
        
        currentStemFact = randomGenerator.getRandomObjectFromArray(self.stemFacts, completionDialogTitle: "All Done!", completionDialogMessage: "Congratualations, you now know a lot more Stem facts. Check back soon for new facts. Click 'OK' to start over.", viewController: currentViewController) as! String
        
        return currentStemFact
        
    }
    
    func getJokes(currentViewController : UIViewController) -> String {
        
        currentJoke = randomGenerator.getRandomObjectFromArray(self.jokes, completionDialogTitle: "All Done!", completionDialogMessage: "Congratualations, you now know a lot more Jokes. Check back soon for new Jokes. Click 'OK' to start over.", viewController: currentViewController) as! String
        
        return currentJoke
        
    }
    
}