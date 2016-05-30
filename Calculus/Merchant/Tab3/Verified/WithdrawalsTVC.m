//
//  WithdrawalsTVC.m
//  Calculus
//
//  Created by tracedeng on 16/3/3.
//  Copyright © 2016年 tracedeng. All rights reserved.
//

#import "WithdrawalsTVC.h"
#import "ActionFlow.h"

@interface WithdrawalsTVC ()
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UITextField *withdrawalsMoneyField;
@property (weak, nonatomic) IBOutlet UIButton *withdrawalsButton;
@property (weak, nonatomic) IBOutlet UIView *withdrawalsMoneyView;
@property (nonatomic, assign) NSInteger withdrawalsMoney;
@end

@implementation WithdrawalsTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.withdrawalsButton.layer.cornerRadius = 4.0f;
    
    self.withdrawalsMoneyView.clipsToBounds = YES;
    self.withdrawalsMoneyView.layer.cornerRadius = 4.0f;
    
    self.moneyLabel.text = [NSString stringWithFormat:@"最大可提现金额%.2f元", (float)self.maxWithdrawalsMoney];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (0 == indexPath.section) {
        return 70.0f;
    }else if (1 == indexPath.section) {
        return 60.0f;
    }else {
        return 80.0f;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.01f;
}
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)withdrawals:(id)sender {
    [self.withdrawalsMoneyField resignFirstResponder];
    self.withdrawalsMoney = [self.withdrawalsMoneyField.text integerValue];
    NSString *title = [NSString stringWithFormat:@"本次提现金额%ld元", (long)self.withdrawalsMoney];
    if ((self.withdrawalsMoney <= 0) || (self.withdrawalsMoney > self.maxWithdrawalsMoney)) {
        title = @"提现金额超出可提现范围，点击取消重新输入";
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    if (self.withdrawalsMoney <= self.maxWithdrawalsMoney) {
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //
            [self dismissViewControllerAnimated:alert completion:nil];
            //        [self.navigationController popToRootViewControllerAnimated:YES];
            ActionFlow *flow = [[ActionFlow alloc] init];
            flow.afterWithdrawals = ^(NSString *result) {
                UIAlertController *alert2 = [UIAlertController alertControllerWithTitle:@"提现成功，3-10个工作日内退回支付宝账号。" message:nil preferredStyle:UIAlertControllerStyleAlert];
                [alert2 addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    ActionFlow *balance = [[ActionFlow alloc] init];
                    balance.afterQueryBalance = ^(NSString *balance) {
                        //                    self.balance = [balance floatValue];
                        //                    self.balanceLabel.text = [NSString stringWithFormat:@"%.2f", self.balance];
                        self.moneyLabel.text = [NSString stringWithFormat:@"最大可提现金额%.2f元", [balance floatValue]];
                        self.maxWithdrawalsMoney = [balance floatValue];
                        // 拉取最新的帐户余额
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshBalance" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:balance, @"money", nil]];
                    };
                    [balance doQueryBalance:self.merchant];
                }]];
                [self presentViewController:alert2 animated:YES completion:nil];
            };
            flow.afterWithdrawalsFailed = ^(NSString *message) {
                UIAlertController *alert2 = [UIAlertController alertControllerWithTitle:@"今天已经提现，请明天再来" message:nil preferredStyle:UIAlertControllerStyleAlert];
                [alert2 addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    [self dismissViewControllerAnimated:alert completion:nil];
                }]];
                [self presentViewController:alert2 animated:YES completion:nil];
            };
            [flow doWithdrawals:self.merchant money:self.withdrawalsMoney];
        }]];
    }
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //
        [self dismissViewControllerAnimated:alert completion:nil];
        //        [self.navigationController popToRootViewControllerAnimated:YES];
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}
@end
