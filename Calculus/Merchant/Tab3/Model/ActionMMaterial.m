//
//  ActionMMaterial.m
//  Calculus
//
//  Created by tracedeng on 15/12/18.
//  Copyright © 2015年 tracedeng. All rights reserved.
//

#import "ActionMMaterial.h"
#import "SKeyManager.h"
#import "Constance.h"

@interface ActionMMaterial ()
@property (nonatomic, retain) NetCommunication *net;
@property (nonatomic, assign) EMMATERIALOPTYPE type;     //商家资料操作类型

@property (nonatomic, retain) NSDictionary *state;  //登录态 {"accout": @"18688982240", "skey": @"_Rjdifjwe7234876sdfD"}
@property (nonatomic, retain) NSString *account;
@property (nonatomic, retain) NSString *skey;
@end


@implementation ActionMMaterial

- (id)init {
    self = [super init];
    if (self) {
        self.state = [SKeyManager getSkey];
        self.account = [self.state objectForKey:@"account"];
        self.skey = [self.state objectForKey:@"skey"];
        self.net = [[NetCommunication alloc] initWithHttpUrl:MERCHANTURL httpMethod:@"post"];
        self.net.delegate = self;
    }
    return self;
}

- (void)doQueryMerchantOfAccount {
    self.type = EQUERYMERCHANT;
    
    NSDictionary *postData = [[NSDictionary alloc] initWithObjectsAndKeys:@"retrieve", @"type", self.account, @"numbers", self.skey, @"session_key", nil];
    
    [self.net requestHttpWithData:postData];

}

- (void)doQueryMerchantOfIdentity:(NSString *)identity {
    self.type = EQUERYMERCHANTOFIDENTITY;
    
    NSDictionary *postData = [[NSDictionary alloc] initWithObjectsAndKeys:@"retrieve", @"type", identity, @"merchant",self.account, @"numbers", self.skey, @"session_key", nil];
    
    [self.net requestHttpWithData:postData];
    
}

- (void)doCreateMerchantOfAccount:(NSString *)name logo:(NSString *)logo {
    self.type = ECREATEMERCHNAT;
    
    NSDictionary *postData = [[NSDictionary alloc] initWithObjectsAndKeys:@"create", @"type", name, @"name", logo, @"logo", self.account, @"numbers", self.skey, @"session_key", nil];
    
    [self.net requestHttpWithData:postData];

}

- (void)doQueryUploadToken:(NSString *)merchant {
    self.type = EQUERYUPLOADTOKEN;
    
#ifdef DEBUG
    NSDictionary *postData = [[NSDictionary alloc] initWithObjectsAndKeys:@"upload_token", @"type", @"m_logo", @"resource", merchant, @"merchant", @"debug", @"debug", self.account, @"numbers", self.skey, @"session_key", nil];
#else
    NSDictionary *postData = [[NSDictionary alloc] initWithObjectsAndKeys:@"upload_token", @"type", @"m_logo", @"resource", merchant, @"merchant", self.account, @"numbers", self.skey, @"session_key", nil];
#endif
    [self.net requestHttpWithData:postData];
}

- (void)doModifyLogo:(NSString *)logo merchant:(NSString *)merchant {
    self.type = EUPDATELOGO;
    
    NSDictionary *postData = [[NSDictionary alloc] initWithObjectsAndKeys:@"update", @"type", logo, @"logo", merchant, @"merchant", self.account, @"numbers", self.skey, @"session_key", nil];
    
    [self.net requestHttpWithData:postData];
}

- (void)doModifyMerchantName:(NSString *)merchantname merchant:(NSString *)merchant{
    self.type = EUPDATEMERCHANTNAME;
    NSDictionary *postData = [[NSDictionary alloc] initWithObjectsAndKeys:@"update", @"type", merchantname, @"name", merchant, @"merchant", self.account, @"numbers",self.skey, @"session_key",  nil];
    
    [self.net requestHttpWithData:postData];
}
- (void)doModifyMerchantEmail:(NSString *)merchantemil merchant:(NSString *)merchant{
    self.type = EUPDATEMERCHANTEMAIL;
    NSDictionary *postData = [[NSDictionary alloc] initWithObjectsAndKeys:@"update", @"type", merchantemil, @"email", merchant, @"merchant", self.account, @"numbers",self.skey, @"session_key",  nil];
    
    [self.net requestHttpWithData:postData];
}
- (void)doModifyMerchantContactNumber:(NSString *)merchantcontactnumber merchant:(NSString *)merchant{
    self.type = EUPDATEMERCHANTCONTACTNUMBER;
    NSDictionary *postData = [[NSDictionary alloc] initWithObjectsAndKeys:@"update", @"type", merchantcontactnumber, @"contact_number", merchant, @"merchant", self.account, @"numbers",self.skey, @"session_key",  nil];
    
    [self.net requestHttpWithData:postData];
}
- (void)doModifyMerchantAddress:(NSString *)merchantaddress merchant:(NSString *)merchant{
    self.type = EUPDATEMERCHANTADDRESS;
    NSDictionary *postData = [[NSDictionary alloc] initWithObjectsAndKeys:@"update", @"type", merchantaddress, @"location", merchant, @"merchant", self.account, @"numbers",self.skey, @"session_key",  nil];
    
    [self.net requestHttpWithData:postData];
}
- (void)doModifyMerchantExchangeRate:(NSString *)exchangerate merchant:(NSString *)merchant{
    self.type = EUPDATEMERCHANTEXCHANTRATE;
    NSDictionary *postData = [[NSDictionary alloc] initWithObjectsAndKeys:@"update", @"type", exchangerate, @"exchange_rate", merchant, @"merchant", self.account, @"numbers",self.skey, @"session_key",  nil];
    
    [self.net requestHttpWithData:postData];
}

#pragma mark -NetCommunication Delegate
//@optional http请求成功返回
- (void)postSuccessResponseWith:(AFHTTPRequestOperation *)requestOperation responseObject:(id)responseObject {
    if (0 == [[responseObject objectForKey:@"errcode"] integerValue]) {
        switch (self.type) {
            case EQUERYMERCHANT:
            {
                NSArray *result = [responseObject objectForKey:@"r"];
//                NSDictionary *material = [result objectAtIndex:0];
                if (self.afterQueryMerchantOfAccount) {
                    NSDictionary *material = [result count] > 0 ? [result objectAtIndex:0] : nil;
                    self.afterQueryMerchantOfAccount(material);
                }
                break;
            }
            case EQUERYMERCHANTOFIDENTITY:
            {
                NSArray *result = [responseObject objectForKey:@"r"];
                //                NSDictionary *material = [result objectAtIndex:0];
                if (self.afterQueryMerchantOfIdentity) {
                    NSDictionary *material = [result count] > 0 ? [result objectAtIndex:0] : nil;
                    self.afterQueryMerchantOfIdentity(material);
                }
                break;
            }
            case ECREATEMERCHNAT:
            {
                NSString *merchant = [responseObject objectForKey:@"r"];
                if (self.afterCreateMerchantOfAccount) {
                    self.afterCreateMerchantOfAccount(merchant);
                }
                break;
            }
            case EQUERYUPLOADTOKEN:
            {
                //更新用户头像，上传文件代理调用uploadSuccessResponseWith
                NSDictionary *result = [responseObject objectForKey:@"r"];
                if (self.afterQueryUploadToken) {
                    self.afterQueryUploadToken(result);
                }
                break;
            }
            case EUPDATELOGO:
            {
//                NSString *result = [responseObject objectForKey:@"r"];
                if (self.afterModifyLogo) {
                    self.afterModifyLogo();
                }
                break;
            }
            case EUPDATEMERCHANTNAME:
            {
                NSDictionary *result = [responseObject objectForKey:@"r"];
                if (self.afterModifyMerchantName) {
                    self.afterModifyMerchantName(result);
                }
                break;
            }
            case EUPDATEMERCHANTEMAIL:
            {
                NSDictionary *result = [responseObject objectForKey:@"r"];
                if (self.afterModifyMerchantEmail) {
                    self.afterModifyMerchantEmail(result);
                }
                break;
            }
            case EUPDATEMERCHANTCONTACTNUMBER:
            {
                NSDictionary *result = [responseObject objectForKey:@"r"];
                if (self.afterModifyMerchantContactNumber) {
                    self.afterModifyMerchantContactNumber(result);
                }
                break;
            }
            case EUPDATEMERCHANTADDRESS:
            {
                NSDictionary *result = [responseObject objectForKey:@"r"];
                if (self.afterModifyMerchantAddress) {
                    self.afterModifyMerchantAddress(result);
                }
                break;
            }
            case EUPDATEMERCHANTEXCHANTRATE:
            {
                NSDictionary *result = [responseObject objectForKey:@"r"];
                if (self.afterModifyMerchantExchangeRate) {
                    self.afterModifyMerchantExchangeRate(result);
                }
                break;
            }
            default:
                break;
        }
    }
}

//@optional http请求失败返回
- (void)postFailResponseWith:(AFHTTPRequestOperation *)requestOperation responseError:(NSError *)responseError {
    DLog(@"%@", [responseError domain]);
    DLog(@"%ld", (long)[responseError code]);
    DLog(@"%@", [responseError localizedDescription]);
}
@end
