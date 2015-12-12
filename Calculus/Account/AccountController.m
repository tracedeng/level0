//
//  AccountController.m
//  Calculus
//
//  Created by tracedeng on 15/12/11.
//  Copyright © 2015年 tracedeng. All rights reserved.
//

#import "AccountController.h"
#import "ActionAccount.h"

@interface AccountController ()
@property (weak, nonatomic) IBOutlet UITextField *accountNumberTField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTField;
@property (weak, nonatomic) IBOutlet UIStackView *accountStack;
- (IBAction)accountLogin:(UIButton *)sender;


@end

@implementation AccountController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.accountStack.layer.borderWidth = 1.0f;
//    self.accountStack.layer.borderColor = [[UIColor redColor] CGColor];
//    self.accountStack.backgroundColor = [UIColor clearColor];
    self.userMode = @"consumer";
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


/**
 *  隐藏键盘
 *
 *  @param sender 空白
 */
- (IBAction)touchBackgroundToHideKeyboard:(id)sender {
    [self.accountNumberTField resignFirstResponder];
    [self.passwordTField resignFirstResponder];
}



- (IBAction)submitLogin:(UIButton *)sender {
  }


//   检查手机号和验证码等UITextField输入，并且发起验证验证码请求
//   @param textField <#textField description#>
//   @param range     <#range description#>
//   @param string    <#string description#>
//   @return <#return value description#>


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
    
    if (!self.userMode) {
        NSLog(@"EMPTY USER MODE");
        return true;
    }
    if (phoneNumber) {
        if (phoneNumber.length != 11) {
            NSLog(@"EMPTY USER MODE");
            
        }
    }
    else{
        NSLog(@"EMPTY USER MODE");
        return false;
    }
    
    if (!self.userMode) {
        NSLog(@"EMPTY USER MODE");
        return false;
    }
    return true;
}
//
//    点击登录提交
// 
- (IBAction)accountLogin:(UIButton *)sender {
    [self.accountNumberTField resignFirstResponder];
    [self.passwordTField resignFirstResponder];
    
    ActionAccount *login = [[ActionAccount alloc] init];
    login.afterAccountLogin = ^(NSString *location) {
    //TODO 登录成功后保存用户类型、手机号码、密码MD5
    };
    [login doAccountLogin:self.accountNumberTField.text passwordMD5:self.passwordTField.text kind:self.userMode];
    
}
@end
