//
//  ActionMaterial.m
//  Calculus
//
//  Created by tracedeng on 15/12/16.
//  Copyright © 2015年 tracedeng. All rights reserved.
//

#import "ActionMaterial.h"
#import "SKeyManager.h"
#import "Constance.h"


@interface ActionMaterial ()
@property (nonatomic, retain) NetCommunication *net;
@property (nonatomic, assign) EMATERIALOPTYPE type;     //用户资料操作类型

@property (nonatomic, retain) NSDictionary *state;  //登录态 {"accout": @"18688982240", "skey": @"_Rjdifjwe7234876sdfD"}
@property (nonatomic, retain) NSString *account;
@property (nonatomic, retain) NSString *skey;

@end


@implementation ActionMaterial

- (id)init {
    self = [super init];
    if (self) {
        self.state = [SKeyManager getSkey];
        self.account = [self.state objectForKey:@"account"];
        self.skey = [self.state objectForKey:@"skey"];
        self.net = [[NetCommunication alloc] initWithHttpUrl:CONSUMERURL httpMethod:@"post"];
        self.net.delegate = self;
    }
    return self;
}

- (void)doQueryUploadToken {
    self.type = EQUERYUPLOADTOKEN;
    
#ifdef DEBUG
    NSDictionary *postData = [[NSDictionary alloc] initWithObjectsAndKeys:@"upload_token", @"type", @"c_avatar", @"resource", @"debug", @"debug", self.account, @"numbers", self.skey, @"session_key", nil];
#else
    NSDictionary *postData = [[NSDictionary alloc] initWithObjectsAndKeys:@"upload_token", @"type", @"c_avatar", @"resource", self.account, @"numbers", self.skey, @"session_key", nil];
#endif
    [self.net requestHttpWithData:postData];
}

- (void)doModifyAvatar:(NSString *)avatar {
    self.type = EUPDATEAVATAR;
    
    NSDictionary *postData = [[NSDictionary alloc] initWithObjectsAndKeys:@"update", @"type", avatar, @"avatar", self.account, @"numbers", self.skey, @"session_key", nil];

    [self.net requestHttpWithData:postData];
}
- (void)doModifyGender:(NSString *)gender{
    self.type = EUPDATEGENDER;
    
    NSDictionary *postData = [[NSDictionary alloc] initWithObjectsAndKeys:@"update", @"type", gender, @"gender", self.account, @"numbers", self.skey, @"session_key", nil];
    
    [self.net requestHttpWithData:postData];

}
- (void)doModifyNickName:(NSString *)nickname{
    self.type = EUPDATENICKNAME;
    NSDictionary *postData = [[NSDictionary alloc] initWithObjectsAndKeys:@"update", @"type", nickname, @"nickname", self.account, @"numbers", self.skey, @"session_key", nil];
    [self.net requestHttpWithData:postData];
}

- (void)doModifyLocation:(NSString *)location{
    self.type = EUPDATELOCATION;
    NSDictionary *postData = [[NSDictionary alloc] initWithObjectsAndKeys:@"update", @"type", location, @"location", self.account, @"numbers", self.skey, @"session_key", nil];
    [self.net requestHttpWithData:postData];
}


#pragma mark -NetCommunication Delegate
//@optional http请求成功返回
- (void)postSuccessResponseWith:(AFHTTPRequestOperation *)requestOperation responseObject:(id)responseObject {
    if (1 == [[responseObject objectForKey:@"c"] integerValue]) {
        switch (self.type) {
            case EQUERYUPLOADTOKEN:
            {
                //更新用户头像，上传文件代理调用uploadSuccessResponseWith
                NSDictionary *result = [responseObject objectForKey:@"r"];
                if (self.afterQueryUploadToken) {
                    self.afterQueryUploadToken(result);
                }
                break;
            }
            case EUPDATEAVATAR:
            {
                
                break;
            }
            case EUPDATEGENDER:
            {
                NSDictionary *result = [responseObject objectForKey:@"r"];
                if (self.afterModifyGender) {
                    self.afterModifyGender(result);
                }

                break;
            }
            case EUPDATENICKNAME:
            {
                NSDictionary *result = [responseObject objectForKey:@"r"];
                if (self.afterModifyNickName) {
                    self.afterModifyNickName(result);
                }
            }
            case EUPDATELOCATION:
            {
                NSString *result = [responseObject objectForKey:@"r"];
                if (self.afterModifyLocation) {
                    self.afterModifyLocation(result);
                }
            }
                
                
            default:
                break;
        }
    }else{
        switch (self.type) {
            case EQUERYUPLOADTOKEN:
            {
                //七牛token失败操作
                NSString *message = [responseObject objectForKey:@"m"];
                if (self.afterQueryUploadTokenFailed) {
                    self.afterQueryUploadTokenFailed(message);
                }
                break;
            }
            case EUPDATEAVATAR:
            {
                //修改头像失败操作
                NSString *message = [responseObject objectForKey:@"m"];
                if (self.afterModifyAvatarFailed) {
                    self.afterModifyAvatarFailed(message);
                }
                break;
            }
            case EUPDATENICKNAME:
            {
                //修改昵称失败操作
                NSString *message = [responseObject objectForKey:@"m"];
                if (self.afterModifyGenderFailed) {
                    self.afterModifyGenderFailed(message);
                }
                
                break;
            }
            case EUPDATEGENDER:
            {
                //修改性别失败操作
                NSString *message = [responseObject objectForKey:@"m"];
                if (self.afterModifyNickNameFailed) {
                    self.afterModifyNickNameFailed(message);
                }
                
                break;
            }
            case EUPDATELOCATION:
            {
                //修改区域失败操作
                NSString *message = [responseObject objectForKey:@"m"];
                if (self.afterModifyLocationFailed) {
                    self.afterModifyLocationFailed(message);
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
    switch (self.type) {
        case EQUERYUPLOADTOKEN:
        {
            //七牛token失败操作
            if (self.afterQueryUploadTokenFailed) {
                self.afterQueryUploadTokenFailed([responseError localizedDescription]);
            }
            break;
        }
        case EUPDATEAVATAR:
        {
            //修改头像失败操作
            if (self.afterModifyAvatarFailed) {
                self.afterModifyAvatarFailed([responseError localizedDescription]);
            }
            break;
        }
        case EUPDATENICKNAME:
        {
            //修改昵称失败操作
            if (self.afterModifyGenderFailed) {
                self.afterModifyGenderFailed([responseError localizedDescription]);
            }

            break;
        }
        case EUPDATEGENDER:
        {
            //修改性别失败操作
            if (self.afterModifyNickNameFailed) {
                self.afterModifyNickNameFailed([responseError localizedDescription]);
            }

            break;
        }
        case EUPDATELOCATION:
        {
            //修改区域失败操作
            if (self.afterModifyLocationFailed) {
                self.afterModifyLocationFailed([responseError localizedDescription]);
            }
            
            break;
        }
        default:
            break;
    }

}

@end
