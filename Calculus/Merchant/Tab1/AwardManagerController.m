//
//  AwardManagerController.m
//  Calculus
//
//  Created by tracedeng on 15/12/18.
//  Copyright © 2015年 tracedeng. All rights reserved.
//

#import "AwardManagerController.h"
#import "RoleManager.h"

@interface AwardManagerController ()
@property (weak, nonatomic) IBOutlet UIImageView *noCreditListImageView;

@end

@implementation AwardManagerController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toggleAwardMerchantView:) name:@"toggleAwardMerchantView" object:nil];
    self.noCreditListImageView.hidden = YES;

    self.title = @"积分";
}

// 显示积分列表或者无积分列表缺省view
- (void)toggleAwardMerchantView:(NSNotification *)notification {
    NSString *award = [[notification userInfo] objectForKey:@"award"];
    if ([award isEqualToString:@"award"]) {
        self.noCreditListImageView.hidden = YES;
    }else{
        self.noCreditListImageView.hidden = NO;
    }
    
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
