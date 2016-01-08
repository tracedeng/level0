//
//  MActivityCell.m
//  Calculus
//
//  Created by ben on 16/1/3.
//  Copyright © 2016年 tracedeng. All rights reserved.
//

#import "MActivityCell.h"

@interface MActivityCell()
@property (weak, nonatomic) IBOutlet UIImageView *activityPosterIMG;
@property (weak, nonatomic) IBOutlet UILabel *activityTitleLBL;
@property (weak, nonatomic) IBOutlet UILabel *activityMerchantLBL;
@property (weak, nonatomic) IBOutlet UILabel *activityCreditLBL;
@property (weak, nonatomic) IBOutlet UILabel *activityIntroduceLBL;

@end

@implementation MActivityCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setActivityInfo:(NSMutableDictionary *)activityInfo {
    if (activityInfo) {
        _activityInfo = activityInfo;
        self.activityTitleLBL.text = [activityInfo objectForKey:@"t"];
        //TODO 活动海报显示
//        self.activityPosterIMG.image = [activityInfo objectForKey:@"po"];
        self.activityMerchantLBL.text = [activityInfo objectForKey:@"id"];
        self.activityCreditLBL.text = [activityInfo objectForKey:@"100"];
        self.activityIntroduceLBL.text = [activityInfo objectForKey:@"in"];


        
    }
}
@end