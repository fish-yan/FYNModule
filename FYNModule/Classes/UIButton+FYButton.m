//
//  UIButton+FYNButton.m
//  test
//
//  Created by 薛焱 on 2017/5/27.
//  Copyright © 2017年 薛焱. All rights reserved.
//

#import "UIButton+FYButton.h"
#import <objc/runtime.h>

const void *titleInsetsTypeKey = @"titleInsetsType";

@implementation UIButton (FYButton)

- (void)setTitleInsetsType:(FYTitleInsetsType)titleInsetsType {
    objc_setAssociatedObject(self, titleInsetsTypeKey, [NSNumber numberWithInteger:titleInsetsType], OBJC_ASSOCIATION_ASSIGN);
    [self configureTitleInsets];
}

- (FYTitleInsetsType)titleInsetsType {
    NSNumber *type = objc_getAssociatedObject(self, titleInsetsTypeKey);
    return (FYTitleInsetsType)[type integerValue];
}

- (void)configureTitleInsets {
    CGFloat imageHeight = self.imageView.frame.size.height;
    CGFloat imageWidth = self.imageView.frame.size.width;
    CGFloat titleHeight = self.titleLabel.frame.size.height;
    CGFloat titleWidth = self.titleLabel.frame.size.width;
    
    switch (self.titleInsetsType) {
        case FYTitleLeft:
            [self setTitleEdgeInsets:UIEdgeInsetsMake(0, -imageWidth - 2, 0, imageWidth + 2)];
            [self setImageEdgeInsets:UIEdgeInsetsMake(0, titleWidth + 2, 0, -titleWidth - 2)];
            break;
        case FYTitleRight:
            [self setTitleEdgeInsets:UIEdgeInsetsMake(0, 2, 0, -2)];
            [self setImageEdgeInsets:UIEdgeInsetsMake(0, -2, 0, 2)];
            break;
        case FYTitleTop:
            [self setTitleEdgeInsets:UIEdgeInsetsMake(-imageHeight/2 - 2, -imageWidth, imageHeight/2 + 2, 0)];
            [self setImageEdgeInsets:UIEdgeInsetsMake(titleHeight/2 + 2, titleWidth/2, -titleHeight/2 - 2, -titleWidth/2)];
            break;
        case FYTitleBottom:
            [self setTitleEdgeInsets:UIEdgeInsetsMake(imageHeight/2 + 2, -imageWidth, -imageHeight/2 - 2, 0)];
            [self setImageEdgeInsets:UIEdgeInsetsMake(-titleHeight/2 - 2, titleWidth/2, titleHeight/2 + 2, -titleWidth/2)];
            break;
        default:
            break;
    }
}

@end
