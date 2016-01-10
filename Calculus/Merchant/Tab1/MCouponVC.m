//
//  MCouponVC.m
//  Calculus
//
//  Created by ben on 16/1/9.
//  Copyright © 2016年 tracedeng. All rights reserved.
//

#import "MCouponVC.h"
#import "ActionVoucher.h"
#import "MMaterialManager.h"

@interface MCouponVC ()
@property (weak, nonatomic) IBOutlet UITextField *couponApplyTXT;
@property (weak, nonatomic) IBOutlet UITextField *consumerIdTXT;
@property (weak, nonatomic) IBOutlet UIProgressView *applyCouponProcessPV;

- (IBAction)couponApplyBtn:(UIButton *)sender;

@end

@implementation MCouponVC


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.material = [MMaterialManager getMaterial];
    
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

-(void)updateProgress{

}

- (IBAction)couponApplyBtn:(UIButton *)sender {
    
    
    
    [self.couponApplyTXT removeFromSuperview];
    [self.consumerIdTXT removeFromSuperview];
    [self.applyCouponProcessPV setProgress:0.1];
    [self updateProgress];
    
    ActionVoucher *action = [[ActionVoucher alloc] init];
    action.afterConfirmVoucher = ^(NSString *message){
        NSString *selectButtonOKTitle = NSLocalizedString(@"确定", nil);
        NSString *applyResultTitle = NSLocalizedString(@"申请结果", nil);
        NSString *applyResultMessage = NSLocalizedString(@"优惠券已经发放，个人中心，优惠券查询", nil);
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:applyResultTitle message:applyResultMessage preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:selectButtonOKTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        }];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
    };
    action.afterConfirmVoucherFailed = ^(NSString *message){
        NSString *selectButtonOKTitle = NSLocalizedString(@"确定", nil);
        NSString *applyResultTitle = NSLocalizedString(@"申请结果", nil);
        NSString *applyResultMessage = NSLocalizedString(@"申请失败了！！！", nil);
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:applyResultTitle message:applyResultMessage preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:selectButtonOKTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        }];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
    };
    
    [action doConfirmVoucher:self.couponApplyTXT.text merchant_identity:[self.material objectForKey:@"id"] consumer_number:self.consumerIdTXT.text];
    
   
}
@end
