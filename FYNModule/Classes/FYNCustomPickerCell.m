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
    [self.selectBtn setImage:[UIImage fyImageNamed:@"FYN-QB-unselected.png"] forState:(UIControlStateNormal)];
    [self.selectBtn setImage:[UIImage fyImageNamed:@"FYN-QB-selected.png"] forState:(UIControlStateSelected)];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
