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


@interface AccountController ()
@property (weak, nonatomic) IBOutlet UITextField *accountNumberTField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTField;

@property (weak, nonatomic) IBOutlet UIView *accountView;
@property (weak, nonatomic) IBOutlet UIView *passwordView;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;

- (IBAction)accountLogin:(UIButton *)sender;
- (IBAction)accountRegister:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation AccountController


- (void)viewDidLoad {
    
    
     if ([[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"]) {
        [super viewDidLoad];
    }else{
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
        [self showIntroWithCrossDissolve];
        
    }
     
    // Do any additional setup after loading the view.
        
    self.accountView.layer.cornerRadius = 4.0f;
    self.accountView.clipsToBounds = YES;
    self.passwordView.layer.cornerRadius = 4.0f;
    self.loginButton.layer.cornerRadius = 4.0f;
    self.logoImageView.layer.cornerRadius = self.logoImageView.frame.size.width / 2.0f;
//    self.logoImageView.layer.borderWidth = 1.0f;
//    self.logoImageView.layer.borderColor = [[UIColor colorWithHex:0xDC1915] CGColor];
    self.logoImageView.clipsToBounds = YES;
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
        if (textField.text.length > 15) {
            return NO;
        }
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



- (void)showIntroWithCrossDissolve {
    EAIntroPage *page1 = [EAIntroPage page];
    //    page1.title = @"Hello world";
    //    page1.desc = @"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.";
    page1.bgImage = [UIImage imageNamed:@"kickstart-1"];
    page1.titleImage = [UIImage imageNamed:@"original"];
    
    EAIntroPage *page2 = [EAIntroPage page];
    //    page2.title = @"This is page 2";
    //    page2.desc = @"Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore.";
    page2.bgImage = [UIImage imageNamed:@"kickstart-2"];
    page2.titleImage = [UIImage imageNamed:@"supportcat"];
    
    EAIntroPage *page3 = [EAIntroPage page];
    //    page3.title = @"This is page 3";
    //    page3.desc = @"Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem.";
    page3.bgImage = [UIImage imageNamed:@"kickstart-3"];
    page3.titleImage = [UIImage imageNamed:@"femalecodertocat"];
    
    EAIntroView *intro = [[EAIntroView alloc] initWithFrame:self.view.bounds andPages:@[page1,page2,page3]];
    
    [intro setDelegate:self];
    [intro showInView:self.view animateDuration:0.0];
}

- (void)showBasicIntroWithBg {
    EAIntroPage *page1 = [EAIntroPage page];
    page1.title = @"Hello world";
    page1.desc = @"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.";
    page1.titleImage = [UIImage imageNamed:@"original"];
    
    EAIntroPage *page2 = [EAIntroPage page];
    page2.title = @"This is page 2";
    page2.desc = @"Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore.";
    page2.titleImage = [UIImage imageNamed:@"supportcat"];
    
    EAIntroPage *page3 = [EAIntroPage page];
    page3.title = @"This is page 3";
    page3.desc = @"Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem.";
    page3.titleImage = [UIImage imageNamed:@"femalecodertocat"];
    
    EAIntroView *intro = [[EAIntroView alloc] initWithFrame:self.view.bounds andPages:@[page1,page2,page3]];
    intro.bgImage = [UIImage imageNamed:@"introBg"];
    
    [intro setDelegate:self];
    [intro showInView:self.view animateDuration:0.0];
}

- (void)showBasicIntroWithFixedTitleView {
    EAIntroPage *page1 = [EAIntroPage page];
    page1.title = @"Hello world";
    page1.desc = @"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.";
    
    EAIntroPage *page2 = [EAIntroPage page];
    page2.title = @"This is page 2";
    page2.desc = @"Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore.";
    
    EAIntroPage *page3 = [EAIntroPage page];
    page3.title = @"This is page 3";
    page3.desc = @"Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem.";
    
    EAIntroView *intro = [[EAIntroView alloc] initWithFrame:self.view.bounds andPages:@[page1,page2,page3]];
    UIImageView *titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"original"]];
    intro.titleView = titleView;
    intro.backgroundColor = [UIColor colorWithRed:0.0f green:0.49f blue:0.96f alpha:1.0f]; //iOS7 dark blue
    
    [intro setDelegate:self];
    [intro showInView:self.view animateDuration:0.0];
}

- (void)showCustomIntro {
    EAIntroPage *page1 = [EAIntroPage page];
    page1.title = @"Hello world";
    page1.desc = @"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.";
    page1.titleImage = [UIImage imageNamed:@"original"];
    
    EAIntroPage *page2 = [EAIntroPage page];
    page2.title = @"This is page 2";
    page2.titlePositionY = 180;
    page2.desc = @"Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore.";
    page2.descPositionY = 160;
    page2.titleImage = [UIImage imageNamed:@"supportcat"];
    page2.imgPositionY = 70;
    
    EAIntroPage *page3 = [EAIntroPage page];
    page3.title = @"This is page 3";
    page3.titleFont = [UIFont fontWithName:@"Georgia-BoldItalic" size:20];
    page3.titlePositionY = 220;
    page3.desc = @"Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit.";
    page3.descFont = [UIFont fontWithName:@"Georgia-Italic" size:18];
    page3.descPositionY = 200;
    page3.titleImage = [UIImage imageNamed:@"femalecodertocat"];
    page3.imgPositionY = 100;
    
    EAIntroView *intro = [[EAIntroView alloc] initWithFrame:self.view.bounds andPages:@[page1,page2,page3]];
    intro.backgroundColor = [UIColor colorWithRed:1.0f green:0.58f blue:0.21f alpha:1.0f]; //iOS7 orange
    
    intro.pageControlY = 100.0f;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn setBackgroundImage:[UIImage imageNamed:@"skipButton"] forState:UIControlStateNormal];
    [btn setFrame:CGRectMake((320-230)/2, [UIScreen mainScreen].bounds.size.height - 60, 230, 40)];
    [btn setTitle:@"SKIP NOW" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    intro.skipButton = btn;
    
    [intro setDelegate:self];
    [intro showInView:self.view animateDuration:0.0];
}

- (void)showIntroWithCustomView {
    EAIntroPage *page1 = [EAIntroPage page];
    page1.title = @"Hello world";
    page1.desc = @"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.";
    page1.bgImage = [UIImage imageNamed:@"1"];
    page1.titleImage = [UIImage imageNamed:@"original"];
    
    UIView *viewForPage2 = [[UIView alloc] initWithFrame:self.view.bounds];
    UILabel *labelForPage2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 220, 300, 30)];
    labelForPage2.text = @"Some custom view";
    labelForPage2.font = [UIFont systemFontOfSize:32];
    labelForPage2.textColor = [UIColor whiteColor];
    labelForPage2.backgroundColor = [UIColor clearColor];
    labelForPage2.transform = CGAffineTransformMakeRotation(M_PI_2*3);
    [viewForPage2 addSubview:labelForPage2];
    EAIntroPage *page2 = [EAIntroPage pageWithCustomView:viewForPage2];
    
    EAIntroPage *page3 = [EAIntroPage page];
    page3.title = @"This is page 3";
    page3.desc = @"Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem.";
    page3.bgImage = [UIImage imageNamed:@"3"];
    page3.titleImage = [UIImage imageNamed:@"femalecodertocat"];
    
    EAIntroView *intro = [[EAIntroView alloc] initWithFrame:self.view.bounds andPages:@[page1,page2,page3]];
    
    [intro setDelegate:self];
    [intro showInView:self.view animateDuration:0.0];
}

- (void)showIntroWithSeparatePagesInit {
    EAIntroView *intro = [[EAIntroView alloc] initWithFrame:self.view.bounds];
    
    [intro setDelegate:self];
    [intro showInView:self.view animateDuration:0.0];
    
    EAIntroPage *page1 = [EAIntroPage page];
    page1.title = @"Hello world";
    page1.desc = @"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.";
    page1.bgImage = [UIImage imageNamed:@"1"];
    page1.titleImage = [UIImage imageNamed:@"original"];
    
    EAIntroPage *page2 = [EAIntroPage page];
    page2.title = @"This is page 2";
    page2.desc = @"Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore.";
    page2.bgImage = [UIImage imageNamed:@"2"];
    page2.titleImage = [UIImage imageNamed:@"supportcat"];
    
    EAIntroPage *page3 = [EAIntroPage page];
    page3.title = @"This is page 3";
    page3.desc = @"Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem.";
    page3.bgImage = [UIImage imageNamed:@"3"];
    page3.titleImage = [UIImage imageNamed:@"femalecodertocat"];
    
    [intro setPages:@[page1,page2,page3]];
}

- (void)introDidFinish {
    DLog(@"Intro callback");
}
@end
