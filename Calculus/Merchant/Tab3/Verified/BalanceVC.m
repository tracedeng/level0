//
//  BalanceVC.m
//  Calculus
//
//  Created by tracedeng on 16/2/25.
//  Copyright © 2016年 tracedeng. All rights reserved.
//

#import "BalanceVC.h"

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
    self.withdrawalsButton.layer.cornerRadius = 4.0f;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
