//
//  ScanMerchantController.m
//  Calculus
//
//  Created by tracedeng on 15/12/20.
//  Copyright © 2015年 tracedeng. All rights reserved.
//

#import "ScanMerchantController.h"
#import "ApplyCreditTVC.h"

@interface ScanMerchantController ()
@property (weak, nonatomic) IBOutlet UITextField *moneyField;
@property (weak, nonatomic) IBOutlet UITextField *merchantField;
- (IBAction)MerchantQrcode:(id)sender;
- (IBAction)ConsumptionQrcode:(id)sender;

@end

@implementation ScanMerchantController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"ApplyCredit"]) {
        if ([segue.destinationViewController isKindOfClass:[ApplyCreditTVC class]]) {
            ApplyCreditTVC *destination = (ApplyCreditTVC *)segue.destinationViewController;
            destination.merchant = self.merchantField.text;
            destination.money = [self.moneyField.text integerValue];
        }
    }
}


- (IBAction)MerchantQrcode:(id)sender {
    [self performSegueWithIdentifier:@"ApplyCredit" sender:self];
}

- (IBAction)ConsumptionQrcode:(id)sender {
    [self performSegueWithIdentifier:@"ApplyCredit" sender:self];
}

@end
