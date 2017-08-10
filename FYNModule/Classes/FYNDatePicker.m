//
//  FYDatePicker.m
//  MobileWorkstation
//
//  Created by 薛焱 on 16/9/21.
//  Copyright © 2016年 cjm-ios. All rights reserved.
//

#import "FYNDatePicker.h"

@interface FYNDatePicker ()
@property (strong, nonatomic) UITextField *textField;
@end

@implementation FYNDatePicker

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 250);
        [self loadNib];
    }
    return self;
}

- (void)loadNib {
    UINib *nib = [UINib nibWithNibName:@"FYNDatePicker" bundle:[NSBundle bundleForClass:[self classForCoder]]];
    UIView *view = [nib instantiateWithOwner:self options:nil].lastObject;
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

- (IBAction)cancleBtn:(UIButton *)sender {
    [self.textField resignFirstResponder];
}
- (IBAction)commitBtn:(UIButton *)sender {
    NSDate *date = self.datePicker.date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"YYYY/MM/dd";
    self.textField.text = [formatter stringFromDate:date];
	[self.textField resignFirstResponder];
}

@end
