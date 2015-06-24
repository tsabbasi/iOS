//
//  ColorWheel.h
//  DidYouKnow
//
//  Created by Taha Abbasi on 5/5/15.
//  Copyright (c) 2015 TahaAbbasi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIkit.h>

@interface ColorWheel : NSObject

@property (strong, nonatomic) NSMutableArray *colorArray;

- (UIColor *)getColor;

@end
