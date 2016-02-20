//
//  TYBPickView.h
//  TYBDatePickerDemo
//
//  Created by 滕跃兵 on 16/1/21.
//  Copyright © 2016年 滕跃兵. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum : NSUInteger {
    TYBPickViewTypeCustom, // 用户自定义,自己设置代理,自己设置数据源
    TYBPickViewTypeTime, // 时间
    TYBPickViewTypeDate, // 日期
    TYBPickViewTypeCountDownTimer,// 显示分钟与秒
    TYBPickViewTypeDateAndTime // 日期和时间
} TYBPickViewType;



@class TYBPickView;

@protocol TYBPickViewDelegate <NSObject>

@optional
- (void)pickView:(TYBPickView *)pickView didClickButtonConfirm:(id)data;

@end



@interface TYBPickView : UIView

/**
 *  设置pickerView的类型
 */
@property (nonatomic, assign) TYBPickViewType pickerMode;

/**
 *  标题
 */
@property (nonatomic, copy) NSString *title;


/**
 *  监听点击Confirm按钮的事件
 */
@property (nonatomic, weak) id<TYBPickViewDelegate> confirmDelegate;

/**
 *  pickerView的数据
 */

@property (nonatomic, strong) NSArray<NSArray *> *pickerData;

/**
 *  遮罩背景颜色
 */
@property (nonatomic, strong) UIColor *maskViewColor;


- (instancetype)initWithMode:(TYBPickViewType)type target:(id<TYBPickViewDelegate>)target title:(NSString *)title;

/**
 *  弹出
 */
- (void)show;

/**
 *  隐藏
 */
- (void)hide;





/**
 *  用户自定义时,获取选取的行,必须是用户自定义时,否则返回-1
 *
 *  @param component 列
 *
 *  @return 行下标
 */
- (NSInteger)selectedRowInComponent:(NSInteger)component;

// Reloading whole view or single component  用户自定义时
- (void)reloadAllComponents;
- (void)reloadComponent:(NSInteger)component;
// selection. in this case, it means showing the appropriate row in the middle
- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated;  // scrolls the specified row to center.

@end
