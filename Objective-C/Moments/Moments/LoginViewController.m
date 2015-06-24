//
//  LoginViewController.m
//  Moments
//
//  Created by Taha Abbasi on 5/15/15.
//  Copyright (c) 2015 TahaAbbasi. All rights reserved.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>
#import "Alert.h"

@interface LoginViewController ()
{
    Alert *_alert;
}

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _alert = [Alert alloc];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setHidden:YES];
}

- (IBAction)login:(id)sender {
    NSString *username = [self.usernameField.text stringByTrimmingCharactersInSet:
                          [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [self.passwordField.text stringByTrimmingCharactersInSet:
                          [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([username length] == 0 || [password length] == 0) {
        [_alert alertWithTitle:@"Oops!"
                    andMessage:@"Make sure you enter a username and password!"];
    } else {
        [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser *user, NSError *error) {
            if (error) {
                [_alert alertWithTitle:@"Sorry!" andMessage:[error.userInfo objectForKey:@"error"]];
            } else {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }];
    }
}
@end
