//
//  FYNCustomPicker.h
//  MobileWorkstation
//
//  Created by 薛焱 on 2017/7/24.
//  Copyright © 2017年 cjm-ios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FYNPickerModel : NSObject
@property (copy, nonatomic) NSString *title;
@property (assign, nonatomic) BOOL isSelect;
@property (assign, nonatomic) NSInteger index;

@end

@interface FYNCustomPicker : UIView
@property (copy, nonatomic) NSArray *pickerArray;
@property (copy, nonatomic) NSArray *selectedArray;


@property (assign, nonatomic) BOOL multiselect;

@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@property (copy, nonatomic) void(^cancelBtnAction)(UIButton *sender);
@property (copy, nonatomic) void(^commitBtnAction)(NSArray *selectArray);

- (void)showPickerView;

- (void)hiddenPickerView;
@end
