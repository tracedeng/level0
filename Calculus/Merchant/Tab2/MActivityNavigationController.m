//
//  MActivityNavigationController.m
//  Calculus
//
<<<<<<< HEAD
//  Created by ben on 16/1/2.
//  Copyright © 2016年 tracedeng. All rights reserved.
=======
//  Created by tracedeng on 15/12/31.
//  Copyright © 2015年 tracedeng. All rights reserved.
>>>>>>> 589c93d5bc4177a3bdf99d925d3f3e35abf2c5c1
//

#import "MActivityNavigationController.h"
#import "MActivityTVC.h"

@interface MActivityNavigationController ()

@end

@implementation MActivityNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
<<<<<<< HEAD
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"MActivity" bundle:nil];
    MActivityNavigationController *activityRoot = [board instantiateViewControllerWithIdentifier:@"MActivityRoot"];
=======
    
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"MActivity" bundle:nil];
    MActivityTVC *activityRoot =[board instantiateViewControllerWithIdentifier:@"MActivityRoot"];
>>>>>>> 589c93d5bc4177a3bdf99d925d3f3e35abf2c5c1
    
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
