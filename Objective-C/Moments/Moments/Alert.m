//
//  Alert.m
//  Moments
//
//  Created by Taha Abbasi on 5/15/15.
//  Copyright (c) 2015 TahaAbbasi. All rights reserved.
//

#import "Alert.h"

@implementation Alert


- (void)alertWithTitle:(NSString *)alertTitle andMessage:(NSString *)alertMessage {
    UIAlertView *alert = [[UIAlertView alloc]
                    initWithTitle:alertTitle
                    message:alertMessage
                    delegate:nil
                    cancelButtonTitle:@"OK"
                    otherButtonTitles: nil];
    
    [alert show];
}

@end
