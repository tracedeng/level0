//
//  MMeController.m
//  Calculus
//
//  Created by tracedeng on 15/12/12.
//  Copyright © 2015年 tracedeng. All rights reserved.
//

#import "MMeController.h"
#import "MMaterialManager.h"
#import "MMaterialTVC.h"
#import "ClickableStackView.h"
#import "ClickableImageView.h"
#import "UIImageView+WebCache.h"
#import "MMaterialManager.h"
#import "ActionMMaterial.h"
#import "Constance.h"

@interface MMeController ()
@property (nonatomic, retain) NSMutableDictionary *material;

@property (weak, nonatomic) IBOutlet ClickableStackView *merchantBasicMaterial;
@property (weak, nonatomic) IBOutlet ClickableImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

- (IBAction)EditMerchantMaterial:(id)sender;

@end

@implementation MMeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"商家中心";
    
    self.merchantBasicMaterial.afterClickStackView = ^(id sender) {
        [self performSegueWithIdentifier:@"MerchantMaterial" sender:self];
    };
//    奇怪，用户中心不用定义这个回调也可以响应点击事件
    self.logoImageView.afterClickImageView = ^(id sender) {
        [self performSegueWithIdentifier:@"MerchantMaterial" sender:self];
    };
        
    //    圆角
    self.logoImageView.clipsToBounds = YES;
    self.logoImageView.layer.cornerRadius = self.logoImageView.frame.size.height / 2.0;
    
    ActionMMaterial *action = [[ActionMMaterial alloc] init];
    action.afterQueryMerchantOfAccount = ^(NSDictionary *material) {
        if (material) {
            self.nameLabel.text = [material objectForKey:@"n"];
            NSString *path = [NSString stringWithFormat:@"%@/%@?imageView2/1/w/200/h/200", QINIUURL, [material objectForKey:@"logo"]];
            [self.logoImageView sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"avatar-placeholder"]];
            
            //保存
            [MMaterialManager setMaterial:material];
            self.material = [NSMutableDictionary dictionaryWithDictionary:material];
        }
    };
    [action doQueryMerchantOfAccount];
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
    if ([segue.identifier isEqualToString:@"MerchantMaterial"]) {
        if ([segue.destinationViewController isKindOfClass:[MMaterialTVC class]]) {
            MMaterialTVC *destination = (MMaterialTVC *)segue.destinationViewController;
            destination.material = self.material;
        }
    }

}

- (IBAction)unwindMMeUpdateMaterial:(UIStoryboardSegue *)segue {
    if ([segue.sourceViewController isKindOfClass:[MMaterialTVC class]]) {
        MMaterialTVC *source = (MMaterialTVC *)segue.sourceViewController;
        if (source.updateMMaterialTypeMask & MMATERIALTYPELOGO) {
            //同时更新头像
            NSString *path = [NSString stringWithFormat:@"%@/%@?imageView2/1/w/200/h/200", QINIUURL, [source.material objectForKey:@"logo"]];
            [self.material setObject:[source.material objectForKey:@"logo"] forKey:@"logo"];
            [self.logoImageView sd_setImageWithURL:[NSURL URLWithString:path]];
        }
    }
}

- (IBAction)EditMerchantMaterial:(id)sender {
    [self performSegueWithIdentifier:@"MerchantMaterial" sender:self];
}
@end
