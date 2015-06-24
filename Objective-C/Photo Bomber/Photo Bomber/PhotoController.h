//
//  PhotoController.h
//  Photo Bomber
//
//  Created by Taha Abbasi on 5/19/15.
//  Copyright (c) 2015 TahaAbbasi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PhotoController : NSObject

+ (void)imageForPhoto:(NSDictionary *)photo size:(NSString *)size completion:(void(^)(UIImage *image))completion;

+ (void)avatarForPhoto:(NSDictionary *)photo completion:(void(^)(UIImage *image))completion;

@end
