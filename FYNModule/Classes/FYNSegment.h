//
//  FYSegment.h
//  Module
//
//  Created by 薛焱 on 2016/11/16.
//  Copyright © 2016年 薛焱. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FYNSegment : UIView

@property (copy, nonatomic) NSArray *titleArray;

@property (assign, nonatomic) IBInspectable NSInteger currentIndex;

@property (copy, nonatomic) IBInspectable UIColor *defaultColor;

@property (copy, nonatomic) IBInspectable UIColor *selectedColor;

@property (copy, nonatomic) void(^segmentSelect)(NSInteger index);

- (void)setImageArray:(NSArray *)imageArray forState:(UIControlState)state;

@end
