//
//  QRScanViewController.m
//  QRCodeDemo
//
//  Created by tracedeng on 16/1/15.
//  Copyright © 2016年 tracedeng. All rights reserved.
//

#import "QRScanViewController.h"
#import <Photos/Photos.h>
#import "QRScanToolView.h"

@interface QRScanViewController ()<AVCaptureMetadataOutputObjectsDelegate>

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *angelViews;

/**
 * 提示框
 */
@property (weak, nonatomic) IBOutlet UILabel *tipLable;

/**
 *  工具栏
 */
@property (nonatomic, weak) IBOutlet QRScanToolView *toolView;

/**
 *  扫描框
 */
@property (nonatomic, weak) IBOutlet UIView *scanView;

/**
 *  工具提示框
 */
@property (weak, nonatomic) IBOutlet UILabel *toolTipLabel;

/**
 *  连接输入输出流的管道
 */
@property (nonatomic, strong) AVCaptureSession *session;

/**
 *  用于把输出流现在在界面上的layer
 */
@property(nonatomic,strong) AVCaptureVideoPreviewLayer *layer;

@property (nonatomic, weak) UIView *layerView;

/**
 *  toolView距离下边缘的约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

@property (nonatomic, strong) IBOutlet UIView *animationView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *angleWidth;

@property (nonatomic, strong) AVCaptureDevice *device;

@end

@implementation QRScanViewController

+ (instancetype)scanView{
    QRScanViewController *scanVc = (QRScanViewController *)[[UIStoryboard storyboardWithName:@"TYBQRScan" bundle:nil] instantiateViewControllerWithIdentifier:@"ScanView"];

    
    return scanVc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setDownGesture];
//    [self setTheme];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setTheme];
    self.animationView.frame = CGRectMake(self.angleWidth.constant + 1, self.angleWidth.constant, self.scanView.frame.size.width - (self.angleWidth.constant+1) * 2, 2);
//    [super viewWillAppear:animated];
     self.scanAnimation = YES;
    [self performSelector:@selector(startScan) withObject:nil afterDelay:0];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self endScan];
    _device.torchMode = AVCaptureTorchModeOff;
}

//- (void)dealloc {
//    NSLog(@"dealloc");
//    
//}

#pragma mark -- 设置初始化显示的样式
- (void)setTheme{
    
    if (self.toolViewBgColor) {
         self.toolView.backgroundColor = self.toolViewBgColor;
    }
    if (self.tipsColor) {
        self.tipLable.textColor = self.tipsColor;
        self.toolTipLabel.textColor = self.tipsColor;
    }
    if (self.scanAngelColor) {
        for (UIView *view in _angelViews) {
            view.backgroundColor = self.scanAngelColor;
        }
    }
    if (self.tips) {
        self.tipLable.text = self.tips;
    }
    if(self.toolItems.count){
        self.toolView.items = self.toolItems;
        self.toolView.hidden = NO;
        self.toolTipLabel.hidden = NO;
    }else{
        self.toolView.hidden = YES;
        self.toolTipLabel.hidden = YES;
    }
    self.animationView.backgroundColor = self.animationColor?self.animationColor:[UIColor blueColor];
}


#pragma mark -- 设置手势
- (void)setDownGesture{
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(changeConstraint:)];
    swipe.direction = UISwipeGestureRecognizerDirectionDown;
    
    [self.view addGestureRecognizer:swipe];
    
    
    UISwipeGestureRecognizer *swipe1 = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(changeConstraint:)];
    swipe1.direction = UISwipeGestureRecognizerDirectionUp;
    
    [self.view addGestureRecognizer:swipe1];
}

- (void)changeConstraint:(UISwipeGestureRecognizer *)swipe{
    if (swipe.direction == UISwipeGestureRecognizerDirectionDown) {
        [UIView animateWithDuration:0 animations:^{
            self.bottomConstraint.constant = - self.toolView.bounds.size.height;
            self.toolTipLabel.text = @"向上滑动显示工具栏";
        }];
        
    }else if(swipe.direction == UISwipeGestureRecognizerDirectionUp){
        [UIView animateWithDuration:1 animations:^{
            self.bottomConstraint.constant = 0;
            
            self.toolTipLabel.text = @"向下滑动隐藏工具栏";
        }];
    }
}

#pragma mark -- 设置扫描成功的提示
- (void)systemVibrate
{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

#define SOUNDID  1109
- (void)systemSound
{
    AudioServicesPlaySystemSound(SOUNDID);
}

// 设置提示栏
- (void)setTips:(NSString *)tips {
    _tips = tips;
    self.tipLable.text = tips;
}

// 获取扫描权限
- (BOOL)getCameraPermisson {
    BOOL isAllowed = YES;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusDenied) {
        isAllowed = NO;
    }
    
    return isAllowed;
}

// 开启扫描
- (void)startScan {
    NSLog(@"%s",__func__);
    // 取得权限,开始扫描
    if ([self getCameraPermisson]) {
        // 1 获取设备摄像头对象
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        self.device = device;
        
        // 自动开启灯光
        
            [device lockForConfiguration:nil];
            device.torchMode = AVCaptureTorchModeAuto;
   

        NSError *error = nil;
        // 2 从摄像头获取输入流
        AVCaptureDeviceInput *input  = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
//        self.tipLable.text = @"正在启动准备摄像头，请稍候";
        if (error) {
            NSLog(@"input error:%@",error);
            self.tipLable.text = @"打开摄像头失败";
            return;
        }
        [self.indicator stopAnimating];
//        self.tipLable.text = @"请将方框对准您要扫描的二维码";
        //3 创建输出流,将其显示到屏幕上
        AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc]init];
        [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        
        // 4 设置输入输出管道
        _session = [[AVCaptureSession alloc]init];
        [_session addInput:input];
        if ([device isTorchModeSupported:AVCaptureTorchModeAuto]) {
            AVCaptureOutput *videoOutput = [[AVCaptureVideoDataOutput alloc]init];
            [_session addOutput:videoOutput];
           
        }
        
        [_session addOutput:output];
        // 设置输出流的品质
        [_session setSessionPreset:AVCaptureSessionPresetHigh];
        
        // 设置扫描的数据类型 :二维码(默认)
        output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
        
        // 5 把管道的图像读出来
        _layer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
        _layer.frame = self.view.frame;
        _layer.videoGravity = AVLayerVideoGravityResizeAspectFill;

        UIView *view = [[UIView alloc]initWithFrame:self.view.frame];
        [view.layer addSublayer:_layer];
        [self.view insertSubview:view atIndex:0];
        self.layerView = view;

        // 设置遮罩，非扫描区域模糊
        [self setFilterOnView:view];
//
        if (self.scanAnimation) {
//            [self.scanView addSubview:self.animationView];
            [self startAnimation];
        }else{
            [self stopAnimation];
        }
//
        // 6 启动管道
        [_session startRunning];
    }else {// 提示未取得权限
        self.tipLable.text = @"打开摄像头失败,请在设置中更改权限";
    }
    
}

#pragma mark -- 扫描成功
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    
    // 扫描成功后关闭管道
    if (metadataObjects.count > 0) {
        // 结束扫描
        [self endScan];
            AVMetadataMachineReadableCodeObject *obj = metadataObjects.firstObject;
//            NSLog(@"扫描到的二维码是:%@",obj.stringValue);
        [self.delegate scanView:self endScanWithResult:obj.stringValue];
    }else{
        // 扫描失败
        if ([self.delegate respondsToSelector:@selector(scanViewDidFailed:)]) {
            [self.delegate scanViewDidFailed:self];
        }
    }
}
- (void)endScan {
    _device.torchMode = AVCaptureTorchModeOff;
    [_session stopRunning];
    [_layer removeFromSuperlayer];
    [self.layerView removeFromSuperview];
    [self stopAnimation];
}


#pragma mark -- 开启扫描动画
- (void)startAnimation{
    NSLog(@"%s",__func__);
    self.animationView.hidden = NO;
    NSLog(@"%@",NSStringFromCGRect(self.animationView.frame));
    [UIView animateWithDuration:3 delay:0 options:UIViewAnimationOptionRepeat animations:^{
        self.animationView.frame = CGRectMake(self.angleWidth.constant + 1, self.scanView.frame.size.height - (self.angleWidth.constant+2) * 2, self.scanView.frame.size.width - (self.angleWidth.constant+1) * 2, 2);
        NSLog(@"%@",NSStringFromCGRect(self.animationView.frame));
    } completion:nil];
}

- (void)stopAnimation {
    NSLog(@"%s",__func__);
    self.animationView.hidden = YES;

}

- (void)setFilterOnView:(UIView *)view {
    
    UIColor *filterColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:0.6];
    //
    CGFloat scanAreaTop = self.scanView.frame.origin.y+ self.angleWidth.constant;
    CGFloat scanAreaBottom = self.scanView.frame.origin.y + self.scanView.frame.size.height - self.angleWidth.constant;
    CGFloat scanAreaLeft = self.scanView.frame.origin.x + self.angleWidth.constant;
    CGFloat scanAreaRight = self.scanView.frame.origin.x + self.scanView.frame.size.width - self.angleWidth.constant;
    CGFloat screenWidth = self.view.frame.size.width;
    CGFloat screenHeight = self.view.frame.size.height;
    
    
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, scanAreaTop)];
    topView.backgroundColor = filterColor;
    [self.view insertSubview:topView aboveSubview:view];
    
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, scanAreaBottom, screenWidth, screenHeight-scanAreaBottom)];
    bottomView.backgroundColor = filterColor;
    [self.view insertSubview:bottomView aboveSubview:view];
    
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, scanAreaTop, scanAreaLeft, self.scanView.frame.size.height - self.angleWidth.constant * 2)];
//    NSLog(@"%@",NSStringFromCGRect(leftView.frame));
    leftView.backgroundColor = filterColor;
    [self.view insertSubview:leftView aboveSubview:view];
    
    UIView *rightView = [[UIView alloc]initWithFrame:CGRectMake(scanAreaRight, scanAreaTop, screenWidth-scanAreaRight, self.scanView.frame.size.height- self.angleWidth.constant * 2)];
//    NSLog(@"%@",NSStringFromCGRect(rightView.frame));
    rightView.backgroundColor = filterColor;
    [self.view insertSubview:rightView aboveSubview:view];
}

- (void)toggleTorch {
    if ([_device hasTorch]) {
        if (_device.torchActive) {
            _device.torchMode = AVCaptureTorchModeOff;
        }else {
            _device.torchMode = AVCaptureTorchModeOn;
        }
    }
}

@end

