//
//  MMeController.m
//  Calculus
//
//  Created by tracedeng on 15/12/12.
//  Copyright © 2015年 tracedeng. All rights reserved.
//

#import "MMeController.h"

@interface MMeController ()
- (IBAction)EditMerchantMaterial:(id)sender;

@end

@implementation MMeController

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

- (IBAction)EditMerchantMaterial:(id)sender {
    [self performSegueWithIdentifier:@"MerchantMaterial" sender:self];
}
@end
