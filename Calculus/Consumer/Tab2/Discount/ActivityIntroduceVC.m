//
//  ActivityIntroduceVC.m
//  Calculus
//
//  Created by tracedeng on 16/3/18.
//  Copyright © 2016年 tracedeng. All rights reserved.
//

#import "ActivityIntroduceVC.h"
#import "ClickableImageView.h"
#import "UIImageView+WebCache.h"
#import "Constance.h"

@interface ActivityIntroduceVC ()
@property (weak, nonatomic) IBOutlet UILabel *headingLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@property (weak, nonatomic) IBOutlet ClickableImageView *poster;
@end

@implementation ActivityIntroduceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.title = self.heading;
    self.title = @"活动介绍";
    
    NSString *path = [NSString stringWithFormat:@"%@/%@?imageView2/1/w/1600/h/900", QINIUURL, self.path];
    [self.poster sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"icon-activity-cache"]];

    self.headingLabel.text = self.heading;
    self.detailLabel.text = self.detail;
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
