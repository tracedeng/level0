//
//  ApplyCreditController.m
//  Calculus
//
//  Created by tracedeng on 16/2/25.
//  Copyright © 2016年 tracedeng. All rights reserved.
//

#import "ApplyCreditController.h"
#import "ActionCredit.h"
#import "ApplyCreditTVC.h"
#import "UIColor+Extension.h"
#import "Constance.h"

@interface ApplyCreditController ()
@property (weak, nonatomic) IBOutlet UIButton *applyButton;
@property (weak, nonatomic) IBOutlet UILabel *monetaryLabel;

@end

@implementation ApplyCreditController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UpdateApplyMoney:) name:@"UpdateApplyMoney" object:nil];
    self.applyButton.layer.cornerRadius = 4.0f;
    
    if (self.money > 0) {
        self.monetaryLabel.text = [NSString stringWithFormat:@"%0.0f", self.money];
        self.applyButton.enabled = YES;
        self.applyButton.backgroundColor = [UIColor colorWithHex:0x149BFF alpha:1.0];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 更新金额
- (void)UpdateApplyMoney:(NSNotification *)notification {
    CGFloat money = [[[notification userInfo] objectForKey:@"money"] floatValue];
    self.money = money;
    if (money > 0) {
        self.monetaryLabel.text = [NSString stringWithFormat:@"%0.0f", money];
        self.applyButton.enabled = YES;
        self.applyButton.backgroundColor = [UIColor colorWithHex:0x149BFF alpha:1.0];
    }else{
        self.monetaryLabel.text = @"0";
        self.applyButton.enabled = NO;
        self.applyButton.backgroundColor = [UIColor colorWithHex:0x00e0ff alpha:1.0];
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"EmbedApplyCredit"]) {
        if ([segue.destinationViewController isKindOfClass:[ApplyCreditTVC class]]) {
            ApplyCreditTVC *destination = (ApplyCreditTVC *)segue.destinationViewController;
            destination.material = self.material;
            destination.money = self.money;
        }
    }
}

- (IBAction)ApplyCreditAction:(id)sender {
    NSInteger money = [self.monetaryLabel.text integerValue];
    ActionCredit *action = [[ActionCredit alloc] init];
    action.afterConsumerCreateConsumption = ^() {
        DLog(@"Apply credit %ld done", (long)money);
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"申请积分成功" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //
            [self dismissViewControllerAnimated:alert completion:nil];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    };
    action.afterConsumerCreateConsumptionFailed = ^(NSString *message) {
        DLog(@"Apply credit %ld failed", (long)money);
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"申请积分失败" message:message preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            //
            [self dismissViewControllerAnimated:alert completion:nil];
//            [self.navigationController popToRootViewControllerAnimated:YES];
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    };
    [action doConsumerCreateConsumption:self.merchant money:money];
}
@end
