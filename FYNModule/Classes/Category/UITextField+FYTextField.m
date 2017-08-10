//
//  UITextField+FYTextField.m
//  MobileWorkstation
//
//  Created by 薛焱 on 2016/11/30.
//  Copyright © 2016年 cjm-ios. All rights reserved.
//

#import "UITextField+FYTextField.h"
#import <objc/runtime.h>
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation UITextField (FYTextField)

@dynamic fyInputModel;

const void *canEditingKey = @"canEditingKey";

const void *beginEditingKey = @"beginEditingKey";
const void *endEditingKey = @"endEditingKey";
const void *changeEditingKey = @"changeEditingKey";

const void *showActionMenuKey = @"showActionMenuKey";
const void *promptKey = @"promptKey";

//MARK: Public

- (void)setShowActionMenu:(BOOL)showActionMenu {
    objc_setAssociatedObject(self, showActionMenuKey, [NSNumber numberWithInteger:showActionMenu], OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)showActionMenu {
    NSNumber *showActionMenu = objc_getAssociatedObject(self, showActionMenuKey);
    if (!showActionMenu) {
        return YES;
    }
    return [showActionMenu boolValue];
}

- (void)setPrompt:(NSString *)prompt {
    UILabel *lab;
    if ([self viewWithTag:-1001]) {
        lab = [self viewWithTag:-1001];
    } else {
        lab = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame) - 5, CGRectGetWidth(self.frame), 10)];
        lab.textColor = UIColorFromRGB(0x787878);
        lab.font = [UIFont systemFontOfSize:10];
        lab.tag = -1001;
        self.clipsToBounds = NO;
        [self addSubview:lab];
    }
    lab.text = prompt;
    objc_setAssociatedObject(self, promptKey, prompt, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)prompt {
    return objc_getAssociatedObject(self, promptKey);
}

- (void)setCanEditing:(BOOL)canEditing {
    self.userInteractionEnabled = canEditing;
    if (canEditing) {
        self.textColor = [UIColor colorWithRed:64/255.0 green:64/255.0 blue:64/255.0 alpha:1];
    } else {
        self.textColor = [UIColor colorWithRed:180/255.0 green:180/255.0 blue:180/255.0 alpha:1];
        self.placeholder = @"";
    }
    NSNumber *canENum = [NSNumber numberWithBool:canEditing];
    objc_setAssociatedObject(self, canEditingKey, canENum, OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)canEditing {
    NSNumber *canENum = objc_getAssociatedObject(self, canEditingKey);
    return [canENum boolValue];
}


//MARK: TextFieldAction

- (void)setBeginEditing:(void (^)(UITextField *))beginEditing {
    [self addTarget:self action:@selector(textFieldBeginEditing:) forControlEvents:(UIControlEventEditingDidBegin)];
    objc_setAssociatedObject(self, beginEditingKey, beginEditing, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(UITextField *))beginEditing {
    return objc_getAssociatedObject(self, beginEditingKey);
}

- (void)textFieldBeginEditing:(UITextField *)textField {
    if (self.beginEditing) {
        self.beginEditing(textField);
    }
}

- (void)setChangeEditing:(void (^)(UITextField *))changeEditing {
    objc_setAssociatedObject(self, changeEditingKey, changeEditing, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(textFieldChangeEditing:) forControlEvents:(UIControlEventEditingChanged)];
}

- (void (^)(UITextField *))changeEditing {
    return objc_getAssociatedObject(self, changeEditingKey);
}

- (void)textFieldChangeEditing:(UITextField *)textField {
    if (self.changeEditing) {
        self.changeEditing(textField);
    }
}


- (void)setEndEditing:(void (^)(UITextField *))endEditing {
    [self addTarget:self action:@selector(textFieldEndEditing:) forControlEvents:(UIControlEventEditingDidEnd)];
    objc_setAssociatedObject(self, endEditingKey, endEditing, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(UITextField *))endEditing {
    return objc_getAssociatedObject(self, endEditingKey);
}

- (void)textFieldEndEditing:(UITextField *)textField {
    if (self.endEditing) {
        self.endEditing(textField);
    }
}


//MARK: TextFieldModel

- (void)setFyInputModel:(FYCategoryTFModel)fyInputModel {
    switch (fyInputModel) {
        case PriceModel:
            self.keyboardType = UIKeyboardTypeDecimalPad;
            [self addTarget:self action:@selector(priceTextField:) forControlEvents:(UIControlEventEditingChanged)];
            [self addTarget:self action:@selector(priceBeginTextField:) forControlEvents:(UIControlEventEditingDidBegin)];
            [self addTarget:self action:@selector(pricEndTextField:) forControlEvents:(UIControlEventEditingDidEnd)];
            break;
        case PhoneNumModel:
            self.keyboardType = UIKeyboardTypeNumberPad;
            [self addTarget:self action:@selector(phoneNumTextField:) forControlEvents:(UIControlEventEditingChanged)];
            break;
        case VINNumModel:
            self.spellCheckingType = UITextSpellCheckingTypeNo;
            self.autocorrectionType = UITextAutocorrectionTypeNo;
            self.keyboardType = UIKeyboardTypeASCIICapable;
            self.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
            [self addTarget:self action:@selector(VINNumTextField:) forControlEvents:(UIControlEventEditingChanged)];
            break;
        default:
            break;
    }
}

- (void)priceBeginTextField:(UITextField *)textField {
    if ([textField.text doubleValue] == 0) {
        textField.text = @"";
    } else {
        textField.text = [NSString stringWithFormat:@"%g", [textField.text doubleValue]];
    }
}

- (void)priceTextField:(UITextField *)textField {
    if (textField.text.length > 0) {
        unichar single = [textField.text characterAtIndex:textField.text.length - 1];
        if (single >='0' && single<='9') {
            if (([textField.text characterAtIndex:0] == '0' && (textField.text.length != 1) && [textField.text characterAtIndex:1] != '.') || [textField.text characterAtIndex:0] == '.') {
                NSRange range = {0, 1};
                NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:@""];
                textField.text = text;
            }
            if ([textField.text containsString:@"."]) {
                NSRange dian = [textField.text rangeOfString:@"."];
                if (textField.text.length - dian.location > 3) {
                    NSRange range = {textField.text.length - 1, 1};
                    NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    textField.text = text;
                }
            }
        } else if (single=='.') {
            NSString *subStr = [textField.text substringToIndex:textField.text.length - 1];
            if ([subStr containsString:@"."]) {
                NSRange range = {textField.text.length - 1, 1};
                NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:@""];
                textField.text = text;
            }
        } else {
            NSRange range = {textField.text.length - 1, 1};
            NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:@""];
            textField.text = text;
        }
    }
}

- (void)pricEndTextField:(UITextField *)textField {
    textField.text = [NSString stringWithFormat:@"%.2f", [textField.text doubleValue]];
}

- (void)phoneNumTextField:(UITextField *)textField {
    if (textField.text.length > 0) {
        UniChar single = [textField.text characterAtIndex:textField.text.length - 1];
        if (!(single >= '0' && single <= '9') || textField.text.length > 11) {
            NSRange range = {textField.text.length - 1, 1};
            NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:@""];
            textField.text = text;
        }
    }
}

- (void)VINNumTextField:(UITextField *)textField {
    if (textField.text.length > 0) {
        UniChar single = [textField.text characterAtIndex:textField.text.length - 1];
        if (!((single >= '0' && single <= '9') || (single >= 'A' && single <= 'Z')) || textField.text.length > 17) {
            NSRange range = {textField.text.length - 1, 1};

            if ((single >= 'a' && single <= 'z')) {
                single -= 32;
                NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:[NSString stringWithFormat:@"%c",single]];
                textField.text = text;
            } else {
                NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:@""];
                textField.text = text;
            }
            
        }
        
    }
}


//MARK: Private

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (self.showActionMenu) {
        if ([[[UIPasteboard generalPasteboard] string] length] != 0 && action == @selector(paste:)) {
            return YES;
        }
        if (self.text.length > 0 && (action == @selector(select:) || action == @selector(selectAll:))) {
            return YES;
        }
        if ([self offsetFromPosition:self.selectedTextRange.start toPosition:self.selectedTextRange.end] != 0 && action == @selector(copy:)) {
            return YES;
        }
    }
    return NO;
}

@end
