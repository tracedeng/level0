//
//  MAwardApplyCell.m
//  Calculus
//
//  Created by tracedeng on 15/12/22.
//  Copyright © 2015年 tracedeng. All rights reserved.
//

#import "MAwardApplyCell.h"
#import "ClickableImageView.h"
#import "UIImageView+WebCache.h"
#import "ActionMCredit.h"
#import "Constance.h"

@interface MAwardApplyCell ()
@property (nonatomic, retain) NSString *identity;   //积分ID
@property (weak, nonatomic) IBOutlet ClickableImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (weak, nonatomic) IBOutlet UILabel *applyDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UIButton *refuseButton;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;

- (IBAction)refuseApplyAction:(id)sender;
- (IBAction)confirmApplyAction:(id)sender;
@end

@implementation MAwardApplyCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setAwardInfo:(NSDictionary *)awardInfo {
    self.nicknameLabel.text = [awardInfo objectForKey:@"ni"];
    self.applyDateLabel.text = [awardInfo objectForKey:@"ct"];
    self.moneyLabel.text = [[awardInfo objectForKey:@"sums"] stringValue];
    self.identity = [awardInfo objectForKey:@"id"];
    
    //    圆角
    self.avatarImageView.clipsToBounds = YES;
    self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.size.height / 2.0;
    
    NSString *path = [NSString stringWithFormat:@"%@/%@?imageView2/1/w/200/h/200", QINIUURL, [awardInfo objectForKey:@"ava"]];
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"avatar-placeholder"]];

}

- (IBAction)refuseApplyAction:(id)sender {
    UIAlertController *denyAlert = [UIAlertController alertControllerWithTitle:@"拒绝" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [denyAlert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [denyAlert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        ActionMCredit *refuseAction = [[ActionMCredit alloc] init];
        NSIndexPath *indexPath = [self.tableView indexPathForCell:self];
        refuseAction.afterRefuseApplyCredit = ^() {
            if (self.afterRefuseAction) {
                self.afterRefuseAction(YES, indexPath);
            }
        };
        refuseAction.afterRefuseApplyCreditFailed = ^(NSString *message) {
            if (self.afterRefuseAction) {
                self.afterRefuseAction(NO, indexPath);
            };
        };
        NSString *reason = denyAlert.textFields.firstObject.text;
        [refuseAction doRefuseApplyCredit:self.identity reason:reason];

    }]];
    [denyAlert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"拒绝理由";
    }];
    [(UITableViewController *)(self.tableView.dataSource) presentViewController:denyAlert animated:YES completion:nil];
}

- (IBAction)confirmApplyAction:(id)sender {
    ActionMCredit *action = [[ActionMCredit alloc] init];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:self];
    action.afterConfirmApplyCredit = ^() {
        if (self.afterConfirmAction) {
            self.afterConfirmAction(YES, indexPath);
        }
    };
    action.afterConfirmApplyCreditFailed = ^(NSString *message) {
        if (self.afterConfirmAction) {
            self.afterConfirmAction(NO, indexPath);
        };
    };
    [action doConfirmApplyCredit:self.identity sums:[self.moneyLabel.text integerValue]];
}
@end
