//
//  DiscountIntroduceController.m
//  Calculus
//
//  Created by tracedeng on 16/1/5.
//  Copyright © 2016年 tracedeng. All rights reserved.
//

#import "DiscountIntroduceController.h"
#import "BuyDiscountController.h"

@interface DiscountIntroduceController ()

@end

@implementation DiscountIntroduceController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = [self.discountInfo objectForKey:@"t"];
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
    if ([segue.identifier isEqualToString:@"BuyDiscount"]) {
        if ([segue.destinationViewController isKindOfClass:[BuyDiscountController class]]) {
            BuyDiscountController *destination = (BuyDiscountController *)segue.destinationViewController;
            destination.merchant = [self.discountInfo objectForKey:@"mid"];
            destination.discountInfo = self.discountInfo;
        }
    }
}


@end
