//
//  FYNCustomPickerCell.m
//  MobileWorkstation
//
//  Created by 薛焱 on 2017/7/24.
//  Copyright © 2017年 cjm-ios. All rights reserved.
//

#import "FYNCustomPickerCell.h"
#import "UIImage+FYImage.h"

@implementation FYNCustomPickerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    NSBundle *bundle = [NSBundle bundleForClass:[self classForCoder]];
    [self.selectBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@/FYN-QB-unselected.png", bundle.bundlePath]] forState:(UIControlStateNormal)];
    [self.selectBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@/FYN-QB-selected.png", bundle.bundlePath]] forState:(UIControlStateSelected)];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
