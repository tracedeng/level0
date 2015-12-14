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
#import "GTMBase64.h"

@interface AccountRegisterController()
@property (weak, nonatomic) IBOutlet UITextField *accountTXT;
@property (weak, nonatomic) IBOutlet UITextField *passwordTXT;
@property (weak, nonatomic) IBOutlet UITextField *codeTXT;

- (IBAction)accountRegister:(UIButton *)sender;
- (IBAction)getSMSCode:(UIButton *)sender;
- (IBAction)touchBackgroundToHideKeyboard:(id)sender;
@end

@implementation AccountRegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //    self.accountStack.layer.borderWidth = 1.0f;
    //    self.accountStack.layer.borderColor = [[UIColor redColor] CGColor];
    //    self.accountStack.backgroundColor = [UIColor clearColor];
    
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
    NSString *password_MD5 = [[[[password md5HexDigest] md5HexDigest] stringByAppendingString:phoneNumber] md5HexDigest];
    NSData *passwordData = [password_MD5 dataUsingEncoding:NSUTF8StringEncoding];
    passwordData = [GTMBase64 encodeData:passwordData];
    password_MD5 =[[NSString alloc] initWithData:passwordData encoding:NSUTF8StringEncoding];
    
    ActionAccount *registe = [[ActionAccount alloc] init];
    registe.afterAccountRegister = ^(NSString *result){
        //注册成功后只保存手机号码
        [[NSUserDefaults standardUserDefaults] setObject:phoneNumber forKey:@"account"];
        
        //跳转到登录界面
        [[NSNotificationCenter defaultCenter] postNotificationName:@"initWindow" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"gotoAccount", @"destine", nil]];
//        [self.cookie setObject:phoneNumber forKey:@"user"];
//        [self.cookie setObject:password_MD5 forKey:@"password"];
//        [self.cookie setObject:self.userMode forKey:@"kind"];
//        [self.cookie setObject:result forKey:@"skey"];
        
//        NSHTTPCookie *newcookie = [[NSHTTPCookie alloc] initWithProperties:self.cookie];
//        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:newcookie];
    };
    [registe doAccountRegister:phoneNumber passwordMD5:password_MD5 kind:self.userMode code:code];
    
}

- (IBAction)getSMSCode:(UIButton *)sender {
    [self.accountTXT resignFirstResponder];
    [self.passwordTXT resignFirstResponder];
    [self.codeTXT resignFirstResponder];
    
    NSString *phoneNumber = self.accountTXT.text;
    ActionAccount *code = [[ActionAccount alloc] init];
    code.afterGetSMSCode = ^(NSString *result){
    };
    [code doGetSMSCode:phoneNumber kind:self.userMode];

}
@end
