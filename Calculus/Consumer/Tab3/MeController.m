//
//  MeController.m
//  Calculus
//
//  Created by tracedeng on 15/12/11.
//  Copyright © 2015年 tracedeng. All rights reserved.
//

#import "MeController.h"
#import "AccountController.h"
#import "ClickableStackView.h"

@interface MeController ()
- (IBAction)touchBackgroundToEditMaterial:(id)sender;

@property (weak, nonatomic) IBOutlet ClickableStackView *consumerBasicMaterial;
@end

@implementation MeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"用户中心";
    self.consumerBasicMaterial.afterClickStackView = ^(id sender) {
        [self performSegueWithIdentifier:@"ConsumerMaterial" sender:self];
    };
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

- (IBAction)touchBackgroundToEditMaterial:(id)sender {
    // 已登录，跳转到资料编辑；未登录，跳转到登录页面
    [self performSegueWithIdentifier:@"ConsumerMaterial" sender:self];
    
//    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Account" bundle:nil];
//    AccountController *accountRoot =[board instantiateViewControllerWithIdentifier:@"AccountRoot"];
//    [self.navigationController pushViewController:accountRoot animated:YES];
}
@end
