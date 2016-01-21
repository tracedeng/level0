//
//  AccountController.m
//  Calculus
//
//  Created by tracedeng on 15/12/11.
//  Copyright © 2015年 tracedeng. All rights reserved.
//

#import "AccountController.h"
#import "ActionAccount.h"
#import "AccountRegisterController.h"
#import "UIColor+Extension.h"
#import "RoleManager.h"
#import "SKeyManager.h"
#import "MaterialManager.h"
#import "MMaterialManager.h"
#import <IQKeyboardManager/IQKeyboardReturnKeyHandler.h>

@interface AccountController ()
@property (weak, nonatomic) IBOutlet UITextField *accountNumberTField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTField;
//@property (weak, nonatomic) IBOutlet UIStackView *accountStack;

@property (weak, nonatomic) IBOutlet UIView *accountView;
@property (weak, nonatomic) IBOutlet UIView *passwordView;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;

- (IBAction)accountLogin:(UIButton *)sender;
- (IBAction)accountRegister:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@property (nonatomic, strong) IQKeyboardReturnKeyHandler *returnKeyHandler;
@end

@implementation AccountController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.accountView.layer.cornerRadius = 4.0f;
//    self.accountView.clipsToBounds = YES;
    self.passwordView.layer.cornerRadius = 4.0f;
    self.loginButton.layer.cornerRadius = 4.0f;
    self.logoImageView.layer.cornerRadius = self.logoImageView.frame.size.width / 2.0f;
    self.logoImageView.layer.borderWidth = 1.0f;
    self.logoImageView.layer.borderColor = [[UIColor colorWithHex:0xDC1915] CGColor];
    self.logoImageView.clipsToBounds = YES;
    
//    self.returnKeyHandler = [[IQKeyboardReturnKeyHandler alloc] initWithViewController:self];
//    self.returnKeyHandler.lastTextFieldReturnKeyType = UIReturnKeyDone;
//    self.returnKeyHandler.toolbarManageBehaviour = IQAutoToolbarBySubviews;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    // 如果用户cache还存在，帮用户填好
    NSString *account = [[NSUserDefaults standardUserDefaults] objectForKey:@"account"];
    if (account) {
        self.accountNumberTField.text = account;
    }else{
        self.accountNumberTField.text = @"";
    }
    
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
    if (password) {
        // 此处password已经是3次md5后的密码
        self.passwordTField.text = password;
    }else{
        self.passwordTField.text = @"";
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
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
//    NSString *phoneNumber = self.passwordTField.text;
//    NSString *password = self.accountNumberTField.text;

    return true;
}

- (IBAction)accountLogin:(UIButton *)sender {
   
    [self.accountNumberTField resignFirstResponder];
    [self.passwordTField resignFirstResponder];
    
    NSString *phoneNumber = self.accountNumberTField.text;
    NSString *password = self.passwordTField.text;
         
    ActionAccount *login = [[ActionAccount alloc] init];
    login.afterAccountLogin = ^(NSDictionary *material) {
//        登录成功后手机号码、密码MD5存入cache
        [[NSUserDefaults standardUserDefaults] setObject:phoneNumber forKey:@"account"];
        [[NSUserDefaults standardUserDefaults] setObject:password forKey:@"password"];

//        保存skey
        NSString *skey = [material objectForKey:@"sk"];
        [SKeyManager changeSkey:skey ofAccount:phoneNumber];
        [MaterialManager setMaterial:material];
        [MMaterialManager changeMaterialOfKey:@"id" withValue:[material objectForKey:@"mid"]];
        
//        根据用户最近角色判断
        NSString * role = [RoleManager currentRole];
        if ([role isEqualToString:@"consumer"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"initWindow" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"gotoConsumer", @"destine", nil]];
        }else if ([role isEqualToString:@"merchant"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"initWindow" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"gotoMerchant", @"destine", nil]];
        }else if ([role isEqualToString:@"bootstrap"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"initWindow" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"gotoBootstrap", @"destine", nil]];
        }
        
    };
    [login doAccountLogin:phoneNumber password:password];
    
}

- (IBAction)accountRegister:(UIButton *)sender {
    //[self performSegueWithIdentifier:@"accountregister" sender:self]; //这个方法。跳转页面。
}



#pragma mark - Segue Methods
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
//    if([segue.identifier isEqualToString:@"accountregister"]){
//        [segue.destinationViewController setValue:self.userMode forKey:@"userMode"];
//    }
}
@end
