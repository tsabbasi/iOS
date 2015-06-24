//
//  FactBook.m
//  DidYouKnow
//
//  Created by Taha Abbasi on 5/5/15.
//  Copyright (c) 2015 TahaAbbasi. All rights reserved.
//

#import "FactBook.h"
#import "Alert.h"
#import "RandomGenerator.h"

@implementation FactBook
{
    NSMutableData *_downloadedData;
    NSString *_currentFact;
    RandomGenerator *_randomGenerator;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _randomGenerator = [[RandomGenerator alloc] init];
        
    }
    return self;
}

- (void)getFactsFromServer {
    
    NSURL *jsonFileUrl = [NSURL URLWithString:@"http://www.xcode.abbasiindustries.com/didyouknow/facts.json"];
    
    // Test for Error downloading question method
//    NSURL *jsonFileUrl = [NSURL URLWithString:@"http://www.abbasiindustries.com"];
    
    // Create the request
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:jsonFileUrl];
    
    // Create the connection
    NSURLConnection *urlConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    
}

#pragma mark NSURLConnectionDataProtocol Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    // Initialize the data object
    _downloadedData = [[NSMutableData alloc] init];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the newly downloaded data
    [_downloadedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    // Initialize the server facts array and facts array
    self.serverFactsDictionary = [[NSMutableDictionary alloc] init];
    self.factsArray = [[NSMutableArray alloc] init];
    
    // Parse the Json that came in
    NSError *error;
    NSDictionary *jsonObject = [NSJSONSerialization
                                JSONObjectWithData:_downloadedData
                                options:NSJSONReadingAllowFragments
                                error:&error];
    
    if (error != nil) {
        
        // error has occured, notify view controller
        // some way to handle the error gracefully instead of the app crashing
        [self.delegate errorDownloadingFacts];
        return;
    }
    
    // Loop through Json objects, create fact objects and add them to the facts array
    self.serverFactsDictionary = [jsonObject objectForKey:@"newFactsOnServer"];
    
//    for (NSString *string in self.serverFactsArray) {
//        [self.factsArray addObject:string];
//    }
    
    // Ready to notify delegate that questions are ready
    [self.delegate factsAreReady];
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    Alert *connectionErrorAlert = [[Alert alloc] init];
    [connectionErrorAlert
     alertWithSettingsButtonTitle:@"Connection Failed"
     alertMessage:@"Sorry, Could not connect to the server. Please make sure your Cellular Data or Wifi is turned on in Settings." delegate:self];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1)
    {
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:url];
    }
}

- (NSString *)getFact {
    

    
    _currentFact = [_randomGenerator
                    getRandomObjectFromArray:self.serverFactsDictionary
                    completionDialogTitle:@"All Done!"
                    completionDialogMessage:@"Congradualations, you now know a lot more interesting facts. Check back soon for new facts. Click 'OK' to start over."];
    
    return _currentFact;
    
}

@end
