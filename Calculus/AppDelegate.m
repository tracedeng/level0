//
//  AppDelegate.m
//  Calculus
//
//  Created by tracedeng on 15/11/3.
//  Copyright © 2015年 tracedeng. All rights reserved.
//

#import "AppDelegate.h"
#import "RoleManager.h"
#import "ActionAccount.h"
#import <IQKeyboardManager.h>

@interface AppDelegate ()
@property (nonatomic, retain) UIViewController *consumerRoot;
@property (nonatomic, retain) UIViewController *merchantRoot;
@property (nonatomic, retain) UIViewController *bootstrapRoot;
@property (nonatomic, retain) UIViewController *accountRoot;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // 全局修改状态栏
    UIImage *image = [UIImage imageNamed:@"icon-back"];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:[image resizableImageWithCapInsets:UIEdgeInsetsMake(0, image.size.width, 0, 0)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];

    
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;
    
    self.bootstrapRoot = self.window.rootViewController;
    [self loadBoard];
//    self.window.rootViewController = self.consumerRoot;
//    return YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initRootWindow:) name:@"initWindow" object:nil];
    
    BOOL state = [ActionAccount doWeakLogin];
    if (state) {
        DLog(@"weak login success");
        NSString * role = [RoleManager currentRole];
        DLog(@"role %@", role);
        if ([role isEqualToString:@"consumer"]) {
            self.window.rootViewController = self.consumerRoot;
        }else if ([role isEqualToString:@"merchant"]) {
            self.window.rootViewController = self.merchantRoot;
        }else if ([role isEqualToString:@"bootstrap"]) {
            self.window.rootViewController = self.bootstrapRoot;
        }
    }else{
//        弱登录失败不清除cache，可能没连网络原因
        DLog(@"weak login failed");
        self.window.rootViewController = self.accountRoot;
    }
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)initRootWindow:(NSNotification *)notification {
    NSString *destine = [[notification userInfo] objectForKey:@"destine"];
    if ([destine isEqualToString:@"gotoConsumer"]) {
        self.window.rootViewController = self.consumerRoot;
        [RoleManager changeCurrentRoleWith:@"consumer"];
    }else if ([destine isEqualToString:@"gotoMerchant"]) {
        self.window.rootViewController = self.merchantRoot;
        [RoleManager changeCurrentRoleWith:@"merchant"];
    }else if ([destine isEqualToString:@"gotoBootstrap"]) {
        self.window.rootViewController = self.bootstrapRoot;
    }else if ([destine isEqualToString:@"gotoMerchantAfterCreate"]) {
        //创建商家->切换版本，boostrap停留在创建商家页面，需重置storyboard
        UIStoryboard *bootstrapBoard = [UIStoryboard storyboardWithName:@"Bootstrap" bundle:[NSBundle mainBundle]];
        self.bootstrapRoot = [bootstrapBoard instantiateInitialViewController];

        self.window.rootViewController = self.merchantRoot;
        [RoleManager changeCurrentRoleWith:@"merchant"];
    }else if ([destine isEqualToString:@"gotoAccount"]) {
        //退出，需要重置Storyboard，否则退出后再登录不会执行ViewDidLoad，无法以新登录用户身份登录
        [self loadBoard];
        self.window.rootViewController = self.accountRoot;
    }

}

- (void)loadBoard {
    UIStoryboard *consumerBoard = [UIStoryboard storyboardWithName:@"Consumer" bundle:[NSBundle mainBundle]];
    UIStoryboard *merchantBoard = [UIStoryboard storyboardWithName:@"Merchant" bundle:[NSBundle mainBundle]];
    UIStoryboard *accountBoard = [UIStoryboard storyboardWithName:@"Account" bundle:[NSBundle mainBundle]];
    
    self.consumerRoot = [consumerBoard instantiateInitialViewController];
    self.merchantRoot = [merchantBoard instantiateInitialViewController];
    self.accountRoot = [accountBoard instantiateInitialViewController];
}

@end
