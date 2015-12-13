//
//  ImageCheckableCell.h
//  Wearable
//
//  Created by tracedeng on 15/3/12.
//  Copyright (c) 2015年 tracedeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageListCell.h"

@interface ImageCheckableCell : ImageListCell

@property (nonatomic, assign) BOOL bCheckState;   //设置单元格中图片是否被选中

- (void)switchCheckState;

@end
