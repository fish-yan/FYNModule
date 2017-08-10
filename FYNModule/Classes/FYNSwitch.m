//
//  FYNSwitch.m
//  MobileWorkstation
//
//  Created by 薛焱 on 2017/6/2.
//  Copyright © 2017年 cjm-ios. All rights reserved.
//

#import "FYNSwitch.h"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface FYNSwitch ()
@property (nonatomic, strong) UIView *roundView;
@property (nonatomic, strong) UILabel *openLab;
@property (nonatomic, strong) UILabel *closeLab;
@end

const static CGFloat height = 30;

@implementation FYNSwitch


- (UIView *)roundView {
    if (!_roundView) {
        _roundView = [[UIView alloc]initWithFrame:CGRectMake(1, 1, height - 2, height - 2)];
        _roundView.layer.cornerRadius = (height - 2)/2;
        _roundView.userInteractionEnabled = NO;
        _roundView.backgroundColor = [UIColor whiteColor];
    }
    return _roundView;
}

- (void)setSelected:(BOOL)selected {
    _selected = selected;
    CGFloat x = 0;
    UIColor *color;
    if (_selected) {
        x = height + 1;
        color = UIColorFromRGB(0x00C62D);
    } else {
        x = 1;
        color = UIColorFromRGB(0xf0f0f0);
    }
    self.roundView.frame = CGRectMake(x, 1, height - 2, height - 2);
    self.backgroundColor = color;
}

- (void)setOpenTitle:(NSString *)openTitle {
    _openTitle = openTitle;
    self.openLab.text = _openTitle;
}

- (void)setCloseTitle:(NSString *)closeTitle {
    _closeTitle = closeTitle;
    self.closeLab.text = _closeTitle;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)layoutSubviews {
    self.frame = CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame), 2 * height, height);
}

- (void)initView {
    self.frame = CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame), 2 * height, height);
    self.layer.cornerRadius = height / 2;
    self.backgroundColor = UIColorFromRGB(0xf0f0f0);
    [self addBtn];
    [self addLab];
    [self addSubview:self.roundView];
}

- (void)addBtn {
    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn.frame = CGRectMake(0, 0, 2 * height, height);
    btn.layer.cornerRadius = height / 2;
    [btn setTitle:@"" forState:(UIControlStateNormal)];
    btn.tintColor = [UIColor clearColor];
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:btn];
}

- (void)addLab {
    self.openLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, height, height)];
    self.openLab.text = self.openTitle?:@"开";
    self.openLab.font = [UIFont systemFontOfSize:14];
    self.openLab.textColor = [UIColor whiteColor];
    self.openLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.openLab];
    
    self.closeLab = [[UILabel alloc]initWithFrame:CGRectMake(height, 0, height, height)];
    self.closeLab.text = self.closeTitle?:@"关";
    self.closeLab.font = [UIFont systemFontOfSize:14];
    self.closeLab.textColor = UIColorFromRGB(0x797d82);
    self.closeLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.closeLab];
}

- (void)btnAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    [UIView animateWithDuration:0.2 animations:^{
        self.selected = sender.selected;
    }];
    
    if (self.selectAction) {
        self.selectAction(sender.selected);
    }
}

@end
