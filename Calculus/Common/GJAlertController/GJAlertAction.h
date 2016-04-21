/*!
 @header     GJAlertAction.h
 @abstract   为Alert添加可点击的item选项
 @discussion 为了配合GJAlertController实现在低版本中也能使用AlertController的功能
 @author     guoxiaoliang850417@163.com
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class GJAlertAction;

typedef void (^GJAlertBlock) (GJAlertAction *alertAction);

typedef NS_ENUM(NSInteger, GJAlertActionStyle) {
    GJAlertActionStyleDefault = 0,
    GJAlertActionStyleCancel,
    GJAlertActionStyleDestructive
};

@interface GJAlertAction : NSObject

@property (copy, nonatomic) NSString *title;
@property (assign, nonatomic) GJAlertActionStyle style;
@property (copy, nonatomic) GJAlertBlock handler;

+ (instancetype)actionWithTitle:(NSString *)aTitle style:(GJAlertActionStyle)aStyle handler:(GJAlertBlock)aHandler;

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com