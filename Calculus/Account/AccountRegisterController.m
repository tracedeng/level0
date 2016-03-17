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
#import "JRMessageView.h"

#define SCREEN_W ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_H ([UIScreen mainScreen].bounds.size.height)

@interface AccountRegisterController()
@property (weak, nonatomic) IBOutlet UITextField *accountTXT;
@property (weak, nonatomic) IBOutlet UITextField *passwordTXT;
@property (weak, nonatomic) IBOutlet UITextField *codeTXT;

@property (weak, nonatomic) IBOutlet UIView *accountView;
@property (weak, nonatomic) IBOutlet UIView *smsView;
@property (weak, nonatomic) IBOutlet UIView *passwordView;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (nonatomic, strong) JRMessageView *messageregister;


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
//    self.logoImageView.layer.cornerRadius = 4.0f;

    self.messageregister = [[JRMessageView alloc] initWithTitle:@"注册账号失败"
                                               subTitle:@""
                                               iconName:@"icon-info-white"
                                            messageType:JRMessageViewTypeCustom
                                        messagePosition:JRMessagePositionTop
                                                superVC:self.navigationController
                                               duration:1];
    
    
    
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
    registe.afterAccountRegisterFailed = ^(NSString *message) {
        //错误提示
        //TODO message 赋值无效
        
        
        //        self.message.subTitle = message;
        [self.messageregister changeSubtitle:message];
        if (self.messageregister.isShow) {
            //            [self.message hidedMessageView];
        } else {
            [self.messageregister showMessageView];
        }
        
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
@end
