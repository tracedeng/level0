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
#import "UIColor+Extension.h"


@interface MAwardApplyCell ()
@property (nonatomic, retain) NSString *identity;   //积分ID
@property (weak, nonatomic) IBOutlet ClickableImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (weak, nonatomic) IBOutlet UILabel *applyDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UIButton *refuseButton;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet UIView *cellBackgroundView;

- (IBAction)refuseApplyAction:(id)sender;
- (IBAction)confirmApplyAction:(id)sender;
@end

@implementation MAwardApplyCell

- (void)awakeFromNib {
    // Initialization code
}

//- (void)setFrame:(CGRect)frame{
//    frame.size.height += 50;
//    [super setFrame:frame];
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setAwardInfo:(NSDictionary *)awardInfo {
    self.nicknameLabel.text = [awardInfo objectForKey:@"ni"];
    self.applyDateLabel.text = [[awardInfo objectForKey:@"ct"] substringToIndex:10];
    self.moneyLabel.text = [[awardInfo objectForKey:@"sums"] stringValue];
    self.identity = [awardInfo objectForKey:@"id"];
    
      //    圆角
    self.avatarImageView.clipsToBounds = YES;
    self.avatarImageView.layer.cornerRadius = 4.0f; //self.avatarImageView.frame.size.width / 2.0f;
    self.avatarImageView.layer.borderWidth = 1.0f;
    self.avatarImageView.layer.borderColor = [[UIColor colorWithHex:0xC9C9C9] CGColor];
    
    self.cellBackgroundView.clipsToBounds = YES;
    self.cellBackgroundView.layer.cornerRadius = 4.0f;
//    self.cellBackgroundView.layer.borderWidth = 1.0f;
//    self.cellBackgroundView.layer.borderColor = [[UIColor colorWithHex:0x63B8FF] CGColor];
    
    self.refuseButton.clipsToBounds = YES;
    self.refuseButton.layer.cornerRadius = 2.0f;
    self.refuseButton.layer.borderWidth = 1.0f;
    self.refuseButton.layer.borderColor = [[UIColor colorWithHex:0xDDDDDD] CGColor];
    self.refuseButton.layer.shadowOffset = CGSizeMake(1, 1);
    self.refuseButton.layer.shadowOpacity = 0.8;
    self.refuseButton.layer.shadowColor =[[UIColor colorWithHex:0xDDDDDD] CGColor];

    self.confirmButton.clipsToBounds = YES;
    self.confirmButton.layer.cornerRadius = 2.0f;
    self.confirmButton.layer.borderWidth = 1.0f;
    self.confirmButton.layer.borderColor = [[UIColor colorWithHex:0x149BFF] CGColor];
    self.confirmButton.layer.shadowOffset = CGSizeMake(1, 1);
    self.confirmButton.layer.shadowOpacity = 0.8;
    self.confirmButton.layer.shadowColor =[[UIColor colorWithHex:0x149BFF] CGColor];
    
    
    
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
