//
//  FYPicker.m
//  MobileWorkstation
//
//  Created by 薛焱 on 16/9/21.
//  Copyright © 2016年 cjm-ios. All rights reserved.
//

#import "FYNPicker.h"

@interface FYNPicker ()<UIPickerViewDelegate, UIPickerViewDataSource>
@property (strong, nonatomic) UITextField *textField;
@property (assign, nonatomic) NSInteger currentRow;
@end

@implementation FYNPicker

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadPickerView];
    }
    return self;
}

- (void)loadPickerView {
    self.currentRow = 0;
    self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 250);
    UIView *view = [[UINib nibWithNibName:@"FYNPicker" bundle:[NSBundle bundleForClass:[self classForCoder]]] instantiateWithOwner:self options:nil].lastObject;
    view.frame = self.bounds;
    [self addSubview:view];
    [self addTextFieldObserver];
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

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setPickerArray:(NSArray *)pickerArray {
    _pickerArray = pickerArray;
    [self.pickerView reloadAllComponents];
}

- (IBAction)cancleBtnAction:(UIButton *)sender {
    [self.textField resignFirstResponder];
    if (self.cancel) {
        self.cancel();
    }
}

- (IBAction)commitBtnAction:(UIButton *)sender {
    if (self.pickerArray.count == 0) {
        [self cancleBtnAction:sender];
        return;
    }
    self.textField.text = self.pickerArray[self.currentRow];
    if (self.commite) {
        self.commite(self.currentRow);
    }
    [self cancleBtnAction:sender];
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.pickerArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.pickerArray[row];
}

#pragma mark - UIPickerViewDelegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.currentRow = row;
}

@end
