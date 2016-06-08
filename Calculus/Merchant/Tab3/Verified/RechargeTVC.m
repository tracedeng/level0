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
#import "Order.h"
#import <AlipaySDK/AlipaySDK.h>
#import "DataSigner.h"

@interface RechargeTVC () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *rechargeMoney;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *rechargeMoneyView;
@property (weak, nonatomic) IBOutlet UIView *manualMoneyView;
@property (weak, nonatomic) IBOutlet UITextField *manualRechargeMoney;
@property (weak, nonatomic) IBOutlet UIButton *rechargeButton;

@property (nonatomic, retain) NSString *tradeno;
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alipaySyncNotify:) name:@"alipaySyncNotify" object:nil];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"alipaySyncNotify" object:nil];
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

- (void)askForTradeNo:(NSInteger)money {
    ActionFlow *flow = [[ActionFlow alloc] init];
    flow.afterQueryTradeNo = ^(NSString *tradeno, NSString *sign) {
        // 呼起支付宝支付
        self.tradeno = tradeno;
        [self callAlipay:tradeno mondy:money sign:sign];
    };
    flow.afterQueryTradeNoFailed = ^(NSString *message) {
        // 请求订单号失败
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请求充值订单号失败，请重新尝试。" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:alert completion:nil];
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    };
    [flow doQueryTradeNo:self.merchant money:money];
}

- (void)callAlipay:(NSString *)tradeno mondy:(NSInteger)money sign:(NSString *)sign {
    //签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
    /*=======================需要填写商户app申请的===================================*/
    NSString *partner = @"2088221780225801";
    NSString *seller = @"biiyooit@qq.com";
    /*============================================================================*/
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"jfbw";
    
    //partner和seller获取失败,提示
    if ([partner length] == 0 || [seller length] == 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"缺少合作者身份ID或者卖家支付宝账号或者私钥。" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:alert completion:nil];
        }]];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    //生成订单信息，值固定不变，改动时也要相应修改后台
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.sellerID = seller;
    order.outTradeNO = tradeno; //订单ID（由商家自行制定）
    order.subject = @"charge"; //商品标题
    order.body = @"charge"; //商品描述
    order.totalFee = [NSString stringWithFormat:@"%ld", (long)money]; //商品价格
//    order.totalFee = [NSString stringWithFormat:@"%.2f", 1.00]; //测试商品价格，1毛钱
    order.notifyURL =  @"http://www.weijifen.me:8000/flow"; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
//    order.showURL = @"m.alipay.com";

    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    DLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
//    NSString *kk = @"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBAMmWzWbHdZC4KOvxmQYmy5x8m1Q51sigKFISF3bQgN9BMeTCUk3XNQ3cX/d7nlD122wDskI/cDhX1vtRDB1GOAebs/6gifuhzDYrGGTS2dlc+iIff2ZTrVByWmLpYeoWToFSsuN8v9g9mrtz4xfM0eA8Hpsq7Pxm1sZIRW6FIAcPAgMBAAECgYEAnAcpogR9vW6c1coge79pVwynGPDPimdT7fnsyVymcqY+XOX+2BrbCIhqit3WcqlolNjjjx0U2bc7QTfA3aOs1u6WNf0CXiTOftWSnAY/L/Ycp6f+Qa2Axp8sHBMm/WqUEeRNyEBA7zoumABuTHNzqX3auz/fVZhKeXxw5cbcLYkCQQDuyv8lcJ+Qmii0suX+lHHoJKxieyLtt2xP9ns25NffiuhlVZDjCRtKM5lGdCfpfvlIbxmNjk30e9QRkpbNARPTAkEA2B2B2rGzw9B+io0dcP/DEd9l9W4ynSABmRKZevKt7PjWxiwt0GFLAMm2Tn0PBJ39MhfrYglWWzhkRbIhRIyGVQJAaosmRlU2zLULvnwnxGwFWreqNpKMZhY1/IOUPEzkyLfYswX3jGUOyQ+2rsm62SKvJRN1CkTZIWFyoJiQMk3twwJAIoJrtuFDZFRJsJQiDGY63wK+RDepi1+OAcRvj6tqzHlbyl9JnYm7sU+EdfoQSNt1j+cz5f65tG1Hzb1JBKov1QJBAJGOriPDRNKY+N61FVUcYeG4hQEmDe17fe2DYbo7ownh2OekIJKyYot7BRkudtqw8/AMqZQW/QqKHbgy4jNVJno=";
//    id<DataSigner> signer = CreateRSADataSigner(kk);
//    NSString *signedString2 = [signer signString:orderSpec];
//    DLog("%@", signedString2);
    // 后台生产
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
//    NSString *orderString = nil;
    if (sign != nil) {
        NSString *orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"", orderSpec, sign, @"RSA"];
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            DLog(@"reslut = %@",resultDic);
            [self afterPayOrder:resultDic];
        }];
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"非法充值私钥，请联系平台。" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:alert completion:nil];
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)alipaySyncNotify:(NSNotification *)notification {
    [self afterPayOrder:[notification userInfo]];
}

- (void)afterPayOrder:(NSDictionary *)result {
    NSInteger status = [[result objectForKey:@"resultStatus"] integerValue];
    switch (status) {
        case 9000:
            //支付成功
            [self afterPay:self.tradeno];
            break;
        case 8000:
            //正在处理，暂时认为充值成功
            [self afterPay:self.tradeno];
            break;
        case 4000:
            //订单支付失败
        case 6001:
            //用户中途取消
        case 6002:
            //网络连接出错
        default:
        {
            NSDictionary *message = @{@"4000": @"充值失败，订单支付失败", @"6001": @"充值失败，用户中途取消", @"6002": @"充值失败，网络连接出错"};
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:[message objectForKey:[NSString stringWithFormat:@"%ld", (long)status]] message:nil preferredStyle:UIAlertControllerStyleAlert];
//            NSString *message = [NSString stringWithFormat:@"充值失败，%@", [result objectForKey:@"memo"]];
//            UIAlertController *alert = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self dismissViewControllerAnimated:alert completion:nil];
            }]];
            [self presentViewController:alert animated:YES completion:nil];
            break;
        }
    }
}

- (void)afterPay:(NSString *)tradeno {
    ActionFlow *flow = [[ActionFlow alloc] init];
    flow.afterRecharge = ^(NSString *result) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"充值成功" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
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
        [self presentViewController:alert animated:YES completion:nil];
    };
    flow.afterRechargeFailed = ^(NSString *message) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"充值失败，请重新尝试" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            //
            [self dismissViewControllerAnimated:alert completion:nil];
            //        [self.navigationController popToRootViewControllerAnimated:YES];
        }]];
        
        [self presentViewController:alert animated:YES completion:nil];
    };
    [flow doRecharge:self.merchant money:self.chargeMoney tradeno:tradeno];
}

- (IBAction)recharge:(id)sender {
    [self.manualRechargeMoney resignFirstResponder];
    NSString *title = [NSString stringWithFormat:@"本次充值金额%ld元", (long)self.chargeMoney];
    if ((self.chargeMoney < 100) || (self.chargeMoney > 5000)) {
        title = @"充值金额填写错误，点击取消重新输入";
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    if ((self.chargeMoney >= 100) && (self.chargeMoney <= 5000)) {
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //
            [self dismissViewControllerAnimated:alert completion:nil];
            // 请求订单号
            [self askForTradeNo:self.chargeMoney];
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
