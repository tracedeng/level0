//
//  ClickableStackView.h
//  Calculus
//
//  Created by ben on 15/12/12.
//  Copyright © 2015年 tracedeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClickableStackView : UIStackView

@property (nonatomic, copy) void (^afterClickStackView)(id sender); //点击stackview回调

@end
