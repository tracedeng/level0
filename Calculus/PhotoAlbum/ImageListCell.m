//
//  ImageListCell.m
//  Wearable
//
//  Created by tracedeng on 15/3/13.
//  Copyright (c) 2015年 tracedeng. All rights reserved.
//

#import "ImageListCell.h"
@interface ImageListCell ()
@property (weak, nonatomic) IBOutlet UIImageView *ChoosableImage;
@end

@implementation ImageListCell

- (void)setAssetImage:(UIImage *)assetImage {
    _assetImage = assetImage;
    if (assetImage) {
        self.ChoosableImage.image = assetImage;
    }
    //图片自适应
    //    self.ChoosableImage.contentMode = UIViewContentModeScaleAspectFit;
}

@end
