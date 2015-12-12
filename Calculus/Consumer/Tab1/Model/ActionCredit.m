//
//  ActionCredit.m
//  Calculus
//
//  Created by tracedeng on 15/12/10.
//  Copyright © 2015年 tracedeng. All rights reserved.
//

#import "ActionCredit.h"
#import "Constance.h"

@interface ActionCredit ()
@property (nonatomic, retain) NSDictionary *state;  //登录态
@property (nonatomic, retain) NetCommunication *net;
@property (nonatomic, assign) ECREDITOPTYPE type;     //用户资料操作类型
@end

@implementation ActionCredit

- (id)init {
    self = [super init];
    if (self) {
        self.net = [[NetCommunication alloc] initWithHttpUrl:CREDITURL httpMethod:@"post"];
        self.net.delegate = self;
    }
    return self;
}


/**
 *  客户查询所有积分
 *
 *  @param nickname <#nickname description#>
 *  type/numbers/session_key
 */
- (void)doConsumerQueryAllCredit {
    self.type = ECONSUMERQUERYALLCREDIT;
    NSDictionary *postData = [[NSDictionary alloc] initWithObjectsAndKeys:@"credit_list", @"type", @"18688982240", @"numbers", @"", @"session_key", nil];
    NSLog(@"%@", postData);
    [self.net requestHttpWithData:postData];
}


#pragma mark -NetCommunication Delegate

//@optional http请求成功返回
- (void)postSuccessResponseWith:(AFHTTPRequestOperation *)requestOperation responseObject:(id)responseObject {
    NSInteger errorCode = [[responseObject objectForKey:@"e"] integerValue];
    if (1 == errorCode) {
        switch (self.type) {
            case ECONSUMERQUERYALLCREDIT:
            {
                NSString *location = [responseObject objectForKey:@"location"];
                if (self.afterConsumerQueryAllCredit) {
                    self.afterConsumerQueryAllCredit(location);
                }
                break;
            }
            default:
                break;
        }
    }else{
        switch (self.type) {
            case ECONSUMERQUERYALLCREDIT:
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
