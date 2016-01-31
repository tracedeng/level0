//
//  CreditExchangeInCell.m
//  Calculus
//
//  Created by ben on 15/12/24.
//  Copyright © 2015年 tracedeng. All rights reserved.
//

#import "CreditExchangeInCell.h"
#import "ClickableImageView.h"
#import "UIColor+Extension.h"
#import "UIImageView+WebCache.h"
#import "Constance.h"


@interface CreditExchangeInCell ()
@property (weak, nonatomic) IBOutlet UILabel *creditDueLBL;
@property (weak, nonatomic) IBOutlet UILabel *creditAmountLBL;
@property (weak, nonatomic) IBOutlet ClickableImageView *checkImageView;

@property (nonatomic, assign) BOOL checked;     // toggle时上一个状态
@property (nonatomic, retain) UIImage *checkedImage;
@property (nonatomic, retain) UIImage *uncheckedImage;
//@property (weak, nonatomic) IBOutlet UIImageView *logoIMG;

@end


@implementation CreditExchangeInCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setAwardInfo:(NSDictionary *)awardInfo {
    if (awardInfo) {
        _awardInfo = awardInfo;
        
//        self.logoIMG.layer.cornerRadius = self.logoIMG.frame.size.width / 2.0f;
//        self.logoIMG.layer.borderWidth = 1.0f;
//        self.logoIMG.layer.borderColor = [[UIColor colorWithHex:0xDC1915] CGColor];
//        self.logoIMG.clipsToBounds = YES;
        
        self.checkedImage = [UIImage imageNamed:@"icon-radio-checked"];
        self.uncheckedImage = [UIImage imageNamed:@"icon-radio"];
        
        self.creditDueLBL.text = [[awardInfo objectForKey:@"et"] substringToIndex:10];
        self.creditAmountLBL.text = [[awardInfo objectForKey:@"qu"] stringValue];
        self.checkImageView.afterClickImageView = ^(id sender) {
            if (self.afterToggleAction) {
                self.afterToggleAction(self.checked, [self.tableView indexPathForCell:self]);
            }
        };
    }
}
//
//- (void)setLogoPath:(NSString *)logoPath {
//    if (logoPath) {
//        _logoPath = logoPath;
//        
//        //圆角
//        self.logoIMG.clipsToBounds = YES;
//        //        self.logoImageView.layer.cornerRadius = 4.0f;
//        self.logoIMG.layer.cornerRadius = self.logoIMG.frame.size.height / 2.0;
//        NSString *path = [NSString stringWithFormat:@"%@/%@?imageView2/1/w/300/h/300", QINIUURL, _logoPath];
//        [self.logoIMG sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:nil];
//    }
//}

- (void)toggle {
    self.checkImageView.image = self.checked ? self.uncheckedImage : self.checkedImage;
    self.checked = !self.checked;
}

@end
