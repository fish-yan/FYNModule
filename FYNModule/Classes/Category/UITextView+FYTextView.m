//
//  UITextView+FYTextView.m
//  MobileWorkstation
//
//  Created by 薛焱 on 2017/6/4.
//  Copyright © 2017年 cjm-ios. All rights reserved.
//

#import "UITextView+FYTextView.h"
#import <objc/runtime.h>

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

const void *placeholderKey = @"placeholderKey";
const void *placeholderLabKey = @"placeholderLabKey";

@interface UITextView ()

@property (nonatomic, strong) UILabel *placeholderLab;

@end

@implementation UITextView (FYTextView)

// public

- (void)setPlaceholder:(NSString *)placeholder {
    objc_setAssociatedObject(self, placeholderKey, placeholder, OBJC_ASSOCIATION_COPY_NONATOMIC);
    if (!self.placeholderLab) {
        self.placeholderLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 30)];
        self.placeholderLab.font = self.font;
        self.placeholderLab.textColor = UIColorFromRGB(0xc7c7cd);
        [self addSubview:self.placeholderLab];
    }
    self.placeholderLab.text = placeholder;
    self.placeholderLab.hidden = self.text.length > 0;
}

- (NSString *)placeholder {
    return objc_getAssociatedObject(self, placeholderKey);
}

// private

- (void)setPlaceholderLab:(UILabel *)placeholderLab {
    objc_setAssociatedObject(self, placeholderLabKey, placeholderLab, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self addObserver:self forKeyPath:@"text" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidChange:) name:UITextViewTextDidChangeNotification object:nil];
}

- (UILabel *)placeholderLab {
    return objc_getAssociatedObject(self, placeholderLabKey);
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"text"]) {
        self.placeholderLab.hidden = [change[NSKeyValueChangeNewKey] length] > 0;
    }
}

- (void)textViewDidChange:(NSNotification *)notification {
    UITextView *tv = notification.object;
    self.placeholderLab.hidden = tv.text.length > 0;
}

- (void)dealloc {
    if (self.placeholder) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
        [self removeObserver:self forKeyPath:@"text"];
    }
}



@end
