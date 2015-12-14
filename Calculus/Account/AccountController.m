//
//  AccountController.m
//  Calculus
//
//  Created by tracedeng on 15/12/11.
//  Copyright © 2015年 tracedeng. All rights reserved.
//

#import "AccountController.h"
#import "ActionAccount.h"
#import "NSString+Md5.h"
#import "GTMBase64.h"
#import "AccountRegisterController.h"

@interface AccountController ()
@property (weak, nonatomic) IBOutlet UITextField *accountNumberTField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTField;
@property (weak, nonatomic) IBOutlet UIStackView *accountStack;
@property (nonatomic, retain) NSMutableDictionary *cookie;   //登录态


- (IBAction)accountLogin:(UIButton *)sender;
- (IBAction)accountRegister:(UIButton *)sender;


@end

@implementation AccountController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.userMode = @"consumer";
    self.cookie = [[NSMutableDictionary alloc] init];

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

- (IBAction)touchBackgroundToHideKeyboard:(id)sender {
    [self.accountNumberTField resignFirstResponder];
    [self.passwordTField resignFirstResponder];
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (string.length == 0) return YES;     //支持已经输满长度按退格键删除
    if (textField == self.accountNumberTField) {
        //检查手机号输入，只能输入11个字符
        if (textField.text.length > 10) {
            return NO;
        }
    }else if (textField == self.passwordTField){
    // TODO 密码的最长位数
    }
    
    return YES;
}




- (BOOL) verifyInfomation{
    NSString *phoneNumber = self.passwordTField.text;
    NSString *password = self.accountNumberTField.text;

    return true;
}

- (IBAction)accountLogin:(UIButton *)sender {
   
    [self.accountNumberTField resignFirstResponder];
    [self.passwordTField resignFirstResponder];
    NSString *phoneNumber = self.accountNumberTField.text;
    NSString *password = self.passwordTField.text;
    
    NSString *passwordMD5 = [[[[password md5HexDigest] md5HexDigest] stringByAppendingString:phoneNumber] md5HexDigest];
    
    NSData *passwordData = [passwordMD5 dataUsingEncoding:NSUTF8StringEncoding];
    passwordData = [GTMBase64 encodeData:passwordData];
    passwordMD5 =[[NSString alloc] initWithData:passwordData encoding:NSUTF8StringEncoding];
      
    ActionAccount *login = [[ActionAccount alloc] init];
    login.afterAccountLogin = ^(NSString *location) {
        //TODO 登录成功后保存手机号码、密码MD5、SKEY
        [self.cookie setObject:phoneNumber forKey:@"account"];
        [self.cookie setObject:passwordMD5 forKey:@"password"];
        
        NSLog(@"After login do this step");
    };
    [login doAccountLogin:phoneNumber passwordMD5:passwordMD5];
    
}

- (IBAction)accountRegister:(UIButton *)sender {
    //[self performSegueWithIdentifier:@"accountregister" sender:self]; //这个方法。跳转页面。
    ;
}



#pragma mark - Segue Methods
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier compare:@"accountregister"]==NO){
        [segue.destinationViewController setValue:self.userMode forKey:@"userMode"];
    }
}
@end
