//
//  DismissDetainTransition.m
//  Photo Bomber
//
//  Created by Taha Abbasi on 5/19/15.
//  Copyright (c) 2015 TahaAbbasi. All rights reserved.
//

#import "DismissDetailTransition.h"


@implementation DismissDetailTransition

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *detail = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    [UIView animateWithDuration:0.3 animations:^{
        detail.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        [detail.view removeFromSuperview];
        [transitionContext completeTransition:YES];
    }];
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.3;
}


@end
