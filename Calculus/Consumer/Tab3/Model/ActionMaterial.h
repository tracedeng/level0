//
//  ActionMaterial.h
//  Calculus
//
//  Created by tracedeng on 15/12/16.
//  Copyright © 2015年 tracedeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetCommunication.h"


@interface ActionMaterial : NSObject <NetCommunicationDelegate>

typedef NS_ENUM(NSInteger, EMATERIALOPTYPE) {
    EQUERYUPLOADTOKEN = 1,            //获取7牛token
    EUPDATEAVATAR,                //修改用户资料
//    EUPDATENICKNAME,
    EUPDATEGENDER,
//    EUPDATEINTRODUCE,
//    EUPDATELOCATION,
//    EUPDATEREPORT = 20,     //举报
    EMATERIALOPTYPEMAX,
};

//- (void)doQueryMaterial;
//- (void)doQueryMaterialWithPhoneNumber:(NSString *)phoneNumber;
//- (void)doBatchQueryMaterialWithPhoneNumber:(NSArray *)phoneNumbers;
//- (void)doModifyNickname:(NSString *)nickname;
//- (void)doModifyIntroduce:(NSString *)introduce;
//- (void)doModifySex:(NSInteger)sex;
- (void)doQueryUploadToken;
- (void)doModifyAvatar:(NSString *)avatar;
//- (void)doModifyLocation:(NSString *)location;
//- (void)doReport:(NSString *)message;
- (void)doModifyGender:(NSString *)gender;
//

////操作成功后回调Blcok
//@property (nonatomic, copy) void (^afterQueryMaterial)(NSDictionary *material);
//@property (nonatomic, copy) void (^afterBatchQueryMaterial)(NSArray *material);
//@property (nonatomic, copy) void (^afterModifyNickname)(NSString *nickname);
//@property (nonatomic, copy) void (^afterModifyIntroduce)(NSString *introduce);
//@property (nonatomic, copy) void (^afterModifySex)(NSInteger sex);
@property (nonatomic, copy) void (^afterQueryUploadToken)(NSDictionary *token);
@property (nonatomic, copy) void (^afterModifyAvatar)(NSDictionary *token);
//@property (nonatomic, copy) void (^afterModifyLocation)(NSString *location);
@property (nonatomic, copy) void (^afterModifyGender)(NSDictionary *token);


@end
