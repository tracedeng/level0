//
//  AccountResetPassword.m
//  Calculus
//
//  Created by ben on 15/12/14.
//  Copyright © 2015年 tracedeng. All rights reserved.
//

#import "AccountResetPassword.h"
#import "ActionAccount.h"
#import "NSString+Md5.h"
#import "UIColor+Extension.h"
#import "GTMBase64.h"
#import "JRMessageView.h"

#define SCREEN_W ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_H ([UIScreen mainScreen].bounds.size.height)


@interface AccountResetPassword()
@property (weak, nonatomic) IBOutlet UITextField *accountTXT;
@property (weak, nonatomic) IBOutlet UITextField *passwordTXT;
@property (weak, nonatomic) IBOutlet UITextField *codeTXT;

@property (weak, nonatomic) IBOutlet UIView *accountView;
@property (weak, nonatomic) IBOutlet UIView *smsView;
@property (weak, nonatomic) IBOutlet UIView *passwordView;
@property (weak, nonatomic) IBOutlet UIButton *resetButton;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (nonatomic, strong) JRMessageView *message;
@property (nonatomic, strong) JRMessageView *networkMessage;


- (IBAction)getSMSCode:(UIButton *)sender;
- (IBAction)accountResetPassword:(UIButton *)sender;

@end
@implementation AccountResetPassword


- (void)viewDidLoad {
    [super viewDidLoad];
    self.accountTXT.delegate = self;
    
    self.accountView.layer.cornerRadius = 4.0f;
    self.smsView.layer.cornerRadius = 4.0f;
    self.passwordView.layer.cornerRadius = 4.0f;
    self.resetButton.layer.cornerRadius = 4.0f;
    
    self.logoImageView.layer.cornerRadius = self.logoImageView.frame.size.width / 2.0f;
//    self.logoImageView.layer.borderWidth = 1.0f;
//    self.logoImageView.layer.borderColor = [[UIColor colorWithHex:0xDC1915] CGColor];
    self.logoImageView.clipsToBounds = YES;
//    self.logoImageView.layer.cornerRadius = 4.0f;
    
    self.message = [[JRMessageView alloc] initWithTitle:@"手机号或验证码错误"
                                               subTitle:@""
                                               iconName:@"icon-info-white"
                                            messageType:JRMessageViewTypeCustom
                                        messagePosition:JRMessagePositionTop
                                                superVC:self.navigationController
                                               duration:1];
    
    self.networkMessage = [[JRMessageView alloc] initWithTitle:@"网络连接失败"
                                                      subTitle:@""
                                                      iconName:@"icon-info-white"
                                                   messageType:JRMessageViewTypeCustom
                                               messagePosition:JRMessagePositionTop
                                                       superVC:self.navigationController
                                                      duration:1];
    
   
    
    

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (string.length == 0) return YES;     //支持已经输满长度按退格键删除
    if (textField == self.accountTXT) {
        //检查手机号输入，只能输入11个字符
        if (textField.text.length > 10) {
            return NO;
        }
    }else if (textField == self.passwordTXT){
        // TODO 密码的最长位数
        if (textField.text.length > 15) {
            return NO;
        }
    }else if(textField == self.codeTXT){
        // TODO 密码的最长位数
        if (textField.text.length > 5) {
            return NO;
        }
    }
    
    return YES;
}



- (IBAction)getSMSCode:(UIButton *)sender {
    [self.accountTXT resignFirstResponder];
    [self.passwordTXT resignFirstResponder];
    [self.codeTXT resignFirstResponder];
    
    NSString *phoneNumber = self.accountTXT.text;
    ActionAccount *code = [[ActionAccount alloc] init];
    code.afterGetSMSCode = ^(NSString *result){
#ifdef DEBUG
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"测试验证码" message:result preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:alert completion:nil];
        }]];
        [self presentViewController:alert animated:YES completion:nil];
#else
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"验证码已下发，请查看短信" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:alert completion:nil];
        }]];
        [self presentViewController:alert animated:YES completion:nil];
        
#endif
    };
    [code doGetSMSCode:phoneNumber];

}

- (IBAction)accountResetPassword:(UIButton *)sender {
    
    [self.accountTXT resignFirstResponder];
    [self.passwordTXT resignFirstResponder];
    [self.codeTXT resignFirstResponder];
    
    NSString *phoneNumber = self.accountTXT.text;
    NSString *password = self.passwordTXT.text;
    NSString *code = self.codeTXT.text;
    
    ActionAccount *resetpassword = [[ActionAccount alloc] init];
    resetpassword.afterAccountResetPassword = ^(NSString *result){
        
        //注册成功后只保存手机号码
        [[NSUserDefaults standardUserDefaults] setObject:phoneNumber forKey:@"account"];

        //跳转到登录界面
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    };
    resetpassword.afterAccountResetPasswordFailed = ^(NSString *message) {
        //错误提示
        //TODO message 赋值无效
        
        
        //        self.message.subTitle = message;
        [self.message changeSubtitle:message];
        if (self.message.isShow) {
            //            [self.message hidedMessageView];
        } else {
            [self.message showMessageView];
        }
        
    };
    resetpassword.afterAccountResetPasswordFailedNetConnect = ^(NSString *message) {
        //错误提示
        if (self.networkMessage.isShow) {
            [self.networkMessage hidedMessageView];
        } else {
            [self.networkMessage showMessageView];
        }
    };
    

    [resetpassword doAccountResetPassword:phoneNumber password:password code:code];
    
    
}
@end
