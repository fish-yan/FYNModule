//
//  FYNCustomPicker.m
//  MobileWorkstation
//
//  Created by 薛焱 on 2017/7/24.
//  Copyright © 2017年 cjm-ios. All rights reserved.
//

#import "FYNCustomPicker.h"
#import "FYNCustomPickerCell.h"
#import "UIView+FYView.h"


@implementation FYNPickerModel

@end

@interface FYNCustomPicker ()<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) UIView *maskView;
@property (strong, nonatomic) UIButton *selectAllBtn;
@property (strong, nonatomic) UITextField *textField;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerHeight;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
static NSString *identify = @"FYNCustomPickerCell";
@implementation FYNCustomPicker

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 0)];
    if (self) {
        [self loadView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self loadView];
    }
    return self;
}

- (IBAction)cancelBtnAction:(UIButton *)sender {
    [self hiddenPickerView];
    if (self.cancelBtnAction) {
        self.cancelBtnAction(sender);
    }
}


- (void)setPickerArray:(NSArray *)pickerArray {
    _dataArray = [NSMutableArray array];
    NSInteger index = 0;
    for (NSString *title in pickerArray) {
        FYNPickerModel *model = [[FYNPickerModel alloc]init];
        model.title = title;
        model.isSelect = NO;
        model.index = index;
        [_dataArray addObject:model];
        index++;
    }
    [self updateFrame];
    [self.tableView reloadData];
}

- (void)setSelectedArray:(NSArray *)selectedArray {
    for (FYNPickerModel *model in self.dataArray) {
        if ([selectedArray containsObject:model.title]) {
            model.isSelect = YES;
        }
    }
    [self.tableView reloadData];
}

- (void)setMultiselect:(BOOL)multiselect {
    _multiselect = multiselect;
    self.headerHeight.constant = multiselect ? 40 : 0;
}


- (void)loadView {
    UIView *oneView = [[UINib nibWithNibName:@"FYNCustomPicker" bundle:[NSBundle bundleForClass:[self classForCoder]]]instantiateWithOwner:self options:nil].lastObject;
    oneView.frame = self.bounds;
    [self addSubview:oneView];
    [self.tableView registerNib:[UINib nibWithNibName:identify bundle:[NSBundle bundleForClass:[self classForCoder]]] forCellReuseIdentifier:identify];
    
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
- (void)updateFrame {
    CGFloat height = 0;
    height += 44 * _dataArray.count;
    if (_multiselect) {
        height += 50;
    }
    if (height >= 408) {
        height = 408;
    }
    
    self.frame = CGRectMake(0, CGRectGetMinY(self.frame), [UIScreen mainScreen].bounds.size.width, height);
}

- (void)showPickerView {
    [self endEditing:YES];
    if (!self.maskView) {
        _maskView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        _maskView.backgroundColor = [UIColor blackColor];
        _maskView.alpha = 0.0;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        [_maskView addGestureRecognizer:tap];
        [[self viewController].view insertSubview:_maskView belowSubview:self];
    }
    CGFloat height = CGRectGetHeight(self.frame);
    [UIView animateWithDuration:0.25 animations:^{
        _maskView.alpha = 0.5;
        self.frame = CGRectMake(0, CGRectGetHeight(self.superview.frame) - height, [UIScreen mainScreen].bounds.size.width, height);
    }];
}

- (void)hiddenPickerView {
    [self endEditing:YES];
    for (FYNPickerModel *model in self.dataArray) {
        model.isSelect = NO;
    }
    [self.tableView reloadData];
    self.selectAllBtn.selected = NO;
    if (self.textField) {
        [self.textField resignFirstResponder];
        return;
    }
    CGFloat height = CGRectGetHeight(self.frame);
    [UIView animateWithDuration:0.25 animations:^{
        _maskView.alpha = 0.0;
        self.frame = CGRectMake(0, CGRectGetHeight(self.superview.frame), [UIScreen mainScreen].bounds.size.width, height);
    }];
}

- (IBAction)commitBtnAction:(UIButton *)sender {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isSelect = 1"];
    NSArray *selectArray = [self.dataArray filteredArrayUsingPredicate:predicate];
    if (self.textField) {
        NSString *text = @"";
        for (FYNPickerModel *model in selectArray) {
            text = [text stringByAppendingString:[NSString stringWithFormat:@"%@,", model.title]];
        }
        if (text.length > 0) {
            text = [text substringToIndex:text.length - 1];
        }
        if (![text isEqualToString:@"取消"]) {
            self.textField.text = text;
        }
    }
    if (_commitBtnAction) {
        _commitBtnAction(selectArray);
    }
    [self hiddenPickerView];
}

- (void)tapAction:(UITapGestureRecognizer *)tap {
    [self hiddenPickerView];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FYNCustomPickerCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    cell.titleLab.textAlignment = _multiselect ? NSTextAlignmentLeft : NSTextAlignmentCenter;
    cell.selectBtn.hidden = !self.multiselect;
    FYNPickerModel *model = _dataArray[indexPath.row];
    cell.titleLab.text = model.title;
    cell.selectBtn.selected = model.isSelect;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    FYNPickerModel *model = _dataArray[indexPath.row];
    model.isSelect = !model.isSelect;
    [tableView reloadData];
    if (!_multiselect) {
        [self commitBtnAction:nil];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}


@end
