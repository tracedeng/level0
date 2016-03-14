//
//  VoucherDetailsVC.m
//  Calculus
//
//  Created by ben on 16/2/19.
//  Copyright © 2016年 tracedeng. All rights reserved.
//

#import "VoucherDetailsVC.h"
#import "UIColor+Extension.h"
#import "GenerateQrcode.h"
#import "UIImage+FixOrientation.h"


@interface VoucherDetailsVC ()
@property (weak, nonatomic) IBOutlet UILabel *activityTitle;    // 活动标题
@property (weak, nonatomic) IBOutlet UIView *voucherBackgroundVIew;

@property (weak, nonatomic) IBOutlet UIView *voucherNumberView;
@property (weak, nonatomic) IBOutlet UILabel *sequence;     // 优惠券序号

@property (weak, nonatomic) IBOutlet UIView *voucherQrCodeView;
@property (weak, nonatomic) IBOutlet UIImageView *qrcode;
@property (weak, nonatomic) IBOutlet UIView *qrcodeBackground;

@end

@implementation VoucherDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.activityTitle.text = [self.voucherInfo objectForKey:@"ti"];
    
    //    圆角
    self.voucherBackgroundVIew.clipsToBounds = YES;
    self.voucherBackgroundVIew.layer.cornerRadius = 4.0f;
    self.voucherBackgroundVIew.layer.borderWidth = 1.0f;
    self.voucherBackgroundVIew.layer.borderColor = [[UIColor colorWithHex:0x555555] CGColor];
    
    self.sequence.text = [self.voucherInfo objectForKey:@"id"];
//    self.voucherNumberView.layer.borderWidth = 1.0f;
//    self.voucherNumberView.layer.borderColor = [[UIColor colorWithHex:0xDDDDDD] CGColor];
    
//    self.voucherQrCodeView.layer.borderWidth = 1.0f;
//    self.voucherQrCodeView.layer.borderColor = [[UIColor colorWithHex:0xDDDDDD] CGColor];
    self.qrcode.image = [self generateVoucherQrcode];
//    self.qrcodeBackground.layer.borderWidth = 1.0f;
//    self.qrcodeBackground.layer.borderColor = [[UIColor colorWithHex:0xDDDDDD] CGColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//
//- (void)setVoucherInfo:(NSDictionary *)voucherInfo {
//    if (voucherInfo) {
//        _voucherInfo = voucherInfo;
//        self.qrcodeImage = [GenerateQrcode createQRImage:[GenerateQrcode createWithString:qrcodeValue qrColor:[UIColor blackColor] bgColor:[UIColor whiteColor] size:CGSizeMake(480, 480)] logoImage:[UIImage createRoundedRectImage:self.logo size:CGSizeMake(160, 160)]];
//    }
//}
- (UIImage *)generateVoucherQrcode {
    NSString *qrcodeValue = [NSString stringWithFormat:@"{\"mid\":\"%@\", \"vid\":\"%@\", \"aid\":\"%@\", \"num\":\"%@\"}", [self.voucherInfo objectForKey:@"mid"], [self.voucherInfo objectForKey:@"id"], [self.voucherInfo objectForKey:@"aid"], [self.voucherInfo objectForKey:@"num"]];
    UIImage *qrcode = [GenerateQrcode createQRImage:[GenerateQrcode createWithString:qrcodeValue qrColor:[UIColor blackColor] bgColor:[UIColor whiteColor] size:CGSizeMake(480, 480)] logoImage:[UIImage createRoundedRectImage:self.logo size:CGSizeMake(160, 160)]];
    
    return qrcode;
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
