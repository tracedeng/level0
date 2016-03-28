//
//  BootstrapController.m
//  Calculus
//
//  Created by tracedeng on 15/12/12.
//  Copyright © 2015年 tracedeng. All rights reserved.
//

#import "BootstrapController.h"
//#import "RoleManager.h"
#import "ActionMMaterial.h"
#import "MMaterialManager.h"

@interface BootstrapController ()
- (IBAction)EnterAsConsumer:(id)sender;
- (IBAction)EnterAsMerchant:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *consumerButton;
@property (weak, nonatomic) IBOutlet UIButton *merchantButton;
@end

@implementation BootstrapController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.consumerButton.layer.cornerRadius = 4.0f;
    self.merchantButton.layer.cornerRadius = 4.0f;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.merchantButton.enabled = TRUE;

    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"initWindow" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"gotoConsumer", @"destine", nil]];

}

- (IBAction)EnterAsMerchant:(id)sender {
    self.merchantButton.enabled = FALSE;
    ActionMMaterial *action = [[ActionMMaterial alloc] init];
    action.afterQueryMerchantOfAccount = ^(NSDictionary *material) {
        if (material) {
            //保存
            [MMaterialManager setMaterial:material];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"initWindow" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"gotoMerchant", @"destine", nil]];
        }else{
            //没有商家，跳转到创建商家页面
            [self performSegueWithIdentifier:@"CreateMerchant" sender:self];
        }
    };
    [action doQueryMerchantOfAccount];

}
@end
