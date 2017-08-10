//
//  FYNKeyboard.m
//  test
//
//  Created by 薛焱 on 2017/5/26.
//  Copyright © 2017年 薛焱. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FYNKeyboard.h"
#import "FYNKeyboardCell.h"

@interface FYNKeyboard ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, assign) FYNKeyboardType type;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, copy) NSArray *dataArray;
@property (nonatomic, assign) CGFloat areaWidth;
@property (nonatomic, assign) CGFloat height;

@end

@implementation FYNKeyboard

+ (FYNKeyboard *)areaKeyboard {
    FYNKeyboard *keyboard = [[FYNKeyboard alloc]init];
    keyboard.type = FYArea;
    keyboard.textLimit = 1;
    return keyboard;
}

+ (FYNKeyboard *)charKeyboard {
    FYNKeyboard *keyboard = [[FYNKeyboard alloc]init];
    keyboard.type = FYChar;
    keyboard.textLimit = 100;
    return keyboard;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadKeyboardView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self loadKeyboardView];
    }
    return self;
}

- (void)loadKeyboardView {
    self.areaWidth = ([UIScreen mainScreen].bounds.size.width - 7) / 8;
    self.height = self.areaWidth + 5;
    self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.height * 5 + 10);
    UIView *oneView = [[UINib nibWithNibName:@"FYNKeyboard" bundle:[NSBundle bundleForClass:[self classForCoder]]]instantiateWithOwner:self options:nil].lastObject;
    oneView.frame = self.bounds;
    [self addSubview:oneView];
    [self registCell];
    [self addTextFieldObserver];
}

- (void)setType:(FYNKeyboardType)type {
    _type = type;
    if (self.type == FYChar) {
        self.dataArray = @[@"港", @"澳", @"警", @"学", @"领", @"无", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"0", @"Q", @"W", @"E", @"R", @"T", @"Y", @"U", @"I", @"O", @"P", @"A", @"S", @"D", @"F", @"G", @"H", @"J", @"K", @"L", @"", @"Z", @"X", @"C", @"V", @"B", @"N", @"M", @""];
    } else {
        self.dataArray = @[@"京", @"沪", @"浙", @"苏", @"粤", @"鲁", @"晋", @"冀", @"豫", @"川", @"渝", @"辽", @"吉", @"黑", @"皖", @"鄂", @"湘", @"赣", @"闽", @"陕", @"甘", @"宁", @"蒙", @"津", @"贵", @"云", @"桂", @"琼", @"青", @"新", @"藏", @"军", @"其", @"收起"];
    }
}

- (void)registCell {
    [self.collectionView registerNib:[UINib nibWithNibName:@"FYNKeyboardCell" bundle:[NSBundle bundleForClass:[self classForCoder]]] forCellWithReuseIdentifier:@"FYNKeyboardCell"];
}

- (void)addTextFieldObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidBeginEditing:) name:UITextFieldTextDidBeginEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidEndEditing:) name:UITextFieldTextDidEndEditingNotification object:nil];
}

-(void)textFieldDidBeginEditing:(NSNotification *)notification {
    self.textField = notification.object;
}

- (void)textFieldDidEndEditing:(NSNotification *)notification {
    self.textField = nil;
}

- (UITextField *)previousTextField {
    UIView *oneView = [self.textField.superview viewWithTag:self.textField.tag - 1];
    if ([oneView isKindOfClass:[UITextField class]]) {
        return (UITextField *)oneView;
    } /*else if ([[self getTextFields] count] != 0) {
        NSArray *textFields = [self getTextFields];
        NSInteger index = [textFields indexOfObject:self.textField] - 1;
        if (index < textFields.count) {
            return [textFields objectAtIndex:index];
        }
    }*/
    return nil;
}


- (UITextField *)nextTextField {
    UIView *oneView = [self.textField.superview viewWithTag:self.textField.tag + 1];
    if ([oneView isKindOfClass:[UITextField class]]) {
        return (UITextField *)oneView;
    }/* else if ([[self getTextFields] count] != 0) {
        NSArray *textFields = [self getTextFields];
        NSInteger index = [textFields indexOfObject:self.textField] + 1;
        if (index < textFields.count) {
            return [textFields objectAtIndex:index];
        }
    }*/
    return nil;
}

- (NSArray *)getTextFields {
    NSMutableArray *textFields = [NSMutableArray array];
    for (UIView *oneView in self.textField.superview.subviews) {
        if ([oneView isKindOfClass:[UITextField class]]) {
            [textFields addObject:(UITextField *)oneView];
        }
    }
    return textFields;
}

- (NSString *)textWithInputChar:(NSString *)input {
    UITextPosition *beginPosition = self.textField.beginningOfDocument;
    UITextRange *textRange = self.textField.selectedTextRange;
    NSInteger location = [self.textField offsetFromPosition:beginPosition toPosition:textRange.start];
    NSInteger length = [self.textField offsetFromPosition:textRange.start toPosition:textRange.end];
    NSRange range = NSMakeRange(location, length);
    NSString *str = self.textField.text;
    str = [str stringByReplacingCharactersInRange:range withString:input];
    
    return str;
}


-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, 3, 5, 3);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.type == FYChar) {
        if (indexPath.row < 6) {
            return CGSizeMake(([UIScreen mainScreen].bounds.size.width - 7)/6, self.height);
        } else if (indexPath.row == 36) {
            return CGSizeMake(([UIScreen mainScreen].bounds.size.width - 7)/20 * 3, self.height);
        }else if (indexPath.row == 43) {
            return CGSizeMake([UIScreen mainScreen].bounds.size.width - 7 - 7.5 * ([UIScreen mainScreen].bounds.size.width - 6)/10, self.height);
        } else {
            return CGSizeMake(([UIScreen mainScreen].bounds.size.width - 7)/10, self.height);
        }
    } else {
        if (indexPath.row == 33) {
            return CGSizeMake([UIScreen mainScreen].bounds.size.width - self.areaWidth - 6, self.height);
        } else {
            return CGSizeMake(self.areaWidth, self.height);
        }
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FYNKeyboardCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FYNKeyboardCell" forIndexPath:indexPath];
    cell.lab.text = self.dataArray[indexPath.row];
    if (self.type == FYChar) {
        if (indexPath.row < 16) {
            cell.imgWidth.constant = 0;
            cell.leftSpace.constant = 0;
            cell.type = FYBlack;
        } else if (indexPath.row == 23 || indexPath.row == 24) {
            cell.imgWidth.constant = 0;
            cell.leftSpace.constant = 0;
            cell.type = FYGary;
        } else if (indexPath.row == 35) {
            cell.img.image = [UIImage imageNamed:@"FYN-KB-delete"];
            cell.imgWidth.constant = 25;
            cell.leftSpace.constant = 0;
            cell.type = FYBlack;
        } else if (indexPath.row == 36) {
            cell.imgWidth.constant = 0;
            cell.leftSpace.constant = ([UIScreen mainScreen].bounds.size.width - 10)/20;
            cell.type = FYWhite;
        } else if (indexPath.row == 43) {
            cell.img.image = [UIImage imageNamed:@"FYN-KB-return"];
            cell.imgWidth.constant = 25;
            cell.leftSpace.constant = 0;
            cell.type = FYBlue;
        } else {
            cell.imgWidth.constant = 0;
            cell.leftSpace.constant = 0;
            cell.type = FYWhite;
        }
    } else {
        if (indexPath.row == 33) {
            cell.img.image = [UIImage imageNamed:@"FYN-KB-return"];
            cell.imgWidth.constant = 25;
            cell.leftSpace.constant = 0;
            cell.type = FYBlue;
        } else {
            cell.imgWidth.constant = 0;
            cell.leftSpace.constant = 0;
            cell.type = FYWhite;
        }
    }
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (self.type == FYArea) {
        if (indexPath.row == 33) {
            [self.textField resignFirstResponder];
        } else {
            if (self.textField.text.length >= self.textLimit) {
                [self.textField deleteBackward];
            }
            [self.textField insertText:self.dataArray[indexPath.row]];
            if (self.textField.text.length >= self.textLimit) {
                UITextField *next = [self nextTextField];
                if (next) {
                    [next becomeFirstResponder];
                } else {
                    [self.textField resignFirstResponder];
                }
            }
        }
    } else {
        if (indexPath.row == 23 || indexPath.row == 24) {
        } else if (indexPath.row == 35) {
            if (!self.textField.hasText) {
                UITextField *previousTF = [self previousTextField];
                if (previousTF) {
                    [previousTF becomeFirstResponder];
                }
            }
            [self.textField deleteBackward];
        } else if (indexPath.row == 43) {
            [self.textField resignFirstResponder];
        } else {
            if (self.textField.text.length >= self.textLimit) {
                [self.textField deleteBackward];
            }
            [self.textField insertText:self.dataArray[indexPath.row]];
            if (self.textField.text.length >= self.textLimit) {
                UITextField *next = [self nextTextField];
                if (next) {
                    [next becomeFirstResponder];
                } else if (self.textField.text.length >= self.textLimit) {
                    [self.textField resignFirstResponder];
                }
            }
        }
    }
}


@end
