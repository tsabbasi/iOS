//
//  RandomGenerator.m
//  DidYouKnow
//
//  Created by Taha Abbasi on 5/6/15.
//  Copyright (c) 2015 TahaAbbasi. All rights reserved.
//

#import "RandomGenerator.h"
#import "Alert.h"

@implementation RandomGenerator
{
    int _random;
    
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _previousRandomNumberArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id)getRandomObjectFromArray:(NSMutableDictionary *)dictionary completionDialogTitle:(NSString *)alertTitle completionDialogMessage:(NSString *)alertMessage {
    
    if (_previousRandomNumberArray.count == dictionary.count) {
        Alert *alert = [[Alert alloc] init];
        [alert alertTitle:alertTitle alertMessage:alertMessage];
        [_previousRandomNumberArray removeAllObjects];
    }
    
    
    _random = arc4random_uniform((int)dictionary.count);
    id randomNumber = [NSString stringWithFormat:@"%d", _random];
    while ([_previousRandomNumberArray containsObject:randomNumber]) {
        _random = arc4random_uniform((int)dictionary.count);
        randomNumber = [NSString stringWithFormat:@"%d", _random];
    }
    
    [_previousRandomNumberArray addObject:randomNumber];
    
    
    return [dictionary objectForKey:randomNumber];
    
}

- (id)getRandomObjectFromArray:(NSMutableArray *)array {
    
    if (_previousRandomNumberArray.count == array.count) {
        [_previousRandomNumberArray removeAllObjects];
    }
    
    _random = arc4random_uniform((int)array.count);
    id randomNumber = [NSString stringWithFormat:@"%d", _random];
    while ([_previousRandomNumberArray containsObject:randomNumber]) {
        _random = arc4random_uniform((int)array.count);
        randomNumber = [NSString stringWithFormat:@"%d", _random];
    }
    
    [_previousRandomNumberArray addObject:randomNumber];
    
    
    return array[_random];
}

@end
