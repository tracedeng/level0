//
//  BalanceHistoryCell.m
//  Calculus
//
//  Created by tracedeng on 16/2/25.
//  Copyright © 2016年 tracedeng. All rights reserved.
//

#import "BalanceHistoryCell.h"

@interface BalanceHistoryCell()
@property (weak, nonatomic) IBOutlet UILabel *balanceTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@end

@implementation BalanceHistoryCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setHistory:(NSDictionary *)history {
    if (history) {
        _history = history;
        NSString *direction = [history objectForKey:@"di"];
        if ([direction isEqualToString:@"recharge"]) {
            self.balanceTypeLabel.text = @"充值";
            self.moneyLabel.text = [NSString stringWithFormat:@"+%.2f", [[history objectForKey:@"mo"] floatValue]];
        }else if ([direction isEqualToString:@"withdrawals"]){
            self.balanceTypeLabel.text = @"提现";
            self.moneyLabel.text = [NSString stringWithFormat:@"-%.2f", [[history objectForKey:@"mo"] floatValue]];
        }
        self.timeLabel.text = [history objectForKey:@"ti"];
//        self.moneyLabel.text = [[history objectForKey:@"mo"] stringValue];;
//        self.balanceLabel.text = [[history objectForKey:@"ba"] stringValue];
    }
}
@end
