//
//  ScanMerchantController.m
//  Calculus
//
//  Created by tracedeng on 15/12/20.
//  Copyright © 2015年 tracedeng. All rights reserved.
//

#import "ScanMerchantController.h"
#import "ApplyCreditTVC.h"
#import "ActionMMaterial.h"
#import "UIColor+Extension.h"

#import <AVFoundation/AVFoundation.h>


@interface ScanMerchantController () <AVCaptureMetadataOutputObjectsDelegate>

//@property (nonatomic, retain) UIView *scanBoxView;
//
//@property (nonatomic) BOOL isReading;
//@property (strong, nonatomic) CALayer *scanLayer;
//
//@property (nonatomic, strong) AVCaptureSession *captureSession;
//@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;

@property (nonatomic, retain) NSDictionary *material;
@property (nonatomic, retain) NSString *merchant;
@property (nonatomic, assign) CGFloat money;
@end

@implementation ScanMerchantController

- (void)viewDidLoad {

    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.scanBoxView.layer.borderColor = [UIColor blueColor].CGColor;
//    self.scanBoxView.layer.borderWidth = 1.0f;

    self.scanAngelColor = [UIColor colorWithHex:0x149BFF];
    self.filterColor = [UIColor colorWithHex:0x149BFF alpha:1.0f];
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
                self.money = [[qrcodeValue objectForKey:@"ca"] floatValue];
                ActionMMaterial *action = [[ActionMMaterial alloc] init];
                action.afterQueryMerchantOfIdentity = ^(NSDictionary *material) {
                    self.material = material;
                    [self performSegueWithIdentifier:@"ApplyCredit" sender:nil];
                };
                action.afterQueryMerchantOfIdentityFailed = ^(NSString *message) {
                    // 无效商家ID
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"不支持的商家" message:nil preferredStyle:UIAlertControllerStyleAlert];
                    [alert addAction:[UIAlertAction actionWithTitle:@"重新扫描" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                        //
                        [self startScan];
                    }]];
                    [self presentViewController:alert animated:YES completion:nil];
                };
                [action doQueryMerchantOfIdentity:self.merchant];
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

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"ApplyCredit"]) {
        if ([segue.destinationViewController isKindOfClass:[ApplyCreditTVC class]]) {
            ApplyCreditTVC *destination = (ApplyCreditTVC *)segue.destinationViewController;
            destination.material = self.material;
            destination.money = self.money;
            destination.merchant = self.merchant;
        }
    }
}
@end
