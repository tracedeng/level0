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
    //    EUPDATENICKNAME,
    //    EUPDATESEX,
    //    EUPDATEINTRODUCE,
    //    EUPDATELOCATION,
    //    EUPDATEREPORT = 20,     //举报
    EMMATERIALOPTYPEMAX,
    EUPDATEMERCHANTNAME,    //商户名称
    EUPDATEMERCHANTEMAIL,    //商户邮箱
    EUPDATEMERCHANTCONTACTNUMBER,    //商户联系电话
    EUPDATEMERCHANTADDRESS,    //商户
};

//- (void)doQueryMaterial;
//- (void)doQueryMaterialWithPhoneNumber:(NSString *)phoneNumber;
//- (void)doBatchQueryMaterialWithPhoneNumber:(NSArray *)phoneNumbers;
//- (void)doModifyNickname:(NSString *)nickname;
//- (void)doModifyIntroduce:(NSString *)introduce;
//- (void)doModifySex:(NSInteger)sex;
- (void)doQueryMerchantOfAccount;
- (void)doQueryMerchantOfIdentity:(NSString *)identity;
- (void)doCreateMerchantOfAccount:(NSString *)name logo:(NSString *)logo;
- (void)doQueryUploadToken:(NSString *)merchant;
- (void)doModifyLogo:(NSString *)logo merchant:(NSString *)merchant;
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
@property (nonatomic, copy) void (^afterModifyMerchantName)(NSDictionary *material);
@property (nonatomic, copy) void (^afterModifyMerchantEmail)(NSDictionary *material);
@property (nonatomic, copy) void (^afterModifyMerchantContactNumber)(NSDictionary *material);
@property (nonatomic, copy) void (^afterModifyMerchantAddress)(NSDictionary *material);

//@property (nonatomic, copy) void (^afterModifyLocation)(NSString *location);


@end
