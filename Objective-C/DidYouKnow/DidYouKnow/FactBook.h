//
//  FactBook.h
//  DidYouKnow
//
//  Created by Taha Abbasi on 5/5/15.
//  Copyright (c) 2015 TahaAbbasi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol FactBookProtocol <NSObject>

- (void)factsAreReady;
- (void)errorDownloadingFacts;

@end

@interface FactBook : NSObject<NSURLConnectionDataDelegate, UIAlertViewDelegate>

@property (nonatomic, weak) id<FactBookProtocol> delegate;
@property (strong, nonatomic) NSMutableArray *factsArray;
@property (strong, nonatomic) NSMutableDictionary *serverFactsDictionary;

- (NSString *)getFact;
- (void)getFactsFromServer;

@end
