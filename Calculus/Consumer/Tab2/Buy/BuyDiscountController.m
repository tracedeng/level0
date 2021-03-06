//
//  BuyDiscountController.m
//  Calculus
//
//  Created by tracedeng on 16/1/5.
//  Copyright © 2016年 tracedeng. All rights reserved.
//

#import "BuyDiscountController.h"
#import "ClickableImageView.h"
#import "BuyDiscountTVC.h"
#import "ActionDiscount.h"
#import "UIColor+Extension.h"
#import "XHToast.h"

@interface BuyDiscountController ()
@property (nonatomic, assign) NSInteger checkedCredit;
@property (nonatomic, retain) BuyDiscountTVC *buyDiscountTVC;
@property (nonatomic, assign) NSInteger upperQuantity;

@property (weak, nonatomic) IBOutlet UILabel *checkedCreditLabel;
@property (weak, nonatomic) IBOutlet UILabel *moreCreditLabel;
@property (weak, nonatomic) IBOutlet UIButton *buyButton;

- (IBAction)buyDiscountAction:(id)sender;
@end

@implementation BuyDiscountController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCheckedCredit:) name:@"updateCheckedCredit" object:nil];
    
    // 展示已选、还需要多少积分
    self.checkedCreditLabel.text = @"0";
    self.upperQuantity = [[self.discountInfo objectForKey:@"cr"] integerValue];
    self.moreCreditLabel.text = [NSString stringWithFormat:@"%ld", self.upperQuantity];

    self.buyButton.clipsToBounds = YES;
    self.buyButton.layer.cornerRadius = 4.0f;
    if (0 == self.upperQuantity) {
        self.buyButton.enabled = YES;
        self.buyButton.backgroundColor = [UIColor colorWithHex:0x149BFF alpha:1.0];
    }else{
        // 不可获取
        self.buyButton.enabled = NO;
        self.buyButton.backgroundColor = [UIColor colorWithHex:0xcfcfcf alpha:1.0];
    }
}

- (void)updateCheckedCredit:(NSNotification *)notification {
    NSInteger quantity = [[[notification userInfo] objectForKey:@"quantity"] integerValue];
//    DLog(@"%ld", quantity);
    self.checkedCreditLabel.text = [NSString stringWithFormat:@"%ld", quantity];
    self.moreCreditLabel.text = [NSString stringWithFormat:@"%ld", self.upperQuantity - quantity];
    if (self.upperQuantity == quantity) {
        self.buyButton.enabled = YES;
        self.buyButton.backgroundColor = [UIColor colorWithHex:0x149BFF alpha:1.0];
    }else{
        self.buyButton.enabled = NO;
        self.buyButton.backgroundColor = [UIColor colorWithHex:0xcfcfcf alpha:1.0];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updateCheckedCredit" object:nil];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"EmbedCreditList"]) {
        if ([segue.destinationViewController isKindOfClass:[BuyDiscountTVC class]]) {
            BuyDiscountTVC *destination = (BuyDiscountTVC *)segue.destinationViewController;
//            destination.merchant = self.merchant;
            destination.merchant = [self.discountInfo objectForKey:@"mid"];
            destination.needQuantity = [[self.discountInfo objectForKey:@"cr"] integerValue];
            self.buyDiscountTVC = (BuyDiscountTVC *)segue.destinationViewController;
//            self.buyDiscountTVC.merchant = self.merchant;
            
        }
    }
}


- (IBAction)buyDiscountAction:(id)sender {
    NSArray *credits = [self.buyDiscountTVC spendCredits];
    ActionDiscount *action = [[ActionDiscount alloc] init];
    action.afterConsumerBuyDiscount = ^(NSString *credit) {
        // 获取成功
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"获取活动成功" message:@"请到个人中心查看优惠券" preferredStyle:UIAlertControllerStyleActionSheet];
        [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }]];
        [self presentViewController:alert animated:YES completion:nil];

    };
    action.afterConsumerBuyDiscountFailed = ^(NSString *message) {
        // 获取失败
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"获取活动失败" message:message preferredStyle:UIAlertControllerStyleActionSheet];
        [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }]];
        [self presentViewController:alert animated:YES completion:nil];
        
    };
    action.afterConsumerBuyDiscountFailedNetConnect = ^(NSString *message) {
        // 获取失败
        [XHToast showCenterWithText:@"网络不可用，无法与服务器通讯，请检查移动数据网络或WIFI是否开启" duration:3.0];

        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"获取活动失败" message:message preferredStyle:UIAlertControllerStyleActionSheet];
        [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }]];
        [self presentViewController:alert animated:YES completion:nil];
        
    };

    [action doConsumerBuyDiscount:[self.discountInfo objectForKey:@"id"] ofMerchant:self.merchant withCredit:credits];

}
@end
