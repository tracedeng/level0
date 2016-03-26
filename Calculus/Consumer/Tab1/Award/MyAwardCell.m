//
//  MyAwardCell.m
//  Calculus
//
//  Created by tracedeng on 15/12/10.
//  Copyright © 2015年 tracedeng. All rights reserved.
//

#import "MyAwardCell.h"
#import "UIImageView+WebCache.h"
#import "Constance.h"


@interface MyAwardCell ()
@property (weak, nonatomic) IBOutlet UIImageView *merchant_logo_image;
@property (weak, nonatomic) IBOutlet UILabel *merchant_name_label;
@property (weak, nonatomic) IBOutlet UILabel *total_award_label;
@property (nonatomic, retain) IBOutlet UIImageView *defaultimage;

@end

@implementation MyAwardCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setAwardInfo:(NSDictionary *)awardInfo {
    self.merchant_name_label.text = [awardInfo objectForKey:@"t"];
    self.total_award_label.text = [NSString stringWithFormat:@"%ld",[[awardInfo objectForKey:@"a"] integerValue]];
//    self.merchant_logo_image.image = [UIImage imageNamed:@"icon-mcd"];
//    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
 
    //圆角
    self.merchant_logo_image.clipsToBounds = YES;
    self.merchant_logo_image.layer.cornerRadius = 4.0f;
//    self.merchant_logo_image.layer.cornerRadius = self.merchant_logo_image.frame.size.height / 2.0;

    NSString *path = [NSString stringWithFormat:@"%@/%@?imageView2/1/w/300/h/300", QINIUURL, [awardInfo objectForKey:@"l"]];
    [self.merchant_logo_image sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"logo-merchant-default"]];

    
    self.defaultimage = [[UIImageView alloc] init];
    self.defaultimage.image=[UIImage imageNamed:@"icon-v"];
    //    self.defaultimage.frame=CGRectMake( deviceWidth *1/8, (deviceHeight - deviceWidth *3/4) / 4,  deviceWidth *3/4, deviceWidth *3/4 );
    self.defaultimage.frame=CGRectMake( self.merchant_logo_image.frame.origin.x + 35,  self.merchant_logo_image.frame.origin.y + 35, 15, 15 );
    self.defaultimage.layer.cornerRadius = self.defaultimage.frame.size.width / 2.0f;
    self.defaultimage.clipsToBounds = YES;
    self.defaultimage.backgroundColor = [UIColor whiteColor];
    
    if([[awardInfo objectForKey:@"v"] isEqualToString:@"yes"]){
        
        [self.merchant_logo_image addSubview:self.defaultimage];

    }
    
    

}
@end
