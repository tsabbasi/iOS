//
//  BlogPost.m
//  BlogReader
//
//  Created by Taha Abbasi on 5/8/15.
//  Copyright (c) 2015 TahaAbbasi. All rights reserved.
//

#import "BlogPost.h"

@implementation BlogPost

- (id) initWithTitle:(NSString *)title
{
    self = [super init];
    if (self) {
        _title = title;
        _author = nil;
        _thumbnail = nil;
    }
    return self;
}

+ (id) blogPostWithTitle:(NSString *)title {
    return [[self alloc] initWithTitle:title];
}


- (NSURL *) thumbnailURL {
    return [NSURL URLWithString:self.thumbnail];
}

- (NSString *) formattedDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *tempDate = [dateFormatter dateFromString:self.date];
    
    [dateFormatter setDateFormat:@"EE, dd-MMM-yyyy"];
    return [dateFormatter stringFromDate:tempDate];
    
}

@end
