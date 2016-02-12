//
//  FullscreenImageVC.m
//  Calculus
//
//  Created by ben on 16/2/12.
//  Copyright © 2016年 tracedeng. All rights reserved.
//

#import "FullscreenImageVC.h"

@interface FullscreenImageVC ()
- (IBAction)fullscreenExit:(UIButton *)sender;

@end

@implementation FullscreenImageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBarHidden=YES;
    [self.tabBarController.tabBar setHidden:YES];
    [UIApplication sharedApplication].statusBarHidden = YES;}

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

- (IBAction)fullscreenExit:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];

}
@end
