//
//  ActionAccount.m
//  Calculus
//
//  Created by tracedeng on 15/12/10.
//  Copyright © 2015年 tracedeng. All rights reserved.
//

#import "ActionAccount.h"
#import "Constance.h"

@interface ActionAccount ()
//@property (nonatomic, retain) NSDictionary *state;  //登录态
@property (nonatomic, retain) NetCommunication *net;
@property (nonatomic, assign) EACCOUNTOPTYPE type;     //用户资料操作类型
@end

@implementation ActionAccount

- (id)init {
    self = [super init];
    if (self) {
        self.net = [[NetCommunication alloc] initWithHttpUrl:CREDITURL httpMethod:@"post"];
        self.net.delegate = self;
    }
    return self;
}


/**
 *  获取短信验证码
 *
 *  @param nickname <#nickname description#>
 *  type/numbers
 */
- (void)doGetSMSCode:(NSString *)numbers kind:(NSString *)kind {
    self.type = EACCOUNTGETSMSCODE;
    NSDictionary *postData = [[NSDictionary alloc] initWithObjectsAndKeys:@"get_sms_code", @"type", numbers, @"numbers", kind, @"kind", nil];
    NSLog(@"%@", postData);
    [self.net requestHttpWithData:postData];
}


#pragma mark -NetCommunication Delegate

//@optional http请求成功返回
- (void)postSuccessResponseWith:(AFHTTPRequestOperation *)requestOperation responseObject:(id)responseObject {
    NSInteger errorCode = [[responseObject objectForKey:@"e"] integerValue];
    if (1 == errorCode) {
        switch (self.type) {
            case EACCOUNTGETSMSCODE:
            {
                NSString *location = [responseObject objectForKey:@"location"];
                if (self.afterGetSMSCode) {
                    self.afterGetSMSCode(location);
                }
                break;
            }
            default:
                break;
        }
    }else{
        switch (self.type) {
            case EACCOUNTGETSMSCODE:
            {
                break;
            }
            default:
                break;
        }
    }
}

//@optional http请求失败返回
- (void)postFailResponseWith:(AFHTTPRequestOperation *)requestOperation responseError:(NSError *)responseError {
    NSLog(@"%@", [responseError domain]);
    NSLog(@"%ld", (long)[responseError code]);
    NSLog(@"%@", [responseError localizedDescription]);
}

@end
