//
//  MCounponCell.m
//  Calculus
//
//  Created by ben on 16/1/9.
//  Copyright © 2016年 tracedeng. All rights reserved.
//

#import "MCounponCell.h"

@implementation MCounponCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setCouponInfo:(NSMutableDictionary *)conponInfo {
    if (conponInfo) {
        _couponInfo = conponInfo;
//        self.activityTitleLBL.text = [activityInfo objectForKey:@"t"];
//        //TODO 活动海报显示
//        //        self.activityPosterIMG.image = [activityInfo objectForKey:@"po"];
//        self.activityMerchantLBL.text = [activityInfo objectForKey:@"id"];
//        self.activityCreditLBL.text = [activityInfo objectForKey:@"100"];
//        self.activityIntroduceLBL.text = [activityInfo objectForKey:@"in"];
//        
        
        
    }
}

@end
