//
//  DiscountNavigationController.m
//  Calculus
//
//  Created by tracedeng on 15/12/12.
//  Copyright © 2015年 tracedeng. All rights reserved.
//

#import "DiscountNavigationController.h"
#import "DiscountTVC.h"

@interface DiscountNavigationController ()

@end

@implementation DiscountNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Discount" bundle:nil];
    DiscountTVC *discountRoot =[board instantiateViewControllerWithIdentifier:@"DiscountRoot"];
    
    [self pushViewController:discountRoot animated:YES];
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
