//
//  InterchangeController.m
//  Calculus
//
//  Created by tracedeng on 15/12/27.
//  Copyright © 2015年 tracedeng. All rights reserved.
//

#import "InterchangeController.h"
#import "ActionCredit.h"
#import "UIImageView+WebCache.h"
#import "Constance.h"

@interface InterchangeController ()
@property (weak, nonatomic) IBOutlet UIView *sourceCreditView;
@property (weak, nonatomic) IBOutlet UIView *destCreditView;
@property (weak, nonatomic) IBOutlet UIView *feeView;
@property (weak, nonatomic) IBOutlet UILabel *merchantOutCredit;
@property (weak, nonatomic) IBOutlet UIImageView *merchantOutImageView;
@property (weak, nonatomic) IBOutlet UILabel *merchantOutName;
@property (weak, nonatomic) IBOutlet UIImageView *merchantInImageView;
@property (weak, nonatomic) IBOutlet UILabel *merchantInName;
@property (weak, nonatomic) IBOutlet UILabel *merchantInCredit;
@property (weak, nonatomic) IBOutlet UILabel *feeCredit;
@property (weak, nonatomic) IBOutlet UIButton *interchangeButton;

- (IBAction)interchangeAction:(id)sender;
@end

@implementation InterchangeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"积分互换";
    
    // source
    self.sourceCreditView.clipsToBounds = YES;
    self.sourceCreditView.layer.cornerRadius = self.sourceCreditView.frame.size.height / 2.0f;
    self.sourceCreditView.layer.borderWidth = 1.0f;
    self.sourceCreditView.layer.borderColor = [[UIColor yellowColor] CGColor];
    
    self.merchantOutImageView.clipsToBounds = YES;
    self.merchantOutImageView.layer.cornerRadius = self.merchantOutImageView.frame.size.height / 2.0f;
    NSString *path = [NSString stringWithFormat:@"%@/%@?imageView2/1/w/300/h/300", QINIUURL, [self.merchantOut objectForKey:@"logo"]];
    [self.merchantOutImageView sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:nil];
    
    self.merchantOutName.text = [self.merchantOut objectForKey:@"name"];
    self.merchantOutCredit.text = [[self.merchantOut objectForKey:@"quantity"] stringValue];

    // dest
    self.destCreditView.clipsToBounds = YES;
    self.destCreditView.layer.cornerRadius = self.destCreditView.frame.size.width / 2.0f;
    self.destCreditView.layer.borderWidth = 1.0f;
    self.destCreditView.layer.borderColor = [[UIColor yellowColor] CGColor];
    
    self.merchantInImageView.clipsToBounds = YES;
    self.merchantInImageView.layer.cornerRadius = self.merchantInImageView.frame.size.height / 2.0f;
    NSString *path2 = [NSString stringWithFormat:@"%@/%@?imageView2/1/w/300/h/300", QINIUURL, [self.merchantIn objectForKey:@"logo"]];
    [self.merchantInImageView sd_setImageWithURL:[NSURL URLWithString:path2] placeholderImage:nil];

    self.merchantInName.text = [self.merchantIn objectForKey:@"name"];
  
    //fee
    self.feeView.clipsToBounds = YES;
    self.feeView.layer.cornerRadius = self.feeView.frame.size.width / 2.0f;
    self.feeView.layer.borderWidth = 1.0f;
    self.feeView.layer.borderColor = [[UIColor yellowColor] CGColor];
    
    //button
    self.interchangeButton.layer.cornerRadius = 4.0f;
    
    ActionCredit *action = [[ActionCredit alloc] init];
    action.afterCreditInterchange = ^(NSInteger quantity, NSInteger fee) {
        self.merchantInCredit.text = [NSString stringWithFormat:@"%ld", quantity];
        self.feeCredit.text = [NSString stringWithFormat:@"%ld", fee];
        self.interchangeButton.enabled = YES;
    };
    [action doCreditInterchange:[self.merchantOut objectForKey:@"cIdentity"] from_merchant:[self.merchantOut objectForKey:@"mIdentity"] quantity:[[self.merchantOut objectForKey:@"quantity"] integerValue] to_merchant:[self.merchantIn objectForKey:@"identity"] exec_exchange:NO];
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

- (IBAction)interchangeAction:(id)sender {
    ActionCredit *action = [[ActionCredit alloc] init];
    action.afterCreditInterchange = ^(NSInteger quantity, NSInteger fee) {
        NSString *notice = [NSString stringWithFormat:@"%@(%@) => %@(%@)", [self.merchantOut objectForKey:@"name"], [[self.merchantOut objectForKey:@"quantity"] stringValue], [self.merchantIn objectForKey:@"name"], self.merchantInCredit.text];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"兑换成功" message:notice preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    };
    [action doCreditInterchange:[self.merchantOut objectForKey:@"cIdentity"] from_merchant:[self.merchantOut objectForKey:@"mIdentity"] quantity:[[self.merchantOut objectForKey:@"quantity"] integerValue] to_merchant:[self.merchantIn objectForKey:@"identity"] exec_exchange:YES];
}
@end
