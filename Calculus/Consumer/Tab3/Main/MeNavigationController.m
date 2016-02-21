//
//  MeNavigationController.m
//  Calculus
//
//  Created by tracedeng on 15/12/11.
//  Copyright © 2015年 tracedeng. All rights reserved.
//

#import "MeNavigationController.h"
#import "MeController.h"

@interface MeNavigationController ()

@end

@implementation MeNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
    MeController *meRoot =[board instantiateViewControllerWithIdentifier:@"MeRoot"];
    
    [self pushViewController:meRoot animated:YES];
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
