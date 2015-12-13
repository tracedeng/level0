//
//  ImageListCVC.h
//  Wearable
//
//  Created by tracedeng on 15/3/12.
//  Copyright (c) 2015年 tracedeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoAlbum.h"

@interface ImageListCVC : UICollectionViewController

@property (nonatomic, assign) BOOL bMultiChecked;   //是否可多选
@property (nonatomic, assign) NSInteger checkedCount;   //当前已选照片数量
@property (nonatomic, assign) NSInteger checkableCount; //当前可选照片数量

@property (nonatomic, retain) NSMutableArray *currentCheckedImages; //每个元素是NSDictionary，保存缩略图和全尺寸图片
@end
