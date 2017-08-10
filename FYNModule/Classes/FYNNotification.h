//
//  FYNNotification.h
//  MobileWorkstation
//
//  Created by 薛焱 on 2017/6/2.
//  Copyright © 2017年 cjm-ios. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    FYNNotice,
    FYNSuccess,
    FYNWarning,
    FYNError,
} FYNNotificationStatus;

@interface FYNNotification : UIView
+ (void)showWithStatus:(FYNNotificationStatus)status Message:(NSString *)message Duration:(CGFloat)duration;

+ (void)dismiss;
@end
