//
//  SyncHttp.h
//  Calculus
//
//  Created by tracedeng on 15/12/14.
//  Copyright © 2015年 tracedeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SyncHttp : NSObject
+ (NSDictionary *)syncPost:(NSString *)url data:(NSDictionary *)data;
@end
