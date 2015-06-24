//
//  Alert.h
//  DidYouKnow
//
//  Created by Taha Abbasi on 5/6/15.
//  Copyright (c) 2015 TahaAbbasi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Alert : UIView

- (void)alertTitle:(NSString *)title alertMessage:(NSString *)message;

- (void)alertWithSettingsButtonTitle:(NSString *)title alertMessage:(NSString *)message delegate:(id)delegate;

@end
