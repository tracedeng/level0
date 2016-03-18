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
#import "UIImage+FixOrientation.h"
#import "UIColor+Extension.h"


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
    self.title = @"商家二维码";
    
    //修改导航
//    self.navigationController.navigationBar.shadowImage = nil;
//    UIImage *image = [UIImage imageNamed:@"icon-info"];
//    [self.navigationController.navigationBar setBackgroundImage:image
//                                                  forBarMetrics:UIBarMetricsCompact];
//    

    if ([self.merchantQrcode length]) {
        //头像，right detail，修改accessory图标
        NSString *path = [NSString stringWithFormat:@"%@/%@?imageView2/1/w/480/h/480", QINIUURL, self.merchantQrcode];
        [self.qrcodeImageView sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:nil];
        self.noticeLabel.hidden = NO;
    }else{
        //主动生成商家Qrcode
    }
        [self prepareQiniuToken];
        self.qrcodeImageView.afterClickImageView = ^(id sender) {
            NSString *qrcodeValue = [NSString stringWithFormat:@"{\"mid\":\"%@\"}", self.merchant];
            self.qrcodeImage = [GenerateQrcode createQRImage:[GenerateQrcode createWithString:qrcodeValue qrColor:[UIColor blackColor] bgColor:[UIColor whiteColor] size:CGSizeMake(480, 480)] logoImage:[UIImage createRoundedRectImage:self.logo size:CGSizeMake(320, 320)]];
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
            //测试关闭上传
            [action doQiniuUploadImage:self.qrcodeImage token:self.uploadToken path:self.path];
        };
//    }
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

- (IBAction)regenerateQrcode:(id)sender {
//    [self prepareQiniuToken];
//    if (self.qrcodeImageView.afterClickImageView) {
//        [self.qrcodeImageView performSelector:@selector(afterClickImageView)];
//    }
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

- (void)viewWillAppear:(BOOL)animated{
    
    // Called when the view is about to made visible. Default does nothing
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setTranslucent:FALSE];
    [self.tabBarController.tabBar setHidden:TRUE];
    
//    //去除导航栏下方的横线
//    UIImage *image = [UIImage imageNamed:@"icon-info"];
//    [self.navigationController.navigationBar setBackgroundImage:image
//                                                      forBarMetrics:UIBarMetricsCompact];
//        
//    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    //此方法出现黑条
//    self.navigationController.navigationBar.clipsToBounds=YES;
//    [self.navigationController.navigationBar setBackgroundColor:[UIColor colorWithHex:0x39A3FF]];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithHex:0x39A3FF]];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0,CGRectGetHeight(self.navigationController.navigationBar.bounds),CGRectGetWidth(self.navigationController.navigationBar.bounds),0.5)];
    view.backgroundColor= [UIColor colorWithHex:0x39A3FF];
    view.opaque=YES;
    [self.navigationController.navigationBar addSubview:view];

//
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setTranslucent:TRUE];
    [self.tabBarController.tabBar setHidden:FALSE];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithHex:0x149BFF]];

    
}


@end
