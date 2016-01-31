//
//  CreditExchangeSessionHeader.m
//  Calculus
//
//  Created by tracedeng on 16/1/31.
//  Copyright © 2016年 tracedeng. All rights reserved.
//

#import "CreditExchangeSessionHeader.h"
#import "UIImageView+WebCache.h"
#import "Constance.h"

@interface CreditExchangeSessionHeader ()
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@end

@implementation CreditExchangeSessionHeader

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setLogoPath:(NSString *)logoPath {
    if (logoPath) {
        _logoPath = logoPath;
        
        //圆角
        self.logoImageView.clipsToBounds = YES;
        self.logoImageView.layer.cornerRadius = 4.0f;
//        self.logoImageView.layer.cornerRadius = self.logoImageView.frame.size.height / 2.0;
        NSString *path = [NSString stringWithFormat:@"%@/%@?imageView2/1/w/300/h/300", QINIUURL, _logoPath];
        [self.logoImageView sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:nil];
    }
}

- (void)setName:(NSString *)name {
    if (name) {
        _name = name;
        
        self.nameLabel.text = name;
    }
}

@end
