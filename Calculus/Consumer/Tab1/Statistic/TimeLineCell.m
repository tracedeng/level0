//
//  TimeLineCell.m
//  Calculus
//
//  Created by ben on 16/3/31.
//  Copyright © 2016年 tracedeng. All rights reserved.
//

#import "TimeLineCell.h"

@interface TimeLineCell ()
@property (weak, nonatomic) IBOutlet UILabel *CreditAmountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *MerchantLogoImageView;
@property (weak, nonatomic) IBOutlet UILabel *MerchantNameLabel;


@end


@implementation TimeLineCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setTimelineInfo:(NSDictionary *)timelineInfo {
//    self.merchant_name_label.text = [awardInfo objectForKey:@"t"];
//    self.total_award_label.text = [NSString stringWithFormat:@"%ld",[[awardInfo objectForKey:@"a"] integerValue]];
//    //    self.merchant_logo_image.image = [UIImage imageNamed:@"icon-mcd"];
//    //    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    
//
 
    
    self.MerchantLogoImageView.clipsToBounds = YES;
    self.MerchantLogoImageView.layer.cornerRadius = 4.0f;//self.MerchantLogoImageView.frame.size.height / 2.0;
 
    
    
    //圆角
    //    self.merchant_logo_image.layer.cornerRadius = self.merchant_logo_image.frame.size.height / 2.0;
//    
//    NSString *path = [NSString stringWithFormat:@"%@/%@?imageView2/1/w/300/h/300", QINIUURL, [awardInfo objectForKey:@"l"]];
//    [self.merchant_logo_image sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"logo-merchant-default"]];
//
//    
//    self.defaultimage = [[UIImageView alloc] init];
//    self.defaultimage.image=[UIImage imageNamed:@"icon-v"];
//    //    self.defaultimage.frame=CGRectMake( deviceWidth *1/8, (deviceHeight - deviceWidth *3/4) / 4,  deviceWidth *3/4, deviceWidth *3/4 );
//    self.defaultimage.frame=CGRectMake( self.merchant_logo_image.frame.origin.x + 35,  self.merchant_logo_image.frame.origin.y + 35, 15, 15 );
//    self.defaultimage.layer.cornerRadius = self.defaultimage.frame.size.width / 2.0f;
//    self.defaultimage.clipsToBounds = YES;
//    self.defaultimage.backgroundColor = [UIColor whiteColor];
//    
//    if([[awardInfo objectForKey:@"v"] isEqualToString:@"yes"]){
//        
//        [self.merchant_logo_image addSubview:self.defaultimage];
//        
//    }
//    
//    
//    
}

@end
