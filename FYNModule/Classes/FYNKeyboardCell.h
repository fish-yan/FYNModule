//
//  FYNKeyboardCell.h
//  test
//
//  Created by 薛焱 on 2017/5/26.
//  Copyright © 2017年 薛焱. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FYNKeyboardEnum.h"

@interface FYNKeyboardCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *lab;
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgWidth;
@property (nonatomic, assign) FYNKeyboardCellType type;
@end
