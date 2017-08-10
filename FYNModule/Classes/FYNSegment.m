//
//  FYSegment.m
//  Module
//
//  Created by 薛焱 on 2016/11/16.
//  Copyright © 2016年 薛焱. All rights reserved.
//

#import "FYNSegment.h"

@interface FYNSegment()
@property (nonatomic, strong) NSMutableArray *btnArray;
@property (strong, nonatomic) NSMutableArray *subLineArray;
@property (strong, nonatomic) UIView *lineView;
@property (strong, nonatomic) UIView *longLineView;
@property (nonatomic, strong) NSArray *normalImageArray;
@end

@implementation FYNSegment

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.currentIndex = 0;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.currentIndex = 0;
    }
    return self;
}

- (void)layoutSubviews {
    [self updateFrame];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self updateFrame];
}

- (UIView *)longLineView {
    if (_longLineView == nil) {
        _longLineView = [[UIView alloc]init];
        _longLineView.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:0];
        [self insertSubview:self.longLineView atIndex:0];
    }
    return _longLineView;
}

- (UIView *)lineView {
    if (_lineView == nil) {
        _lineView = [[UIView alloc]init];
        [self addSubview:self.lineView];
    }
    return _lineView;
}

- (NSMutableArray *)btnArray {
    if (_btnArray == nil) {
        _btnArray = [NSMutableArray array];
    }
    return _btnArray;
}

- (NSMutableArray *)subLineArray {
    if (_subLineArray == nil) {
        _subLineArray = [NSMutableArray array];
    }
    return _subLineArray;
}

- (void)updateFrame {
    if (self.btnArray.count == 0) {
        return;
    }
    CGFloat width = CGRectGetWidth(self.frame) / self.btnArray.count;
    NSInteger i = 0;
    for (UIButton *btn in self.btnArray) {
        btn.frame = CGRectMake(width * i, 0, width, CGRectGetHeight(self.frame));
        i++;
    }
    NSInteger j = 0;
    for (UIView *subLine in self.subLineArray) {
        subLine.frame = CGRectMake(width * (j + 1) - 1, CGRectGetHeight(self.frame) / 3, 1, CGRectGetHeight(self.frame)/3);
        j++;
    }
    self.longLineView.frame = CGRectMake(0, CGRectGetHeight(self.frame) - 1, CGRectGetWidth(self.frame), 1);
    [UIView animateWithDuration:0.2 animations:^{
        self.lineView.frame = CGRectMake(self.currentIndex * width, CGRectGetHeight(self.frame) - 2, width, 2);
    }];
}

- (void)setTitleArray:(NSArray *)titleArray {
    _titleArray = titleArray;
    if (self.btnArray.count < titleArray.count) {
        [self addButtonWith:titleArray.count];
    }
    [self.btnArray enumerateObjectsUsingBlock:^(UIButton *  _Nonnull btn, NSUInteger idx, BOOL * _Nonnull stop) {
        [btn setTitle:_titleArray[idx] forState:(UIControlStateNormal)];
    }];
    
}

- (void)setImageArray:(NSArray *)imageArray forState:(UIControlState)state {
    if (state == UIControlStateNormal) {
        self.normalImageArray = imageArray;
    }
    if (self.btnArray.count < imageArray.count) {
        [self addButtonWith:imageArray.count];
    }
    [self.btnArray enumerateObjectsUsingBlock:^(UIButton *  _Nonnull btn, NSUInteger idx, BOOL * _Nonnull stop) {
        [btn setImage:[UIImage imageNamed:imageArray[idx]] forState:state];
        btn.titleLabel.font = [UIFont systemFontOfSize:10];
        CGFloat titleTop = btn.imageView.frame.size.height/2;
        CGFloat titleLeft = btn.imageView.frame.size.width/2;
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(titleTop + 2, -titleLeft, -titleTop - 2, titleLeft)];
        CGFloat imageTop = btn.titleLabel.frame.size.height / 2;
        CGFloat imageLeft = btn.titleLabel.frame.size.width/2;
        [btn setImageEdgeInsets:UIEdgeInsetsMake(-imageTop - 2, imageLeft, imageTop + 2, -imageLeft)];
    }];
}

- (void)addButtonWith:(NSInteger)count {
    for (UIButton *btn in self.btnArray) {
        [btn removeFromSuperview];
    }
    [self.btnArray removeAllObjects];
    for (int i = 0; i < count; i++) {
        UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [btn setTintColor:[UIColor clearColor]];
        [btn setTitleColor:self.defaultColor forState:(UIControlStateNormal)];
        [btn setTitleColor:self.selectedColor forState:(UIControlStateSelected)];
        if (i < self.titleArray.count) {
           [btn setTitle:self.titleArray[i] forState:(UIControlStateNormal)];
        }
        if (i < self.normalImageArray.count) {
            [btn setImage:[UIImage imageNamed:self.normalImageArray[i]] forState:UIControlStateNormal];
        }
        
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        btn.tag = i;
        if (self.currentIndex == i) {
            btn.selected = YES;
        }
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:btn];
        [self.btnArray addObject:btn];
    }
    for (int j = 0; j<count - 1; j++) {
        UIView *subLine = [[UIView alloc]init];
        subLine.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
        [self addSubview:subLine];
        [self.subLineArray addObject:subLine];
    }
    [self updateFrame];
}

- (void)setDefaultColor:(UIColor *)defaultColor {
    _defaultColor = defaultColor;
    for (UIButton *btn in self.btnArray) {
        [btn setTitleColor:defaultColor forState:(UIControlStateNormal)];
    }
}

- (void)setSelectedColor:(UIColor *)selectedColor {
    _selectedColor = selectedColor;
    for (UIButton *btn in self.btnArray) {
        [btn setTitleColor:selectedColor forState:(UIControlStateSelected)];
    }
    self.lineView.backgroundColor = selectedColor;
}

- (void)setCurrentIndex:(NSInteger)currentIndex {
    _currentIndex = currentIndex;
    NSInteger i = 0;
    for (UIButton *btn in self.btnArray) {
        if (currentIndex == i) {
            btn.selected = YES;
        } else {
            btn.selected = NO;
        }
        i++;
    }
    [self updateFrame];
}

- (void)btnAction:(UIButton *)sender {
    self.currentIndex = sender.tag;
    if (self.segmentSelect) {
        self.segmentSelect(sender.tag);
    }
}


@end
