//
//  ViewController.h
//  DidYouKnow
//
//  Created by Taha Abbasi on 5/5/15.
//  Copyright (c) 2015 TahaAbbasi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FactBook.h"
#import "Alert.h"
#import "ColorWheel.h"


// Making view controller aware of the class by doing below rather than importing all of its methods and properties by using #import

@class ColorWheel;



@interface ViewController : UIViewController<FactBookProtocol>

@property (weak, nonatomic) IBOutlet UILabel *funFactLabel;
@property (strong, nonatomic) FactBook *factBook;
@property (strong, nonatomic) ColorWheel *colorWheel;
@property (weak, nonatomic) IBOutlet UIButton *funFactButton;


@end

