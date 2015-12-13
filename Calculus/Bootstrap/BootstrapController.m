//
//  BootstrapController.m
//  Calculus
//
//  Created by tracedeng on 15/12/12.
//  Copyright © 2015年 tracedeng. All rights reserved.
//

#import "BootstrapController.h"
#import "RoleManager.h"

@interface BootstrapController ()
- (IBAction)EnterAsConsumer:(id)sender;
- (IBAction)EnterAsMerchant:(id)sender;

@end

@implementation BootstrapController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
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

- (IBAction)EnterAsConsumer:(id)sender {
    [RoleManager changeCurrentRoleWith:@"consumer"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"initWindow" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"gotoConsumer", @"destine", nil]];

}

- (IBAction)EnterAsMerchant:(id)sender {
    [RoleManager changeCurrentRoleWith:@"merchant"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"initWindow" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"gotoMerchant", @"destine", nil]];

}
@end
