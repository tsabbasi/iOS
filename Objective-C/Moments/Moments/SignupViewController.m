//
//  SignupViewController.m
//  Moments
//
//  Created by Taha Abbasi on 5/15/15.
//  Copyright (c) 2015 TahaAbbasi. All rights reserved.
//

#import "SignupViewController.h"
#import <Parse/Parse.h>
#import "Alert.h"

@interface SignupViewController ()
{
    Alert *_alert;
}

@end

@implementation SignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _alert = [[Alert alloc] init];
    
}

- (IBAction)signup:(id)sender {
    NSString *username = [self.usernameField.text stringByTrimmingCharactersInSet:
                          [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [self.passwordField.text stringByTrimmingCharactersInSet:
                          [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *email = [self.emailField.text stringByTrimmingCharactersInSet:
                       [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([username length] == 0 || [password length] == 0 || [email length] == 0) {
        [_alert alertWithTitle:@"Oops!"
                    andMessage:@"Make sure you enter a username, password, and email address!"];
        
    } else {
        PFUser *newUser = [PFUser user];
        newUser.username = username;
        newUser.password = password;
        newUser.email = email;
        
        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error) {
                [_alert alertWithTitle:@"Sorry!" andMessage:[error.userInfo objectForKey:@"error"]];
            } else {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }];
    }
}

- (IBAction)dismiss:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
