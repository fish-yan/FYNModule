//
//  FYNSwitch.h
//  MobileWorkstation
//
//  Created by 薛焱 on 2017/6/2.
//  Copyright © 2017年 cjm-ios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FYNSwitch : UIView
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, copy) IBInspectable NSString *openTitle;
@property (nonatomic, copy) IBInspectable NSString *closeTitle;
@property (nonatomic, copy) void(^selectAction)(BOOL isSelected);
@end
