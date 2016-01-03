//
//  MActivityNavigationController.m
//  Calculus
//
//  Created by tracedeng on 15/12/31.
//  Copyright © 2015年 tracedeng. All rights reserved.
//

#import "MActivityNavigationController.h"
#import "MActivityTVC.h"

@interface MActivityNavigationController ()

@end

@implementation MActivityNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"MActivity" bundle:nil];
    MActivityTVC *activityRoot =[board instantiateViewControllerWithIdentifier:@"MActivityRoot"];
    
    [self pushViewController:activityRoot animated:YES];
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
