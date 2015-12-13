//
//  ClickableImageView.h
//  Calculus
//
//  Created by tracedeng on 15/12/13.
//  Copyright © 2015年 tracedeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClickableImageView : UIImageView
@property (nonatomic, copy) void (^afterClickImageView)(id sender); //点击imageview回调

@end
