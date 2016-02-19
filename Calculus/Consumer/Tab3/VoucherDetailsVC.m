//
//  VoucherDetailsVC.m
//  Calculus
//
//  Created by ben on 16/2/19.
//  Copyright © 2016年 tracedeng. All rights reserved.
//

#import "VoucherDetailsVC.h"
#import "UIColor+Extension.h"


@interface VoucherDetailsVC ()
@property (weak, nonatomic) IBOutlet UIView *voucherTitleView;
@property (weak, nonatomic) IBOutlet UIView *voucherNumberView;
@property (weak, nonatomic) IBOutlet UIView *voucherQrCodeView;
@property (weak, nonatomic) IBOutlet UIView *voucherBackgroundVIew;

@end

@implementation VoucherDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //    圆角
    self.voucherBackgroundVIew.clipsToBounds = YES;
    self.voucherBackgroundVIew.layer.cornerRadius = 4.0f;
    self.voucherBackgroundVIew.layer.borderWidth = 1.0f;
    self.voucherBackgroundVIew.layer.borderColor = [[UIColor colorWithHex:0x555555] CGColor];

//    self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.size.height / 2.0;
    
    
    self.voucherTitleView.layer.borderWidth = 1.0f;
    self.voucherTitleView.layer.borderColor = [[UIColor colorWithHex:0xDDDDDD] CGColor];

    self.voucherNumberView.layer.borderWidth = 1.0f;
    self.voucherNumberView.layer.borderColor = [[UIColor colorWithHex:0xDDDDDD] CGColor];
    
    self.voucherQrCodeView.layer.borderWidth = 1.0f;
    self.voucherQrCodeView.layer.borderColor = [[UIColor colorWithHex:0xDDDDDD] CGColor];

    
    
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
