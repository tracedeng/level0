//
//  COneAwardCell.m
//  Calculus
//
//  Created by tracedeng on 15/12/24.
//  Copyright © 2015年 tracedeng. All rights reserved.
//

#import "COneAwardCell.h"

@interface COneAwardCell ()
@property (weak, nonatomic) IBOutlet UILabel *expireTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalAwardLabel;

@end

@implementation COneAwardCell

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
        self.expireTimeLabel.text = [[awardInfo objectForKey:@"et"] substringToIndex:10];
        self.totalAwardLabel.text = [[awardInfo objectForKey:@"qu"] stringValue];
    }
}

@end
