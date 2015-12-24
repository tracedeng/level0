//
//  RoleManager.m
//  Calculus
//
//  currentRole = {"18688982240": "merchant", "18688982241": "consumer", ...}
//  Created by tracedeng on 15/12/13.
//  Copyright © 2015年 tracedeng. All rights reserved.
//

#import "RoleManager.h"
#import "MaterialManager.h"

@interface RoleManager ()
@property (nonatomic, retain) NSMutableDictionary *currentRole;    //当前版本，用户版本－consumer; 商家版本－merchant; 未选择版本－nil

@end


@implementation RoleManager

+ (RoleManager *)shareRoleManager {
    static RoleManager *roleManager = nil;
    static dispatch_once_t predicate;
    
    dispatch_once(&predicate, ^{
        roleManager = [[self alloc] init];
        NSData *data = [[NSUserDefaults standardUserDefaults] valueForKey:@"role"];
        roleManager.currentRole = [[NSKeyedUnarchiver unarchiveObjectWithData:data] mutableCopy];
        if (!roleManager.currentRole) {
            roleManager.currentRole = [[NSMutableDictionary alloc] init];
        }
    });
    
    return roleManager;
}

+ (NSString *)currentRole {
    NSString *numbers = [NSString stringWithFormat:@"%@", [[MaterialManager getMaterial] objectForKey:@"nu"]];
    NSString *role = [[RoleManager shareRoleManager].currentRole objectForKey:numbers];

    return role ? role : @"bootstrap";
}

+ (void)changeCurrentRoleWith:(NSString *)role {
    NSString *numbers = [NSString stringWithFormat:@"%@", [[MaterialManager getMaterial] objectForKey:@"nu"]];
    NSString *lastRole = [[RoleManager shareRoleManager].currentRole objectForKey:numbers];
    if (![role isEqualToString:lastRole]) {
        if ([role isEqualToString:@"bootstrap"] || [role isEqualToString:@"merchant"] || [role isEqualToString:@"consumer"]) {
            [[RoleManager shareRoleManager].currentRole setObject:role forKey:numbers];
            [[NSUserDefaults standardUserDefaults] setValue:[NSKeyedArchiver archivedDataWithRootObject:[RoleManager shareRoleManager].currentRole] forKey:@"role"];
        }
    }
}

@end
