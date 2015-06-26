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



@interface ViewController : UIViewController<FactBookProtocol>

@property (weak, nonatomic) IBOutlet UILabel *funFactLabel;
@property (strong, nonatomic) FactBook *factBook;
@property (weak, nonatomic) IBOutlet UIButton *funFactButton;


@end

