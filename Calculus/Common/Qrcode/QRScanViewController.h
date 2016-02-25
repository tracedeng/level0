//
//  QRScanViewController.h
//  QRCodeDemo
//
//  Created by tracedeng on 16/1/15.
//  Copyright © 2016年 tracedeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>


@class QRScanViewController;

@protocol QRScanViewControllerDelegate <NSObject>
@optional
- (void)scanView:(QRScanViewController *) scanViewController endScanWithResult:(NSString *)result;
- (void)scanViewDidFailed:(QRScanViewController *) scanViewController ;

@end

@interface QRScanViewController : UIViewController

@property (nonatomic, weak) id<QRScanViewControllerDelegate> delegate;

/**
 *  设置提示框的内容
 */
@property(nonatomic, copy) NSString *tips;

/**
 *  设置提示文字的颜色
 */
@property(nonatomic, strong) UIColor *tipsColor;

/**
 *  设置工具框的背景颜色
 */
@property(nonatomic, strong) UIColor *toolViewBgColor;

/**
 *  设置扫描框的边角颜色
 */
@property(nonatomic, strong) UIColor *scanAngelColor;

/**
 *  工具框的内容
 */
@property(nonatomic, strong) NSArray<UIButton *> *toolItems;

/**
 *  是否开启扫描动画,默认开启
 */
@property(nonatomic, assign) BOOL scanAnimation;

/**
 *  扫描线条颜色
 */
@property(nonatomic, strong) UIColor *animationColor;

/**
 *  遮罩背景颜色
 */
@property (nonatomic, strong) UIColor *filterColor;

/**
 * 初始化方式
 */
+ (instancetype)scanView;


/**
 *  扫描成功开启震动提示,默认开启
 */
- (void)systemVibrate;

/**
 *  扫描成功开启声音提示,默认关闭
 */
- (void)systemSound;

// 初始化
//- (instancetype)init;

// 开启扫描动画
- (void)startAnimation;

// 停止扫描动画
- (void)stopAnimation;

// 默认是开启的，不需手动调用，提供给扫描失败时，用户需要重新开始扫描使用
- (void)startScan;

- (void)endScan;


- (void)toggleTorch;

@end
