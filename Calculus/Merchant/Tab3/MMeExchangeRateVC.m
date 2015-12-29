//
//  MMeExchangeRateVC.m
//  Calculus
//
//  Created by ben on 15/12/28.
//  Copyright © 2015年 tracedeng. All rights reserved.
//

#import "MMeExchangeRateVC.h"

@interface MMeExchangeRateVC ()
@property (weak, nonatomic) IBOutlet UITextField *exchangeRateTXT;

@end

@implementation MMeExchangeRateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.exchangeRateTXT.text = self.exchangeRate;
    self.exchangeRateTXT.delegate = self;
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
