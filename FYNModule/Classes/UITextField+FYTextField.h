//
//  UITextField+FYTextField.h
//  MobileWorkstation
//
//  Created by 薛焱 on 2016/11/30.
//  Copyright © 2016年 cjm-ios. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    NormalModel,
    PriceModel,
    PhoneNumModel,
    VINNumModel,
} FYCategoryTFModel;

@interface UITextField (FYTextField)
@property (nonatomic, assign) BOOL canEditing;
@property (nonatomic, assign) FYCategoryTFModel fyInputModel;
@property (nonatomic, copy) void(^beginEditing)(UITextField *textField);
@property (nonatomic, copy) void(^changeEditing)(UITextField *textField);
@property (nonatomic, copy) void(^endEditing)(UITextField *textField);
@property (nonatomic, copy) NSString *prompt;


/**
 * 是否显示操作菜单 默认为YES
 */
@property (nonatomic, assign) BOOL showActionMenu;

@end
