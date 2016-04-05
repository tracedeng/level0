//
//  MMemberListCell.m
//  Calculus
//
//  Created by ben on 16/4/5.
//  Copyright © 2016年 tracedeng. All rights reserved.
//

#import "MMemberListCell.h"

@implementation MMemberListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setMemberInfo:(NSDictionary *)memberInfo {

    NSLog(@"LOAD from custom cell");
}

@end
