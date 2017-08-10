//
//  FYNKeyboard.h
//  test
//
//  Created by 薛焱 on 2017/5/26.
//  Copyright © 2017年 薛焱. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FYNKeyboardEnum.h"

@interface FYNKeyboard : UIView
/**
 * 输入位数限制
 */
@property (nonatomic, assign) NSInteger textLimit;

+ (FYNKeyboard *)areaKeyboard;

+ (FYNKeyboard *)charKeyboard;

@end
