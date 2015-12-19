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
#import "GTMBase64.h"

@interface AccountResetPassword()
@property (weak, nonatomic) IBOutlet UITextField *accountTXT;
@property (weak, nonatomic) IBOutlet UITextField *passwordTXT;
@property (weak, nonatomic) IBOutlet UITextField *codeTXT;
- (IBAction)getSMSCode:(UIButton *)sender;

- (IBAction)accountResetPassword:(UIButton *)sender;

@end
@implementation AccountResetPassword


- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



- (IBAction)getSMSCode:(UIButton *)sender {
    [self.accountTXT resignFirstResponder];
    [self.passwordTXT resignFirstResponder];
    [self.codeTXT resignFirstResponder];
    
    NSString *phoneNumber = self.accountTXT.text;
    ActionAccount *code = [[ActionAccount alloc] init];
    code.afterGetSMSCode = ^(NSString *result){
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

    [resetpassword doAccountResetPassword:phoneNumber password:password code:code];
    
    
}
@end
