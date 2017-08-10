//
//  FYNKeyboardCell.m
//  test
//
//  Created by 薛焱 on 2017/5/26.
//  Copyright © 2017年 薛焱. All rights reserved.
//

#import "FYNKeyboardCell.h"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface FYNKeyboardCell ()
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIView *maskView;
@end

@implementation FYNKeyboardCell

- (void)setSelected:(BOOL)selected {
    if (self.type == FYGary) {
        return;
    }
    [super setSelected:selected];
    [UIView animateWithDuration:0.2 animations:^{
        self.maskView.alpha = selected;
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.maskView.layer.cornerRadius = 5;
        self.backView.layer.cornerRadius = 5;
        self.backView.layer.shadowOpacity = 1;
        self.backView.layer.shadowOffset = CGSizeMake(0, 0.5);
        self.backView.layer.shadowColor = [UIColor grayColor].CGColor;
        self.backView.layer.shadowRadius = 2;
        [self.backView.layer setShadowPath:[UIBezierPath bezierPathWithRect:CGRectMake(1, 1.5, self.backView.bounds.size.width - 2, self.backView.bounds.size.height - 2)].CGPath];
    });
}

- (void)setType:(FYNKeyboardCellType)type {
    _type = type;
    switch (type) {
        case FYWhite:
            self.backView.backgroundColor = [UIColor whiteColor];
            self.lab.textColor = [UIColor darkTextColor];
            break;
        case FYBlack:
            self.backView.backgroundColor = UIColorFromRGB(0x3e3e3e);
            self.lab.textColor = [UIColor whiteColor];
            break;
        case FYGary:
            self.backView.backgroundColor = [UIColor whiteColor];
            self.lab.textColor = UIColorFromRGB(0xcccccc);
            break;
        case FYBlue:
            self.backView.backgroundColor = UIColorFromRGB(0x5165ff);
            self.lab.textColor = [UIColor whiteColor];
            break;
        default:
            break;
    }
}

@end
