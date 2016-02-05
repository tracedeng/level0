//
//  ActionMMaterial.h
//  Calculus
//
//  Created by tracedeng on 15/12/18.
//  Copyright © 2015年 tracedeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetCommunication.h"

@interface ActionMMaterial : NSObject <NetCommunicationDelegate>

typedef NS_ENUM(NSInteger, EMMATERIALOPTYPE) {
    EQUERYMERCHANT = 1,      //查询账号是否有管理的商家
    EQUERYMERCHANTOFIDENTITY,      //商家ID查询商家
    ECREATEMERCHNAT,            //新增商家
    EQUERYUPLOADTOKEN,          //获取上传token
    EUPDATELOGO,                //修改商家头像
    EUPDATEQRCODE,                //修改商家二维码
    EUPDATEMERCHANTNAME,    //商户名称
    EUPDATEMERCHANTEMAIL,    //商户邮箱
    EUPDATEMERCHANTCONTACTNUMBER,    //商户联系电话
    EUPDATEMERCHANTADDRESS,    //商户
    EMMATERIALOPTYPEMAX,
};

- (void)doQueryMerchantOfAccount;
- (void)doQueryMerchantOfIdentity:(NSString *)identity;
- (void)doCreateMerchantOfAccount:(NSString *)name logo:(NSString *)logo;
//- (void)doQueryUploadToken:(NSString *)merchant;
- (void)doQueryUploadToken:(NSString *)merchant ofResource:(NSString *)resource;
- (void)doModifyLogo:(NSString *)logo merchant:(NSString *)merchant;
- (void)doModifyQrcode:(NSString *)qrcode merchant:(NSString *)merchant;
- (void)doModifyMerchantName:(NSString *)merchantname merchant:(NSString *)merchant;
- (void)doModifyMerchantEmail:(NSString *)merchantemil merchant:(NSString *)merchant;
- (void)doModifyMerchantContactNumber:(NSString *)merchantcontactnumber merchant:(NSString *)merchant;
- (void)doModifyMerchantAddress:(NSString *)merchantaddress merchant:(NSString *)merchant;

//- (void)doModifyLocation:(NSString *)location;
//- (void)doReport:(NSString *)message;
//
////操作成功后回调Blcok
//@property (nonatomic, copy) void (^afterQueryMaterial)(NSDictionary *material);
//@property (nonatomic, copy) void (^afterBatchQueryMaterial)(NSArray *material);
//@property (nonatomic, copy) void (^afterModifyNickname)(NSString *nickname);
//@property (nonatomic, copy) void (^afterModifyIntroduce)(NSString *introduce);
//@property (nonatomic, copy) void (^afterModifySex)(NSInteger sex);
@property (nonatomic, copy) void (^afterQueryMerchantOfAccount)(NSDictionary *material);
@property (nonatomic, copy) void (^afterQueryMerchantOfIdentity)(NSDictionary *material);
@property (nonatomic, copy) void (^afterCreateMerchantOfAccount)(NSString *merchant);
@property (nonatomic, copy) void (^afterQueryUploadToken)(NSDictionary *token);
@property (nonatomic, copy) void (^afterModifyLogo)();
@property (nonatomic, copy) void (^afterModifyQrcode)();
@property (nonatomic, copy) void (^afterModifyMerchantName)(NSDictionary *material);
@property (nonatomic, copy) void (^afterModifyMerchantEmail)(NSDictionary *material);
@property (nonatomic, copy) void (^afterModifyMerchantContactNumber)(NSDictionary *material);
@property (nonatomic, copy) void (^afterModifyMerchantAddress)(NSDictionary *material);

@property (nonatomic, copy) void (^afterQueryMerchantOfAccountFailed)(NSString *message);
@property (nonatomic, copy) void (^afterQueryMerchantOfIdentityFailed)(NSString *message);
@property (nonatomic, copy) void (^afterCreateMerchantOfAccountFailed)(NSString *message);
@property (nonatomic, copy) void (^afterQueryUploadTokenFailed)(NSString *message);
@property (nonatomic, copy) void (^afterModifyLogoFailed)(NSString *message);
@property (nonatomic, copy) void (^afterModifyQrcodeFailed)(NSString *message);
@property (nonatomic, copy) void (^afterModifyMerchantNameFailed)(NSString *message);
@property (nonatomic, copy) void (^afterModifyMerchantEmailFailed)(NSString *message);
@property (nonatomic, copy) void (^afterModifyMerchantContactNumberFailed)(NSString *message);
@property (nonatomic, copy) void (^afterModifyMerchantAddressFailed)(NSString *message);


@end
