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
    var storedFactsArray = Array<String>()
    var favoriteFactArray = Array<String>()
    
    
    // MARK: Checking for stored facts on device
    func getStoredFacts() {
        let storedFacts = Favorites(favoriteFacts: self.favoriteFactArray)
        
        print(storedFacts)
    }
    
    
    func getFactsFromServer() {
        
        
        let jsonFileUrl : NSURL = NSURL(string: "http://www.xcode.abbasiindustries.com/didyouknow/funFacts.json")!
        
        let urlRequest : NSURLRequest = NSURLRequest(URL: jsonFileUrl)
        
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
        
        
        do {
            
            let jsonObjectDictionary = try NSJSONSerialization.JSONObjectWithData(downloadedData, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
            
            if jsonObjectDictionary.count == 0 {
                
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
            
        } catch {
            
            print("JSON Serialization error")
        
        }
        
        
        
    }
    
    
    func connection(connection: NSURLConnection, didFailWithError error: NSError) {
        
        let settingsAlert : AlertView = AlertView()
        
        let alertController : UIAlertController = settingsAlert.settingsAlert(alertTitle: "Connection Failed", alertMessage: "Sorry, Could not connect to the server. Please make sure your Cellular Data or Wifi is turned on in Settings.")
        
        let topViewController = UIApplication.sharedApplication().keyWindow?.rootViewController
        
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
    
    func storeFacts(favoritedFact : String) -> String {
        
        var result = ""
        
        if let storedFacts = loadStoredFacts() {
            
            favoriteFactArray = storedFacts
            
            if favoriteFactArray.contains(favoritedFact) {
                result = "Already Favorite"
            } else {
                favoriteFactArray.append(favoritedFact)
                let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(favoriteFactArray, toFile: Favorites.ArchiveURL.path!)
                if !isSuccessfulSave {
                    result = "Failed To Save"
                } else {
                    result = "Favorite Added"
                }
            }
            
        } else {
            
            if favoriteFactArray.contains(favoritedFact) {
                result = "Already Favorite"
            } else {
                favoriteFactArray.append(favoritedFact)
                let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(favoriteFactArray, toFile: Favorites.ArchiveURL.path!)
                if !isSuccessfulSave {
                    result = "Failed To Save"
                } else {
                    result = "Favorite Added"
                }
            }
            
        }
        
        return result
        
    }
    
    
    
    func updateFacts(updatedFavoritesArray : Array<String>) -> String {
        
        var result = ""
            
        favoriteFactArray = updatedFavoritesArray
            
        
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(updatedFavoritesArray, toFile: Favorites.ArchiveURL.path!)
        if !isSuccessfulSave {
            result = "Failed To Delete"
        } else {
            result = "Deleted"
        }

        
        
        
        return result
    }
    
    func loadStoredFacts() -> Array<String>? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Favorites.ArchiveURL.path!) as? Array<String>
    }

    
}