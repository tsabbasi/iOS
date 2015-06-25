//
//  ViewController.m
//  DidYouKnow
//
//  Created by Taha Abbasi on 5/5/15.
//  Copyright (c) 2015 TahaAbbasi. All rights reserved.
//

#import "ViewController.h"
#import "DidYouKnow-Swift.h"

@interface ViewController ()
{
    // Add spinner
    UIActivityIndicatorView *_spinner;
    bool _networkAvailable;
}


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _networkAvailable = true;
    
    self.factBook = [[FactBook alloc] init];
    _factBook.delegate = self;
    
    // Get facts
    [_factBook getFactsFromServer];
    
    _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _spinner.center = self.view.center;
    [self.view addSubview:_spinner];
    [_spinner startAnimating];
    
    self.colorWheel = [[ColorWheel alloc] init];
    
    UIColor *randomColor = [self.colorWheel getColor];
    self.view.backgroundColor = randomColor;
    self.funFactButton.tintColor = randomColor;
    
    
    
    // Need to replace this with Text i want to show at app start-up or first fact
    self.funFactLabel.text = @"Welcome To Fun Facts By Taha.";
    
    
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:true];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showFunFact {
    
    if (_networkAvailable) {
        UIColor *randomColor = [self.colorWheel getColor];
        self.view.backgroundColor = randomColor;
        self.funFactButton.tintColor = randomColor;
        // Need to randomly generate this, will need an instance variable to hold previous numbers.
        self.funFactLabel.text = [self.factBook getFact];
    } else {
        [self errorDownloadingFacts];
    }
    
}

#pragma mark FactBook delegate methods

- (void)factsAreReady {
    
    // Set the first fact
    self.funFactLabel.text = [self.factBook getFact];
    
    // Remove the spinner
    [_spinner removeFromSuperview];
    
}

- (void)errorDownloadingFacts {
    _networkAvailable = false;
    
    self.funFactLabel.text = @"Error getting facts";
    
    Alert *alert = [[Alert alloc] init];
    
    [alert alertTitle:@"Error Downloading Facts"
         alertMessage:@"Sorry, there was an error downloading facts. Please try restarting the app, or try again later."];
    
    // Creating an instance of the AlertView class and initializing it
    AlertView *testAlert = [[AlertView alloc] init];

    /* Creating a UIAlertController object and then calling the method I created in the AlertView class. This way the returned UIAlertController will be assigned to this UIAlertController
    */
    
    UIAlertController *alertController = [testAlert alertWithAlertTitle:@"Genius!" alertMessage:@"Pure Genius"];
    
    
    // Finally presenting the alert controller
    [self presentViewController:alertController animated:true completion:nil];


}

@end
