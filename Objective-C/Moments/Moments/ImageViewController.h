//
//  ImageViewController.h
//  Moments
//
//  Created by Taha Abbasi on 5/17/15.
//  Copyright (c) 2015 TahaAbbasi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ImageViewController : UIViewController

@property (nonatomic, strong) PFObject *message;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end
