//
//  UIImage+FYImage.h
//  MobileWorkstation
//
//  Created by 薛焱 on 2017/5/2.
//  Copyright © 2017年 cjm-ios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (FYImage)
+ (UIImage *)screenshot;

+ (UIImage *)fyImageNamed:(NSString *)name;

- (UIImage *)blurImageWithBlur:(CGFloat)blur;

- (UIImage *)fixOrientation;

- (UIImage *)grayImage;

- (UIImage *)scaleToSize:(CGSize)size;

- (UIImage *)cutWithRect:(CGRect)rect;
@end
