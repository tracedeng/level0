//
//  RoleManager.h
//  Calculus
//
//  Created by tracedeng on 15/12/13.
//  Copyright © 2015年 tracedeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RoleManager : NSObject
+ (NSString *)currentRole;      //当前版本
+ (void)changeCurrentRoleWith:(NSString *)role;     //修改当前版本
@end
