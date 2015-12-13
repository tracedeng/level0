//
//  RoleManager.m
//  Calculus
//
//  Created by tracedeng on 15/12/13.
//  Copyright © 2015年 tracedeng. All rights reserved.
//

#import "RoleManager.h"

@interface RoleManager ()
@property (nonatomic, retain) NSString *currentRole;    //当前版本，用户版本－consumer; 商家版本－merchant; 未选择版本－nil
@end


@implementation RoleManager

+ (RoleManager *)shareRoleManager {
    static RoleManager *roleManager = nil;
    static dispatch_once_t predicate;
    
    dispatch_once(&predicate, ^{
        roleManager = [[self alloc] init];
        roleManager.currentRole = [[NSUserDefaults standardUserDefaults] objectForKey:@"role"];
        if (nil == roleManager.currentRole) {
            roleManager.currentRole = @"bootstrap";
        }
    });
    
    return roleManager;
}

+ (NSString *)currentRole {
    return [RoleManager shareRoleManager].currentRole;
}

+ (void)changeCurrentRoleWith:(NSString *)role {
    if (![role isEqualToString:[RoleManager shareRoleManager].currentRole]) {
        if ([role isEqualToString:@"bootstrap"] || [role isEqualToString:@"merchant"] || [role isEqualToString:@"consumer"]) {
            [RoleManager shareRoleManager].currentRole = role;
            [[NSUserDefaults standardUserDefaults] setObject:role forKey:@"role"];
        }
    }
}
@end
