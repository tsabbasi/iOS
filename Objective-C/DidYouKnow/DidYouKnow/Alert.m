//
//  Alert.m
//  DidYouKnow
//
//  Created by Taha Abbasi on 5/6/15.
//  Copyright (c) 2015 TahaAbbasi. All rights reserved.
//

#import "Alert.h"

@implementation Alert

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)alertTitle:(NSString *)title alertMessage:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles: nil];

    [alert show];
}

- (void)alertWithSettingsButtonTitle:(NSString *)title alertMessage:(NSString *)message delegate:(id)delegate {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:delegate
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:@"Settings", nil];
    
    [alert show];
}


@end
