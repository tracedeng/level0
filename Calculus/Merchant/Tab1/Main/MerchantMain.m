//
//  MerchantMain.m
//  Calculus
//
//  Created by tracedeng on 15/12/12.
//  Copyright © 2015年 tracedeng. All rights reserved.
//

#import "MerchantMain.h"

@interface MerchantMain ()
- (IBAction)toBootstrap:(id)sender;

@end

@implementation MerchantMain

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

- (IBAction)toBootstrap:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"initWindow" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"gotoBootstrap", @"destine", nil]];
}
@end
