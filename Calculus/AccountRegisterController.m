//
//  AccountRegisterController.m
//  Calculus
//
//  Created by ben on 15/12/13.
//  Copyright © 2015年 tracedeng. All rights reserved.
//

#import "AccountRegisterController.h"
#import "ActionAccount.h"
#import "NSString+Md5.h"
#import "UIColor+Extension.h"
#import "GTMBase64.h"

@interface AccountRegisterController()
@property (weak, nonatomic) IBOutlet UITextField *accountTXT;
@property (weak, nonatomic) IBOutlet UITextField *passwordTXT;
@property (weak, nonatomic) IBOutlet UITextField *codeTXT;

@property (weak, nonatomic) IBOutlet UIView *accountView;
@property (weak, nonatomic) IBOutlet UIView *smsView;
@property (weak, nonatomic) IBOutlet UIView *passwordView;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;

- (IBAction)accountRegister:(UIButton *)sender;
- (IBAction)getSMSCode:(UIButton *)sender;
- (IBAction)touchBackgroundToHideKeyboard:(id)sender;
@end

@implementation AccountRegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.accountTXT.delegate = self;
    
    self.accountView.layer.cornerRadius = 4.0f;
    self.smsView.layer.cornerRadius = 4.0f;
    self.passwordView.layer.cornerRadius = 4.0f;
    self.registerButton.layer.cornerRadius = 4.0f;
    
    self.logoImageView.layer.cornerRadius = self.logoImageView.frame.size.width / 2.0f;
//    self.logoImageView.layer.borderWidth = 1.0f;
//    self.logoImageView.layer.borderColor = [[UIColor colorWithHex:0xDC1915] CGColor];
    self.logoImageView.clipsToBounds = YES;

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



   //隐藏键盘
 
- (IBAction)touchBackgroundToHideKeyboard:(id)sender {
    [self.accountTXT resignFirstResponder];
    [self.passwordTXT resignFirstResponder];
    [self.codeTXT resignFirstResponder];
}

- (IBAction)accountRegister:(UIButton *)sender {
    
    [self.accountTXT resignFirstResponder];
    [self.passwordTXT resignFirstResponder];
    [self.codeTXT resignFirstResponder];
    
    NSString *phoneNumber = self.accountTXT.text;
    NSString *password = self.passwordTXT.text;
    NSString *code = self.codeTXT.text;
//    NSString *password_MD5 = [[[[password md5HexDigest] md5HexDigest] stringByAppendingString:phoneNumber] md5HexDigest];
//    NSData *passwordData = [password_MD5 dataUsingEncoding:NSUTF8StringEncoding];
//    passwordData = [GTMBase64 encodeData:passwordData];
//    password_MD5 =[[NSString alloc] initWithData:passwordData encoding:NSUTF8StringEncoding];
    
    ActionAccount *registe = [[ActionAccount alloc] init];
    registe.afterAccountRegister = ^(NSString *result){
        //注册成功后只保存手机号码
        [[NSUserDefaults standardUserDefaults] setObject:phoneNumber forKey:@"account"];
        
        //跳转到登录界面
        [self.navigationController popToRootViewControllerAnimated:YES];
    };
    [registe doAccountRegister:phoneNumber password:password code:code];
    
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
@end
