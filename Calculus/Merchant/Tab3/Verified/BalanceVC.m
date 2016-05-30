//
//  BalanceVC.m
//  Calculus
//
//  Created by tracedeng on 16/2/25.
//  Copyright © 2016年 tracedeng. All rights reserved.
//

#import "BalanceVC.h"
#import "UIColor+Extension.h"
#import "BalanceHistoryTVC.h"
#import "RechargeTVC.h"
#import "WithdrawalsTVC.h"


@interface BalanceVC ()
@property (weak, nonatomic) IBOutlet UIImageView *balanceImageView;
@property (weak, nonatomic) IBOutlet UIButton *chargeButton;
@property (weak, nonatomic) IBOutlet UIButton *withdrawalsButton;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@end

@implementation BalanceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.balanceImageView.layer.cornerRadius = 4.0f;

    self.chargeButton.layer.cornerRadius = 4.0f;
    self.withdrawalsButton.layer.borderColor = [[UIColor colorWithHex:0xDDDDDD] CGColor];
    self.withdrawalsButton.layer.borderWidth = 1.0f;
    self.withdrawalsButton.layer.cornerRadius = 4.0f;
    
    self.moneyLabel.text = [NSString stringWithFormat:@"%.2f", self.balance];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshBalance:) name:@"refreshBalance" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshBalance:(NSNotification *)notification {
    NSString *money = [[notification userInfo] objectForKey:@"money"];
    self.balance = [money floatValue];
    self.moneyLabel.text = [NSString stringWithFormat:@"%.2f元", self.balance];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"BalanceHistory"]) {
        if ([segue.destinationViewController isKindOfClass:[BalanceHistoryTVC class]]) {
            BalanceHistoryTVC *destination = (BalanceHistoryTVC *)segue.destinationViewController;
            destination.merchant = self.merchant;
        }
    }else if([segue.identifier isEqualToString:@"BalanceRecharge"]) {
        if ([segue.destinationViewController isKindOfClass:[RechargeTVC class]]) {
            RechargeTVC *destination = (RechargeTVC *)segue.destinationViewController;
            destination.balance = self.balance;
            destination.merchant = self.merchant;
        }
    }else if([segue.identifier isEqualToString:@"BalanceWithdrawals"]) {
        if ([segue.destinationViewController isKindOfClass:[WithdrawalsTVC class]]) {
            WithdrawalsTVC *destination = (WithdrawalsTVC *)segue.destinationViewController;
            destination.maxWithdrawalsMoney = self.balance;
            destination.merchant = self.merchant;
        }
    }
}


@end
