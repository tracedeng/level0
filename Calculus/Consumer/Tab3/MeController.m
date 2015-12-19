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
#import "MaterialManager.h"
#import "UIImageView+WebCache.h"
#import "MaterialTVC.h"
#import "Constance.h"

@interface MeController ()
@property (nonatomic, retain) NSMutableDictionary *material;

- (IBAction)touchBackgroundToEditMaterial:(id)sender;

@property (weak, nonatomic) IBOutlet ClickableStackView *consumerBasicMaterial;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@end

@implementation MeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"用户中心";
    
    self.consumerBasicMaterial.afterClickStackView = ^(id sender) {
        [self performSegueWithIdentifier:@"ConsumerMaterial" sender:self];
    };
    
    self.material = [NSMutableDictionary dictionaryWithDictionary:[MaterialManager getMaterial]];
    
//    圆角
    self.avatarImageView.clipsToBounds = YES;
    self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.size.height / 2.0;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setMaterial:(NSMutableDictionary *)material {
    if (material) {
        _material = material;
        self.nicknameLabel.text = [material objectForKey:@"ni"];
        self.locationLabel.text = [material objectForKey:@"lo"];
        
        NSString *path = [NSString stringWithFormat:@"%@/%@?imageView2/1/w/200/h/200", QINIUURL, [material objectForKey:@"ava"]];
//        [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:path]];
//        NSString *path = [NSString stringWithFormat:@"%@/%@", QINIUURL, [material objectForKey:@"ava"]];
        [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"avatar-placeholder"]];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"ConsumerMaterial"]) {
        if ([segue.destinationViewController isKindOfClass:[MaterialTVC class]]) {
            MaterialTVC *destination = (MaterialTVC *)segue.destinationViewController;
            destination.material = self.material;
        }
    }
}

- (IBAction)unwindMeUpdateMaterial:(UIStoryboardSegue *)segue {
    if ([segue.sourceViewController isKindOfClass:[MaterialTVC class]]) {
        MaterialTVC *source = (MaterialTVC *)segue.sourceViewController;
        if (source.updateMaterialTypeMask & MATERIALTYPEAVATAR) {
            //同时更新头像
            NSString *path = [NSString stringWithFormat:@"%@/%@?imageView2/1/w/200/h/200", QINIUURL, [source.material objectForKey:@"ava"]];
            [self.material setObject:[source.material objectForKey:@"ava"] forKey:@"ava"];
            [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:path]];
        }
    }
}

- (IBAction)touchBackgroundToEditMaterial:(id)sender {
    // 跳转到资料编辑
    [self performSegueWithIdentifier:@"ConsumerMaterial" sender:self];
    
//    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Account" bundle:nil];
//    AccountController *accountRoot =[board instantiateViewControllerWithIdentifier:@"AccountRoot"];
//    [self.navigationController pushViewController:accountRoot animated:YES];
}
@end
