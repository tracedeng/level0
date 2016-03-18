//
//  ScanVoucherController.m
//  Calculus
//
//  Created by tracedeng on 16/2/28.
//  Copyright © 2016年 tracedeng. All rights reserved.
//

#import "ScanVoucherController.h"
#import "MVoucherVC.h"
#import "ActionMVoucher.h"
#import "ConfirmVoucherTVC.h"
#import "UIColor+Extension.h"


@interface ScanVoucherController ()
@property (nonatomic, retain) NSString *merchant;   // 商家ID
@property (nonatomic, retain) NSString *voucher;    // 优惠券ID
@property (nonatomic, retain) NSString *activity;   // 活动ID
@property (nonatomic, retain) NSString *number;     // 优惠券拥有者号码
@end

@implementation ScanVoucherController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.scanAngelColor = [UIColor colorWithHex:0x149BFF];
    self.filterColor = [UIColor colorWithHex:0x444444 alpha:0.8f];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    //判断是否有数据
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        // 判断回传的数据类型
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            //            [self endScan];
            [self performSelectorOnMainThread:@selector(endScan) withObject:nil waitUntilDone:NO];
            NSDictionary *qrcodeValue = [NSJSONSerialization JSONObjectWithData:[metadataObj.stringValue dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
            if (qrcodeValue) {
                self.merchant = [qrcodeValue objectForKey:@"mid"];
                self.voucher = [qrcodeValue objectForKey:@"vid"];
                self.activity = [qrcodeValue objectForKey:@"aid"];
                self.number = [qrcodeValue objectForKey:@"num"];
                ActionMVoucher *action = [[ActionMVoucher alloc] init];
                action.afterConfirmVoucher = ^(NSString *state) {
                    if ([state isEqualToString:@"invalid"]) {
                        //
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"无效的优惠券" message:self.voucher preferredStyle:UIAlertControllerStyleAlert];
                        [alert addAction:[UIAlertAction actionWithTitle:@"重新扫描" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                            //
                            [self startScan];
                        }]];
                        [self presentViewController:alert animated:YES completion:nil];
                    }else if([state isEqualToString:@"used"]) {
                        //
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"已使用的优惠券" message:self.voucher preferredStyle:UIAlertControllerStyleAlert];
                        [alert addAction:[UIAlertAction actionWithTitle:@"重新扫描" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                            //
                            [self startScan];
                        }]];
                        [self presentViewController:alert animated:YES completion:nil];
                    }else if ([state isEqualToString:@"valid"]) {
                        //
                        [self performSegueWithIdentifier:@"ConfirmVoucher" sender:self];
                    }
                };
                action.afterConfirmVoucherFailed = ^(NSString *message) {
                    // 无效商家ID
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"无效的优惠券" message:nil preferredStyle:UIAlertControllerStyleAlert];
                    [alert addAction:[UIAlertAction actionWithTitle:@"重新扫描" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                        //
                        [self startScan];
                    }]];
                    [self presentViewController:alert animated:YES completion:nil];
                };
                [action doConfirmVoucher:self.voucher merchant_identity:self.merchant activity_identity:self.activity consumer_number:self.number exec_confirm:NO];
            }else{
                // 不认识的二维码
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"不支持的二维码" message:nil preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"重新扫描" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                    //
                    [self startScan];
                }]];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }
    }
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"ConfirmVoucher"]) {
        if ([segue.destinationViewController isKindOfClass:[ConfirmVoucherTVC class]]) {
            ConfirmVoucherTVC *destination = (ConfirmVoucherTVC *)segue.destinationViewController;
            destination.voucher = self.voucher;
            destination.merchant = self.merchant;
            destination.activity = self.activity;
            destination.number = self.number;
            //测试
//            destination.voucher = @"adwi837498hf824791234";
        }
    }
}


@end
