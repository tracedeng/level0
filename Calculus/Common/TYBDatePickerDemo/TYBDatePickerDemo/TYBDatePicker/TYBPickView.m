//
//  TYBPickView.m
//  TYBDatePickerDemo
//
//  Created by 滕跃兵 on 16/1/21.
//  Copyright © 2016年 滕跃兵. All rights reserved.
//

#import "TYBPickView.h"

#define deviceWidth [UIScreen mainScreen].bounds.size.width
#define deviceHeight [UIScreen mainScreen].bounds.size.height


@interface TYBPickView()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UIDatePicker *datepickView;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UIStackView *operationStackView;

//遮罩
@property (nonatomic, strong) UIView *maskView;

@property (nonatomic, strong) NSDictionary *data;

@property (nonatomic, assign) CGFloat height;

@end


@implementation TYBPickView

- (UIView *)maskView {
    if (_maskView == nil) {
        _maskView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, deviceWidth, deviceHeight)];
        _maskView.backgroundColor = _maskViewColor ? _maskViewColor : [UIColor colorWithWhite:0.2 alpha:0.3];
        
    }
    return _maskView;
}


- (NSDictionary *)data {
    if(_data == nil) {
        _data = [[NSDictionary alloc] init];
    }
    return _data;
}

- (instancetype)initWithMode:(TYBPickViewType)type target:(id<TYBPickViewDelegate>)target title:(NSString *)title {
    if (self = [super init]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"TYBPickView" owner:nil options:nil] firstObject];
        self.height = self.pickerView.frame.origin.y - self.operationStackView.frame.origin.y + self.pickerView.frame.size.height;
        self.confirmDelegate = target;
        self.pickerMode = type;
        self.title = title;
        self.frame = CGRectMake(0, deviceHeight - 49, deviceWidth, self.height );
        
    }
    return self;
}

- (void)setPickerData:(NSArray<NSArray *> *)pickerData{
    if (pickerData) {
        _pickerData = pickerData;
        [self.pickerView reloadAllComponents];
    }
}

- (void)setPickerMode:(TYBPickViewType)pickerMode {
    _pickerMode = pickerMode;
    switch (pickerMode) {
        case TYBPickViewTypeDate:
            self.datepickView.datePickerMode = UIDatePickerModeDate;
            break;
        case TYBPickViewTypeTime:
            self.datepickView.datePickerMode = UIDatePickerModeTime;
            break;
        case TYBPickViewTypeDateAndTime:
            self.datepickView.datePickerMode = UIDatePickerModeDateAndTime;
            break;
        case TYBPickViewTypeCountDownTimer:
            self.datepickView.datePickerMode = UIDatePickerModeCountDownTimer;
            break;
        case TYBPickViewTypeCustom:
            self.datepickView.hidden = YES;
            self.pickerView.hidden = NO;
            self.pickerView.delegate = self;
            self.pickerView.dataSource = self;
            break;
        default:
            break;
    }
}

- (void)setTitle:(NSString *)title {
    if (title) {
        _title = title;
        self.titleLable.text = title;
    }
}

- (void)show {
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, deviceHeight - self.height - 113 , deviceWidth, self.height);
        [self.superview insertSubview:self.maskView belowSubview:self];
    }completion:^(BOOL finished) {
    }];
}

- (void)hide{
    [UIView animateWithDuration:0.3 animations:^{
        [self.maskView removeFromSuperview];
        self.frame = CGRectMake(0, deviceHeight, deviceWidth, self.height);
    }completion:^(BOOL finished) {
    }];
}

- (IBAction)cancle:(id)sender {
    [self hide];
}

- (IBAction)confirm:(id)sender {
    
    if (self.pickerMode == TYBPickViewTypeCustom) {
        
        NSMutableArray *result = [NSMutableArray array];
        for (int i = 0; i < self.pickerData.count; i++) {
            int index = (int)[self.pickerView selectedRowInComponent:i];
            [result addObject:self.pickerData[i][index]];
        }
        
        [self.confirmDelegate pickView:self didClickButtonConfirm:result];
    }else{
        // 时区转换
        NSDate *date=[_datepickView date];
        NSTimeZone *timeZone=[NSTimeZone systemTimeZone];
        NSInteger seconds=[timeZone secondsFromGMTForDate:date];
        NSDate *newDate=[date dateByAddingTimeInterval:seconds];
        [self.confirmDelegate pickView:self didClickButtonConfirm:newDate];
    }
    
    [self hide];
}

#pragma mark --- 用户自定义时实现可以调用的方法
- (NSInteger)selectedRowInComponent:(NSInteger)component {
    if(self.pickerMode == TYBPickViewTypeCustom){
        return [self.pickerView selectedRowInComponent:component];
    }else{
        return -1;
    }
}

- (void)reloadAllComponents {
    if(self.pickerMode == TYBPickViewTypeCustom){
         [self.pickerView reloadAllComponents];
    }
}

- (void)reloadComponent:(NSInteger)component {
    if(self.pickerMode == TYBPickViewTypeCustom){
    [self.pickerView reloadComponent:component];
    }
}
- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated{
    if(self.pickerMode == TYBPickViewTypeCustom){
    [self.pickerView selectRow:row inComponent:component animated:animated];
    }
}

#pragma mark --- 用户自定义时，pickerview的数据源
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.pickerData ? self.pickerData[component].count : 0;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return self.pickerData ? self.pickerData.count : 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.pickerData ? self.pickerData[component][row] : nil;
}

@end
