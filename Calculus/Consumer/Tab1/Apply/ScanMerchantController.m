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

#import <AVFoundation/AVFoundation.h>


@interface ScanMerchantController () <AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, retain) UIView *scanBoxView;

@property (nonatomic) BOOL isReading;
@property (strong, nonatomic) CALayer *scanLayer;

@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;

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
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self startScan];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)startScan {
    NSError *error;
    //1.初始化捕捉设备（AVCaptureDevice），类型为AVMediaTypeVideo
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //2.用captureDevice创建输入流
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if (!input) {
        DLog(@"%@", [error localizedDescription]);
        return NO;
    }
    //3.创建媒体数据输出流
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    //4.实例化捕捉会话
    self.captureSession = [[AVCaptureSession alloc] init];
    //4.1.将输入流添加到会话
    [self.captureSession addInput:input];
    //4.2.将媒体输出流添加到会话中
    [self.captureSession addOutput:captureMetadataOutput];
    
    //5.创建串行队列，并加媒体输出流添加到队列当中
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    //5.1.设置代理
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    //5.2.设置输出媒体数据类型为QRCode
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    
    //6.实例化预览图层
    self.videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    //7.设置预览图层填充方式
    [self.videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    //8.设置图层的frame
    [self.videoPreviewLayer setFrame:self.view.layer.bounds];
    //9.将图层添加到预览view的图层上
    [self.view.layer addSublayer:self.videoPreviewLayer];
    
    //10.设置扫描范围
    captureMetadataOutput.rectOfInterest = CGRectMake(0.2f, 0.2f, 0.8f, 0.8f);
    
    //扫描框
    self.scanBoxView = [[UIView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width * 0.2f, self.view.bounds.size.height * 0.2f, self.view.bounds.size.width - self.view.bounds.size.width * 0.4f, self.view.bounds.size.width - self.view.bounds.size.width * 0.4f)];
    self.scanBoxView.layer.borderColor = [UIColor greenColor].CGColor;
    self.scanBoxView.layer.borderWidth = 2.0f;
    [self.view addSubview:self.scanBoxView];
    
    //扫描线
    self.scanLayer = [[CALayer alloc] init];
    self.scanLayer.frame = CGRectMake(0, 0, self.scanBoxView.bounds.size.width, 1);
    self.scanLayer.backgroundColor = [UIColor yellowColor].CGColor;
    [self.scanBoxView.layer addSublayer:self.scanLayer];
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.2f target:self selector:@selector(moveScanLayer:) userInfo:nil repeats:YES];
    [timer fire];
    
    //11.开始扫描
    [_captureSession startRunning];
    
    return YES;
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    //判断是否有数据
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        // 判断回传的数据类型
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            [self performSelectorOnMainThread:@selector(stopReading) withObject:nil waitUntilDone:NO];
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

- (void)moveScanLayer:(NSTimer *)timer
{
    CGRect frame = self.scanLayer.frame;
    if (self.scanBoxView.frame.size.height < self.scanLayer.frame.origin.y + 1.0f) {
        frame.origin.y = -1.0f;
        [UIView animateWithDuration:0.1 animations:^{
            self.scanLayer.frame = frame;
        }];
    }else{
        frame.origin.y += 10;
        if (frame.origin.y > self.scanBoxView.frame.size.height) {
            frame.origin.y = self.scanBoxView.frame.size.height;
        }
        [UIView animateWithDuration:0.2 animations:^{
            self.scanLayer.frame = frame;
        }];
    }
}

-(void)stopReading{
    [self.captureSession stopRunning];
    self.captureSession = nil;
    [self.scanBoxView removeFromSuperview];
    [self.scanLayer removeFromSuperlayer];
    [self.videoPreviewLayer removeFromSuperlayer];
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
