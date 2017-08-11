
//
//  FYNNotification.m
//  MobileWorkstation
//
//  Created by 薛焱 on 2017/6/2.
//  Copyright © 2017年 cjm-ios. All rights reserved.
//

#import "FYNNotification.h"
#import "UIImage+FYImage.h"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface FYNNotification ()
@property (nonatomic, weak)IBOutlet UIView *oneView;
@property (nonatomic, weak) IBOutlet UIImageView *statusImg;
@property (nonatomic, weak) IBOutlet UILabel *messageLab;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *imgWidthMargin;
@property (nonatomic, assign) BOOL shouldShow;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation FYNNotification

+ (FYNNotification *)share {
    static FYNNotification *notification;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        notification = [[FYNNotification alloc]init];
    });
    return notification;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(0, -100, [UIScreen mainScreen].bounds.size.width, 100);
        [self loadView];
    }
    return self;
}

- (void)loadView {
    self.oneView = [[UINib nibWithNibName:@"FYNNotification" bundle:[NSBundle bundleForClass:[self classForCoder]]]instantiateWithOwner:self options:nil].lastObject;
    self.oneView.frame = self.bounds;
    [self addSubview:self.oneView];
    self.shouldShow = YES;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panAction:)];
    [self.oneView addGestureRecognizer:pan];
}

- (void)panAction:(UIPanGestureRecognizer *)pan {
    if ([pan translationInView:pan.view].y < -20) {
        [self dismissNotification];
    }
}

+ (void)showWithStatus:(FYNNotificationStatus)status Message:(NSString *)message Duration:(CGFloat)duration {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([FYNNotification share].shouldShow) {
            [[FYNNotification share] showNotificationWithStatus:status Message:message Duration:duration];
        }
        [FYNNotification share].shouldShow = YES;
    });
    
}

+ (void)dismiss {
    [FYNNotification share].shouldShow = NO;
    [[FYNNotification share] dismissNotification];
}

- (void)showNotificationWithStatus:(FYNNotificationStatus)status Message:(NSString *)message Duration:(CGFloat)duration {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if ([window.subviews containsObject:[FYNNotification share]]) {
        [self.timer invalidate];
        self.timer = nil;
    } else {
        [window addSubview:[FYNNotification share]];
    }
    self.messageLab.text = message;
    switch (status) {
        case FYNNotice:
            self.statusImg.image = [UIImage fyImageNamed:@"FYN-Notification-notice"];
            self.oneView.backgroundColor = UIColorFromRGB(0x00c26d);
            self.messageLab.textColor = [UIColor whiteColor];
            break;
        case FYNSuccess:
            self.statusImg.image = [UIImage fyImageNamed:@"FYN-Notification-notice"];
            self.oneView.backgroundColor = UIColorFromRGB(0x00c26d);
            self.messageLab.textColor = [UIColor whiteColor];
            break;
//        case FYNWarning:
//            self.statusImg.image = [UIImage imageNamed:@""];
//            self.oneView.backgroundColor = [UIColor orangeColor];
//            self.messageLab.textColor = [UIColor whiteColor];
//            break;
        case FYNError:
            self.statusImg.image = [UIImage fyImageNamed:@"FYN-Notification-error"];
            self.oneView.backgroundColor = UIColorFromRGB(0xff3b30);
            self.messageLab.textColor = [UIColor whiteColor];
            break;
        default:
            self.statusImg.image = [UIImage imageNamed:@""];
            self.oneView.backgroundColor = UIColorFromRGB(0x00c26d);
            self.messageLab.textColor = [UIColor whiteColor];
            break;
    }
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:15 options:(UIViewAnimationOptionAllowUserInteraction) animations:^{
        [FYNNotification share].frame = CGRectMake(0, -36, [UIScreen mainScreen].bounds.size.width, 100);
    } completion:^(BOOL finished) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:duration target:self selector:@selector(dismissNotification) userInfo:nil repeats:NO];
    }];
}

- (void)dismissNotification {
    [UIView animateWithDuration:0.2 animations:^{
        [FYNNotification share].frame = CGRectMake(0, -100, [UIScreen mainScreen].bounds.size.width, 100);
    } completion:^(BOOL finished) {
        [self.timer invalidate];
        self.timer = nil;
        [[FYNNotification share] removeFromSuperview];
    }];
}

@end
