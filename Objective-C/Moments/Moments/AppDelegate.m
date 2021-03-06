//
//  AppDelegate.m
//  Moments
//
//  Created by Taha Abbasi on 5/14/15.
//  Copyright (c) 2015 TahaAbbasi. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // [Optional] Power your app with Local Datastore. For more info, go to
    // https://parse.com/docs/ios_guide#localdatastore/iOS
    [NSThread sleepForTimeInterval:1.5];
    
    [Parse enableLocalDatastore];
    
    // Initialize Parse.
    [Parse setApplicationId:@"kBbTKd2Yxl6abTnNvs0YtDGvoI0lMBcfKACF6rDh"
                  clientKey:@"OZ0r5DSft1t70DwPNE1RoeXkKes34aRMx522UgpP"];
    
    // [Optional] Track statistics around application opens.
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    // ...
    
    [self customizeUserInterface];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Helper methods

- (void)customizeUserInterface {
    // Customize the nav bar
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navBarBackground"] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                          [UIColor whiteColor],
                                                          NSForegroundColorAttributeName,
                                                          nil]];
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    // Customize tab bar
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       [UIColor whiteColor],
                                                       NSForegroundColorAttributeName,
                                                       nil] forState:UIControlStateNormal];

    UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
    
    
    UITabBar *tabBar = tabBarController.tabBar;
    
    
    UITabBarItem *tabInbox = [tabBar.items objectAtIndex:0];
    UITabBarItem *tabFriends = [tabBar.items objectAtIndex:1];
    UITabBarItem *tabCamera = [tabBar.items objectAtIndex:2];
    
    
    [tabInbox setImage:[[UIImage imageNamed:@"inbox"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabInbox setSelectedImage:[[UIImage imageNamed:@"inbox_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    [tabFriends setImage:[[UIImage imageNamed:@"friends"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabFriends setSelectedImage:[[UIImage imageNamed:@"friends_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    [tabCamera setImage:[[UIImage imageNamed:@"camera"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabCamera setSelectedImage:[[UIImage imageNamed:@"camera_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    

}

@end
