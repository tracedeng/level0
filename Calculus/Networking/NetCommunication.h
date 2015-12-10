//
//  NetCommunication.h
//  xiaobao
//
//  Created by tracedeng on 14/11/11.
//  Copyright (c) 2014年 zizbi  智彼. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

@class NetCommunication;
@protocol NetCommunicationDelegate <NSObject>

@optional
//http请求成功返回
- (void)getSuccessResponseWith:(AFHTTPRequestOperation *)requestOperation responseObject:(id)responseObject;
- (void)postSuccessResponseWith:(AFHTTPRequestOperation *)requestOperation responseObject:(id)responseObject;

@optional
//http请求失败返回
- (void)getFailResponseWith:(AFHTTPRequestOperation *)requestOperation responseError:(NSError *)responseError;
- (void)postFailResponseWith:(AFHTTPRequestOperation *)requestOperation responseError:(NSError *)responseError;

@optional
//http上传文件返回
- (void)uploadSuccessResponseWith:(NSURLResponse *)response responseObject:(id)responseObject;
- (void)uploadFailResponseWith:(NSURLResponse *)response responseError:(NSError *)responseError;
@end



////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@interface NetCommunication : NSObject

@property (nonatomic, retain) NSString *url;
@property (nonatomic, retain) NSString *method;
@property (nonatomic, retain) id <NetCommunicationDelegate> delegate;

//构造一个http请求，返回结果委托处理
- (id)initWithHttpUrl:(NSString *)url httpMethod:(NSString *)method;
- (void)requestHttpWithData:(NSDictionary *)data;

- (void)uploadHttpRequest:(NSDictionary *)data nsdatas:(NSMutableArray *)nsdatas;
@end

