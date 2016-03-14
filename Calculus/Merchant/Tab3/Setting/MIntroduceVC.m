//
//  MIntroduceVC.m
//  Calculus
//
//  Created by tracedeng on 16/3/14.
//  Copyright © 2016年 tracedeng. All rights reserved.
//

#import "MIntroduceVC.h"

@interface MIntroduceVC ()
@property (weak, nonatomic) IBOutlet UITextView *introduce;

@end

@implementation MIntroduceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.introduce.contentOffset = CGPointMake(0, 0);
    self.introduce.selectedRange = NSMakeRange(0, 0);
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
