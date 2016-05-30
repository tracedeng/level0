//
//  RechargeTVC.m
//  Calculus
//
//  Created by tracedeng on 16/3/3.
//  Copyright © 2016年 tracedeng. All rights reserved.
//

#import "RechargeTVC.h"
#import "ClickableView.h"
#import "ActionFlow.h"

@interface RechargeTVC () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *rechargeMoney;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *rechargeMoneyView;
@property (weak, nonatomic) IBOutlet UIView *manualMoneyView;
@property (weak, nonatomic) IBOutlet UITextField *manualRechargeMoney;
@property (weak, nonatomic) IBOutlet UIButton *rechargeButton;

@property (nonatomic, retain) ClickableView *lastCheckView;
@property (nonatomic, assign) NSInteger chargeMoney;
@end

@implementation RechargeTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.balanceLabel.text = [NSString stringWithFormat:@"%.2f", self.balance];
    for (ClickableView *view in self.rechargeMoneyView) {
        view.clipsToBounds = YES;
        view.layer.cornerRadius = 4.0f;
        view.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        view.layer.borderWidth = 1.0f;
        __weak ClickableView *_my = view;

        view.afterClickView = ^(id sender) {
            self.manualRechargeMoney.text = @"";
            [self.manualRechargeMoney resignFirstResponder];
            if (self.lastCheckView) {
                self.lastCheckView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
            }

            _my.layer.borderColor = [[UIColor blueColor] CGColor];
            self.lastCheckView = _my;

            UITextField *field = [_my.subviews objectAtIndex:0];
            self.chargeMoney = [field.text integerValue];
        };
    }
    self.manualMoneyView.clipsToBounds = YES;
//    self.manualMoneyView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
//    self.manualMoneyView.layer.borderWidth = 1.0f;
    self.manualMoneyView.layer.cornerRadius = 4.0f;
    
    self.rechargeButton.clipsToBounds = YES;
    self.rechargeButton.layer.cornerRadius = 4.0f;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (0 == indexPath.section) {
        return 60.0f;
    }else if (1 == indexPath.section) {
        return 150.0f;
    }else if (3 == indexPath.section) {
        return 70.0f;
    }
    return 44.0f;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return 0.01f;
}

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

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.chargeMoney = 0;
    if (self.lastCheckView) {
        self.lastCheckView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        self.lastCheckView = nil;
        self.chargeMoney = 0;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.chargeMoney = [textField.text integerValue];
    if (self.lastCheckView) {
        self.lastCheckView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        self.lastCheckView = nil;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (string.length == 0) return YES;     //支持已经输满长度按退格键删除
    if (textField == self.manualRechargeMoney) {
        if ([string isEqualToString:@"0"] && (textField.text.length == 0)) {
            return NO;
        }
        //检查输入，只能输入4个字符
        if (textField.text.length > 3) {
            return NO;
        }
    }
    
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)recharge:(id)sender {
    [self.manualRechargeMoney resignFirstResponder];
    NSString *title = [NSString stringWithFormat:@"本次充值金额%ld元", (long)self.chargeMoney];
    if ((self.chargeMoney < 100) || (self.chargeMoney > 5000)) {
        title = @"充值金额填写错误，点击取消重新输入";
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    if ((self.chargeMoney > 0) && (self.chargeMoney <= 5000)) {
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //
            [self dismissViewControllerAnimated:alert completion:nil];
            //        [self.navigationController popToRootViewControllerAnimated:YES];
            ActionFlow *flow = [[ActionFlow alloc] init];
            flow.afterRecharge = ^(NSString *result) {
                UIAlertController *alert2 = [UIAlertController alertControllerWithTitle:@"充值成功" message:nil preferredStyle:UIAlertControllerStyleAlert];
                [alert2 addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    [self dismissViewControllerAnimated:alert completion:nil];
                    ActionFlow *balance = [[ActionFlow alloc] init];
                    balance.afterQueryBalance = ^(NSString *balance) {
                        self.balance = [balance floatValue];
                        self.balanceLabel.text = [NSString stringWithFormat:@"%.2f", self.balance];
                        // 拉取最新的帐户余额
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshBalance" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:balance, @"money", nil]];
                    };
                    [balance doQueryBalance:self.merchant];

                }]];
                [self presentViewController:alert2 animated:YES completion:nil];
//                ActionFlow *balance = [[ActionFlow alloc] init];
//                balance.afterQueryBalance = ^(NSString *balance) {
//                    self.balance = [balance floatValue];
//                    self.balanceLabel.text = [NSString stringWithFormat:@"%.2f", self.balance];
//                    // 拉取最新的帐户余额
//                    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshBalance" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:balance, @"money", nil]];
//                };
//                [balance doQueryBalance:self.merchant];
            };
            flow.afterRechargeFailed = ^(NSString *message) {
                UIAlertController *alert2 = [UIAlertController alertControllerWithTitle:@"充值失败，请重新尝试" message:nil preferredStyle:UIAlertControllerStyleAlert];
                [alert2 addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    //
                    [self dismissViewControllerAnimated:alert completion:nil];
                    //        [self.navigationController popToRootViewControllerAnimated:YES];
                }]];
                
                [self presentViewController:alert2 animated:YES completion:nil];
            };
            [flow doRecharge:self.merchant money:self.chargeMoney];
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
