//
//  ClickableView.h
//  Calculus
//
//  Created by tracedeng on 16/3/3.
//  Copyright © 2016年 tracedeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClickableView : UIView
@property (nonatomic, copy) void (^afterClickView)(id sender); //点击stackview回调

@end
