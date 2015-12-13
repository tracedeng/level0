//
//  AlbumTestController.m
//  Calculus
//
//  Created by tracedeng on 15/12/13.
//  Copyright © 2015年 tracedeng. All rights reserved.
//

#import "AlbumTestController.h"
#import "ImageListCVC.h"

@interface AlbumTestController ()

@end

@implementation AlbumTestController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"ChoosePhoto"]) {
        if([segue.destinationViewController isKindOfClass:[ImageListCVC class]]) {
            ImageListCVC *imageListCVC = (ImageListCVC *)segue.destinationViewController;
            imageListCVC.bMultiChecked = NO;
            imageListCVC.checkedCount = 0;
            imageListCVC.checkableCount = 1;
        }
    }
}


@end
