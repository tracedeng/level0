//
//  MerchantQrcodeVC.m
//  Calculus
//
//  Created by tracedeng on 16/1/24.
//  Copyright © 2016年 tracedeng. All rights reserved.
//

#import "MerchantQrcodeVC.h"
#import "UIImageView+WebCache.h"
#import "GenerateQrcode.h"
#import "ClickableImageView.h"
#import "ActionMMaterial.h"
#import "ActionQiniu.h"
#import "Constance.h"

@interface MerchantQrcodeVC ()
@property (nonatomic, retain) NSString *uploadToken;
@property (nonatomic, retain) NSString *path;
@property (nonatomic, retain) UIImage *qrcodeImage;

@property (weak, nonatomic) IBOutlet ClickableImageView *qrcodeImageView;
@property (weak, nonatomic) IBOutlet UILabel *noticeLabel;
@end

@implementation MerchantQrcodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    if ([self.merchantQrcode length]) {
        //头像，right detail，修改accessory图标
        NSString *path = [NSString stringWithFormat:@"%@/%@?imageView2/1/w/300/h/300", QINIUURL, self.merchantQrcode];
        [self.qrcodeImageView sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:nil];
        self.noticeLabel.hidden = NO;
    }else{
        //主动生成商家Qrcode
        [self prepareQiniuToken];
        self.qrcodeImageView.afterClickImageView = ^(id sender) {
            self.qrcodeImage = [GenerateQrcode createNonInterpolatedUIImageFormCIImage:[GenerateQrcode createQRForString:self.merchant] withSize:500.0f];
            //先展示
            self.noticeLabel.hidden = NO;
            self.qrcodeImageView.image = self.qrcodeImage;
            
            //上传
            ActionQiniu *action = [[ActionQiniu alloc] init];
            action.afterQiniuUpload = ^(NSString *path) {
                self.merchantQrcode = path;
                //更新商家资料二维码
                ActionMMaterial *action = [[ActionMMaterial alloc] init];
                action.afterModifyQrcode = ^() {
//                    self.qrcodeImageView.image = self.qrcodeImage;
                };
                [action doModifyQrcode:path merchant:self.merchant];

            };
            [action doQiniuUploadImage:self.qrcodeImage token:self.uploadToken path:self.path];
        };
    }
}

//获取7牛上传token，做好准备
- (void)prepareQiniuToken {
    ActionMMaterial *action = [[ActionMMaterial alloc] init];
    action.afterQueryUploadToken = ^(NSDictionary *result) {
        self.uploadToken = [result objectForKey:@"tok"];
        self.path = [result objectForKey:@"path"];
    };
    [action doQueryUploadToken:self.merchant ofResource:@"m_qrcode"];
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
