//
//  MyAwardController.m
//  Calculus
//
//  Created by tracedeng on 15/12/18.
//  Copyright © 2015年 tracedeng. All rights reserved.
//

#import "MyAwardController.h"
#import "RoleManager.h"

@interface MyAwardController ()

@property (weak, nonatomic) IBOutlet UIView *creditListView;
@property (weak, nonatomic) IBOutlet UIView *noCreditListView;

@end

@implementation MyAwardController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toggleAwardView:) name:@"toggleAwardView" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 显示积分列表或者无积分列表缺省view
- (void)toggleAwardView:(NSNotification *)notification {
    NSString *award = [[notification userInfo] objectForKey:@"award"];
    if ([award isEqualToString:@"award"]) {
        self.creditListView.hidden = NO;
        self.noCreditListView.hidden = YES;
    }else{
        self.creditListView.hidden = YES;
        self.noCreditListView.hidden = NO;
    }
    
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
