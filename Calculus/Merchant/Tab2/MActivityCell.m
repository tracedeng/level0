//
//  MActivityCell.m
//  Calculus
//
//  Created by ben on 16/1/3.
//  Copyright © 2016年 tracedeng. All rights reserved.
//

#import "MActivityCell.h"
#import "UIImageView+WebCache.h"
#import "Constance.h"

@interface MActivityCell()
@property (weak, nonatomic) IBOutlet UIImageView *activityPosterIMG;
@property (weak, nonatomic) IBOutlet UILabel *activityTitleLBL;
@property (weak, nonatomic) IBOutlet UILabel *activityMerchantLBL;
@property (weak, nonatomic) IBOutlet UILabel *activityCreditLBL;
@property (weak, nonatomic) IBOutlet UILabel *activityIntroduceLBL;
@property (weak, nonatomic) IBOutlet UIView *activityBackground;
@property (weak, nonatomic) IBOutlet UILabel *activityExpireLBL;

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
    self.activityBackground.clipsToBounds = YES;
    self.activityBackground.layer.cornerRadius = 4.0f;
    if (activityInfo) {
        _activityInfo = activityInfo;
        self.activityPosterIMG.clipsToBounds = YES;
        self.activityPosterIMG.layer.cornerRadius = 4.0f;
        NSString *path = [NSString stringWithFormat:@"%@/%@?imageView2/1/w/300/h/300", QINIUURL, [activityInfo objectForKey:@"po"]];
        [self.activityPosterIMG sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:nil];
        
        self.activityTitleLBL.text = [activityInfo objectForKey:@"t"];
        self.activityMerchantLBL.text = self.merchantName;
        self.activityExpireLBL.text = [[activityInfo objectForKey:@"et"] substringToIndex:10];
        self.activityCreditLBL.text = [[activityInfo objectForKey:@"cr"] stringValue];
        self.activityIntroduceLBL.text = [activityInfo objectForKey:@"in"];
    }
}
@end
