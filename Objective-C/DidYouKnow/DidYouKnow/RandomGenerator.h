//
//  RandomGenerator.h
//  DidYouKnow
//
//  Created by Taha Abbasi on 5/6/15.
//  Copyright (c) 2015 TahaAbbasi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RandomGenerator : NSObject

@property (strong, nonatomic) NSMutableArray *previousRandomNumberArray;

- (id)getRandomObjectFromArray:(NSMutableDictionary *)dictionary completionDialogTitle:(NSString *)alertTitle completionDialogMessage:(NSString *)alertMessage;

- (id)getRandomObjectFromArray:(NSArray *)array;

@end
