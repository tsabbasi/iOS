//
//  FriendsViewController.h
//  Moments
//
//  Created by Taha Abbasi on 5/16/15.
//  Copyright (c) 2015 TahaAbbasi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "Alert.h"

@interface FriendsViewController : UITableViewController

@property (nonatomic, strong) PFRelation *friendsRelation;
@property (nonatomic, strong) NSArray *friends;

@end
