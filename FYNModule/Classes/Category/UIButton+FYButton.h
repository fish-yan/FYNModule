//
//  UIButton+FYNButton.h
//  test
//
//  Created by 薛焱 on 2017/5/27.
//  Copyright © 2017年 薛焱. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    FYTitleLeft = 0,
    FYTitleRight,
    FYTitleTop,
    FYTitleBottom,
} FYTitleInsetsType;

@interface UIButton (FYButton)

@property (nonatomic, assign) FYTitleInsetsType titleInsetsType;

@end
