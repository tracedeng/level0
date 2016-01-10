//
//  MActivityCreateTVC.m
//  Calculus
//
//  Created by ben on 16/1/4.
//  Copyright © 2016年 tracedeng. All rights reserved.
//

#import "MActivityCreateTVC.h"
#import "MActivityExpireVC.h"
#import "MerchantActivityTVC.h"
#import "ImageListCVC.h"
#import "ActionMActivity.h"
#import "ActionQiniu.h"
#import "UIImageView+WebCache.h"
#import "Constance.h"

// 填写完所有资料时才可发布活动，
// bit0-poster，bit1-标题，bit2-活动介绍，bit3-需要积分量，bit4-有效期，bit5-编辑状态
#define CANSUBMITMASK 0x1F
#define CANUPDATEMASK 0x3F

@interface MActivityCreateTVC ()
@property (nonatomic, assign) NSInteger canSubmitMask;
@property (nonatomic, assign) BOOL bEditState;

@property (nonatomic, retain) NSString *uploadToken;
@property (nonatomic, retain) NSString *path;
@property (nonatomic, retain) NSString *prepath;

@property (weak, nonatomic) IBOutlet UIImageView *posterImageView;
@property (weak, nonatomic) IBOutlet UITextField *atittleTXT;
@property (weak, nonatomic) IBOutlet UITextField *acreditTXT;
@property (weak, nonatomic) IBOutlet UITextView *adetailsTXT;
@property (weak, nonatomic) IBOutlet UITextField *aexpireTXT;
@property (weak, nonatomic) IBOutlet UILabel *adetailsTXTPlaceHolder;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *submitButton;

- (IBAction)submitActivity:(id)sender;
@end

@implementation MActivityCreateTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // poster圆角
    self.path = @"default";
    self.posterImageView.clipsToBounds = YES;
    self.posterImageView.layer.cornerRadius = self.posterImageView.frame.size.height / 2.0;
//    NSDate *currentDate = [NSDate date];//获取当前时间，日期
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
//    self.aexpire_time = [dateFormatter stringFromDate:currentDate];
//    self.aexpireTXT.text = [dateFormatter stringFromDate:currentDate];
    
    if (self.bUpdateActivity) {
        // 展示活动内容
        self.submitButton.enabled = YES;
        self.submitButton.title = @"编辑";
        
        self.atittleTXT.text = [self.activityInfo objectForKey:@"t"];
        self.acreditTXT.text = [NSString stringWithFormat:@"%@",[self.activityInfo objectForKey:@"cr"] ];
        self.adetailsTXTPlaceHolder.text = @"";
        self.adetailsTXT.text = [self.activityInfo objectForKey:@"in"];
        self.aexpireTXT.text = [self.activityInfo objectForKey:@"et"];
        self.path = [NSString stringWithFormat:@"%@/%@?imageView2/1/w/300/h/300", QINIUURL, [self.activityInfo objectForKey:@"po"]];
        [self.posterImageView sd_setImageWithURL:[NSURL URLWithString:self.path] placeholderImage:[UIImage imageNamed:@"icon-alipay"]];
        [self toggleEnable:NO];
    }
}

- (void)toggleEnable:(BOOL)enable {
    self.atittleTXT.enabled = enable;
    self.acreditTXT.enabled = enable;
    self.aexpireTXT.enabled = enable;
    self.adetailsTXT.editable = enable;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//获取7牛上传token，做好准备
- (void)prepareQiniuToken {
    ActionMActivity *action = [[ActionMActivity alloc] init];
    action.afterQueryUploadToken = ^(NSDictionary *result) {
        self.uploadToken = [result objectForKey:@"tok"];
        self.prepath = [result objectForKey:@"path"];
    };
    [action doQueryUploadToken:@"dummy"];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //TODO 判断各种按键是否正常
    if (string.length == 0){
        if (textField.text.length == 1) {
            if (textField == self.atittleTXT) {
                self.canSubmitMask &= 0xfd;
            }else if (textField == self.acreditTXT){
                self.canSubmitMask &= 0xf7;
            }
        }
        if (self.bUpdateActivity) {
            self.canSubmitMask |= 0x20;
        }
        return YES;     //支持已经输满长度按退格键删除
    }
    
    if (textField == self.atittleTXT) {
        if (textField.text.length > 15) {
            return NO;
        }
        self.canSubmitMask |= 0x2;
    }else if (textField == self.acreditTXT){
        if (textField.text.length > 15) {
            return NO;
        }
        self.canSubmitMask |= 0x8;
    }else if (textField == self.aexpireTXT) {
        self.canSubmitMask |= 0x10;
    }
    
    if (self.bUpdateActivity) {
        self.canSubmitMask |= 0x20;
    }
    
    return YES;
}

// 实现UITextView的placeholder
//- (void)textViewDidBeginEditing:(UITextView *)textView {
//    self.adetailsTXTPlaceHolder.text = @"";
//}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length == 0) {
        self.adetailsTXTPlaceHolder.text = @"请输入活动详细描述";
        self.canSubmitMask &= 0xfb;
//        [textView resignFirstResponder];
    }else{
        self.adetailsTXTPlaceHolder.text = @"";
        self.canSubmitMask |= 0x4;
    }
    
    if (self.bUpdateActivity) {
        self.canSubmitMask |= 0x20;
    }
}

- (void)setCanSubmitMask:(NSInteger)canSubmitMask {
    _canSubmitMask = canSubmitMask;
    if ((_canSubmitMask & CANSUBMITMASK) == CANSUBMITMASK) {
        self.submitButton.enabled = YES;
        if (self.bUpdateActivity) {
            if ((_canSubmitMask & CANUPDATEMASK) != CANUPDATEMASK) {
                self.submitButton.enabled = NO;
            }
        }
    }else{
        self.submitButton.enabled = NO;
    }
}

- (IBAction)submitActivity:(id)sender {
    if (self.bUpdateActivity) {
        if (self.canSubmitMask & 0x20) {
            // 编辑完成更新
            [self updateActivity];
        }else{
            // 变成编辑状态
            self.bEditState = YES;
            [self toggleEnable:YES];
            self.submitButton.enabled = NO;
            self.submitButton.title = @"发布";
            self.canSubmitMask = CANSUBMITMASK;
        }
    }else{
        [self createActivity];
    }
}

- (void)createActivity {
    ActionMActivity *action = [[ActionMActivity alloc] init];
    action.afterAddMerchantActivity = ^(NSString *activity){
        // 购买成功
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"发布活动成功" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSDictionary *newActivity = [NSDictionary dictionaryWithObjectsAndKeys:self.atittleTXT.text, @"t", self.adetailsTXT.text, @"in", self.acreditTXT.text, @"cr", self.path, @"po", self.aexpireTXT.text, @"et", activity, @"id", "update", @"mode", nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshNewActivity" object:nil userInfo:newActivity];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    };
    action.afterAddMerchantActivityFailed = ^(NSString *message) {
        // TODO...
    };
    [action doAddMerchantActivity:self.atittleTXT.text introduce:self.adetailsTXT.text credit:self.acreditTXT.text poster:self.path expire_time:self.aexpireTXT.text];
}

- (void)updateActivity {
    NSString *activity = [self.activityInfo objectForKey:@"id"];
    ActionMActivity *action = [[ActionMActivity alloc] init];
    action.afterUpdateMerchantActivity = ^(){
        // 更新活动成功
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"更新活动成功" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSDictionary *newActivity = [NSDictionary dictionaryWithObjectsAndKeys:self.atittleTXT.text, @"t", self.adetailsTXT.text, @"in", self.acreditTXT.text, @"cr", self.path, @"po", self.aexpireTXT.text, @"et", activity, @"id", @"update", @"mode", nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshNewActivity" object:nil userInfo:newActivity];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    };
    action.afterUpdateMerchantActivityFailed = ^(NSString *message) {
        // TODO...
    };
    [action doUpdateMerchantActivity:activity title:self.atittleTXT.text introduce:self.adetailsTXT.text credit:self.acreditTXT.text poster:self.path expire_time:self.aexpireTXT.text];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    // Configure the cell...
    if (indexPath.section == 0) {
        if (0 == indexPath.row) {
            //活动海报
            NSString *path = [NSString stringWithFormat:@"%@/%@?imageView2/1/w/300/h/300", QINIUURL, self.path];
            [self.posterImageView sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"icon-alipay"]];
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0.0f;
    switch (indexPath.row) {
        case 0:
            height = 100.0f;
            break;
        case 1:
            height = 44.0f;
            break;
        case 2:
            height = 120.0f;
            break;
        case 3:
            height = 44.0f;
            break;
        case 4:
            height = 44.0f;
            break;
        default:
            break;
    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.bUpdateActivity && !self.bEditState)  {
        // 点击编辑按钮之前，不支持修改图片
        return;
    }
    if (0 == indexPath.section) {
        if (0 == indexPath.row) {
            // 商家logo
            UIStoryboard *board = [UIStoryboard storyboardWithName:@"Album" bundle:[NSBundle mainBundle]];
            ImageListCVC *album = [board instantiateInitialViewController];
            album.bMultiChecked = NO;
            album.checkableCount = 1;
            // 先准备token
            [self prepareQiniuToken];
            [self.navigationController pushViewController:album animated:YES];
        }
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
//    if ([segue.identifier isEqualToString:@"COneAward"]) {
//        if ([segue.destinationViewController isKindOfClass:[COneAwardTVC class]]) {
//            COneAwardTVC *destination = (COneAwardTVC *)segue.destinationViewController;
//            destination.numbers = [[self.creditList objectAtIndex:self.checkedRow] objectForKey:@"nu"];
//            destination.nickname = [[self.creditList objectAtIndex:self.checkedRow] objectForKey:@"ni"];
//        }
//    }
//}
//
//- (IBAction)unwindUpdateExpire:(UIStoryboardSegue *)segue {
//    if([segue.sourceViewController isKindOfClass:[MActivityExpireVC class]]){
//        MActivityExpireVC *activitytvc = (MActivityExpireVC *)segue.sourceViewController;
//        
//        self.aexpire_time = activitytvc.aexpire;
//        self.aexpireTXT.text = activitytvc.aexpire;
//    }
//}

// poster 海报
- (IBAction)unwindUpdateMaterial:(UIStoryboardSegue *)segue {
    if ([segue.sourceViewController isKindOfClass:[ImageListCVC class]]) {
        ImageListCVC *imageList = (ImageListCVC *)segue.sourceViewController;
        //保存已选择的头像图片
        NSDictionary *photo = [imageList.currentCheckedImages objectAtIndex:0];
        ActionQiniu *action = [[ActionQiniu alloc] init];
        action.afterQiniuUpload = ^(NSString *path) {
            self.canSubmitMask |= 0x1;
            if (self.bUpdateActivity) {
                self.canSubmitMask |= 0x20;
            }
            self.path = path;
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        };
        [action doQiniuUpload:photo token:self.uploadToken path:self.prepath];
    }
}
@end
