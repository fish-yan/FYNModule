//
//  UIView+FYView.m
//  MobileWorkstation
//
//  Created by 薛焱 on 2017/6/8.
//  Copyright © 2017年 cjm-ios. All rights reserved.
//

#import "UIView+FYView.h"

@implementation UIView (FYView)

- (UIViewController *)viewController {
    
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UINavigationController class]]) {
            UINavigationController *NAVC = (UINavigationController *)nextResponder;
            return NAVC.viewControllers.lastObject;
        }
    }
    return nil;
}

@end
