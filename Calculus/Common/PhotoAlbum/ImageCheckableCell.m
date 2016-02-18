//
//  ImageCheckableCell.m
//  Wearable
//
//  Created by tracedeng on 15/3/12.
//  Copyright (c) 2015年 tracedeng. All rights reserved.
//

#import "ImageCheckableCell.h"

@interface ImageCheckableCell ()

@property (weak, nonatomic) IBOutlet UIView *forgroundWhenChecked;
@property (weak, nonatomic) IBOutlet UIButton *checkButton;
@end

@implementation ImageCheckableCell

- (void)setAssetImage:(UIImage *)assetImage {
    [super setAssetImage:assetImage];
    [self.checkButton setBackgroundImage:[UIImage imageNamed:@"photo-uncheck"] forState:UIControlStateNormal];
    self.checkButton.alpha = 0.5;
}

- (void)switchCheckState {
    self.bCheckState = !self.bCheckState;
    
    if (self.bCheckState) {
        [self.checkButton setBackgroundImage:[UIImage imageNamed:@"photo-check"] forState:UIControlStateNormal];
        self.checkButton.alpha = 1.0;
    }else{
        //未选中状态
        [self.checkButton setBackgroundImage:[UIImage imageNamed:@"photo-uncheck"] forState:UIControlStateNormal];
        self.checkButton.alpha = 0.5;
    }
}

@end
