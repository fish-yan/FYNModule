//
//  FYPicker.h
//  MobileWorkstation
//
//  Created by 薛焱 on 16/9/21.
//  Copyright © 2016年 cjm-ios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FYNPicker : UIView
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@property (copy, nonatomic) NSArray *pickerArray;
@property (copy, nonatomic) void(^commite)(NSInteger row);
@property (copy, nonatomic) void(^cancel)();
@end
