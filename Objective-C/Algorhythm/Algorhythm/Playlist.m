//
//  Playlist.m
//  Algorhythm
//
//  Created by Taha Abbasi on 5/7/15.
//  Copyright (c) 2015 TahaAbbasi. All rights reserved.
//

#import "Playlist.h"
#import "MusicLibrary.h"

@implementation Playlist

- (instancetype)initWithIndex:(NSUInteger)index
{
    self = [super init];
    if (self) {
        MusicLibrary *musicLibrary = [[MusicLibrary alloc] init];
        NSArray *library = musicLibrary.library;
        
        NSDictionary *playlistDictionary = library[index];
        
        _playlistTitle = [playlistDictionary objectForKey:kTitle];
        _playlistDescription = [playlistDictionary objectForKey:kDescription];
        
        NSString *iconeName = [playlistDictionary objectForKey:kIcon];
        _playlistIcon = [UIImage imageNamed:iconeName];
        
        NSString *largeIconName = [playlistDictionary objectForKey:kLargeIcon];
        _playlistIconLarge = [UIImage imageNamed:largeIconName];
        
        _playlistArtist = [NSArray arrayWithArray:[playlistDictionary objectForKey:kArtists]];
        
        NSDictionary *colorDictionary = [playlistDictionary objectForKey:kBackgroundColor];
        
        _backgroundColor = [self rgbColorFromDictionary:colorDictionary];
        
        
    }
    return self;
}


- (UIColor *)rgbColorFromDictionary:(NSDictionary *)colorDictionary {
    CGFloat red = [[colorDictionary objectForKey:@"red"] doubleValue];
    CGFloat green = [[colorDictionary objectForKey:@"green"] doubleValue];
    CGFloat blue = [[colorDictionary objectForKey:@"blue"] doubleValue];
    CGFloat alpha = [[colorDictionary objectForKey:@"alpha"] doubleValue];
    
    return [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:alpha];
}

@end
