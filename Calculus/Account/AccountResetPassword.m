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
#import <SMS_SDK/SMSSDK.h>


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
@property (weak, nonatomic) IBOutlet UIButton *smsResButton;
@property (nonatomic, strong) JRMessageView *SMSMessage;


- (IBAction)getSMSCode:(UIButton *)sender;
- (IBAction)accountResetPassword:(UIButton *)sender;

@end
@implementation AccountResetPassword

//目前仅支持中国大陆地区手机号码
NSString* zone = @"86";
//测试阶段保留原有验证码方式
BOOL isMob = TRUE;


NSTimer *res_timer;
int res_second;
int res_totalsecond;


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
    self.SMSMessage = [[JRMessageView alloc] initWithTitle:@"验证码错误"
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

- (IBAction)touchBackgroundToHideKeyboard:(id)sender {
    [self.accountTXT resignFirstResponder];
    [self.passwordTXT resignFirstResponder];
    [self.codeTXT resignFirstResponder];
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


    /*
     *采用Mob短信验证，将后台短信验证改到前端短信验证
     */
    if (isMob) {
        NSString* rule1 = @"^0{0,1}(13[0-9]|15[3-9]|15[0-2]|18[0-9]|17[5-8]|14[0-9]|170|171)[0-9]{8}$";
        NSPredicate* pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",rule1];
        
        if ([pred evaluateWithObject:phoneNumber]) {
            
            self.smsResButton.enabled = FALSE;
            [self startWithSecond:30];
            
            [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:phoneNumber
                                           zone:zone
                               customIdentifier:nil
                                         result:^(NSError *error)
             {
                 
                 if (!error) {

                     UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"验证码已下发，请查看短信" message:nil preferredStyle:UIAlertControllerStyleAlert];
                     [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                         [self dismissViewControllerAnimated:alert completion:nil];
                     }]];
                     [self presentViewController:alert animated:YES completion:nil];

                 
                 }else{
                     NSLog(@"验证码发送失败:%@",error);
                     
                 }
                 
             }];
            
            
        }else{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"手机号码格式错误" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [self dismissViewControllerAnimated:alert completion:nil];
            }]];
            [self presentViewController:alert animated:YES completion:nil];
            
        }

    }else{


    
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

}

- (IBAction)accountResetPassword:(UIButton *)sender {
    
    [self.accountTXT resignFirstResponder];
    [self.passwordTXT resignFirstResponder];
    [self.codeTXT resignFirstResponder];
    
    NSString *phoneNumber = self.accountTXT.text;
    NSString *password = self.passwordTXT.text;
    NSString *code = self.codeTXT.text;
    
    if(isMob){
        NSString* rule1 = @"^0{0,1}(13[0-9]|15[3-9]|15[0-2]|18[0-9]|17[5-8]|14[0-9]|170|171)[0-9]{8}$";
        NSPredicate* pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",rule1];
        
        if ([pred evaluateWithObject:phoneNumber]) {
            [SMSSDK commitVerificationCode:code phoneNumber:phoneNumber  zone:zone result:^(NSError *error) {
                
                if (!error) {
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
                else
                {
                    if (self.SMSMessage.isShow) {
                        //                        [self.SMSMessage hidedMessageView];
                    } else {
                        [self.SMSMessage showMessageView];
                    }                }
            }];

            
        }else{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"手机号码格式错误" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [self dismissViewControllerAnimated:alert completion:nil];
            }]];
            [self presentViewController:alert animated:YES completion:nil];
        }
        
    }else{
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
}

/*
 *发送验证码定时器
 */
-(void)startWithSecond:(int)totalSecond
{
    
    res_second = totalSecond;
    
    res_timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerStart:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:res_timer forMode:NSDefaultRunLoopMode];
}

-(void)timerStart:(NSTimer *)theTimer {
    if (res_second == 1)
    {
        [self stop];
    }
    else
    {
        res_second--;
        NSString *title = [NSString stringWithFormat:@"%d秒",res_second];
        [self.smsResButton setTitle:title forState:UIControlStateNormal];
    }
}


- (void)stop{
    if (res_timer) {
        if ([res_timer respondsToSelector:@selector(isValid)])
        {
            if ([res_timer isValid])
            {
                [res_timer invalidate];
                res_second = res_totalsecond;
                self.smsResButton.enabled = TRUE;
                [self.smsResButton setTitle:@"重新获取" forState:UIControlStateNormal];
                
            }
        }
    }
}
@end
