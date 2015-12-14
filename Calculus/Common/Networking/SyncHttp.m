//
//  SyncHttp.m
//  Calculus
//
//  Created by tracedeng on 15/12/14.
//  Copyright © 2015年 tracedeng. All rights reserved.
//

#import "SyncHttp.h"
#import "Constance.h"

@implementation SyncHttp

+ (NSString *)syncPost:(NSString *)url data:(NSDictionary *)data {
    //创建请求
    NSLog(@"%@", data);
    
    // 因为tornado不支持jsonserialize
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    for (NSString *key in data) {
        [dataArray addObject:[NSString stringWithFormat:@"%@=%@", key, data[key]]];
    }
    NSString *jsonString = [dataArray componentsJoinedByString:@"&"];
    NSData * postData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    
//    TODO... urlsession 同步
//    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
//    NSURLSessionDataTask *task = [session dataTaskWithRequest:request];
    
    //连接服务器
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:nil];
    NSLog(@"%@", responseJson);
    
    //  请求成功，返回结果，TODO 以后可参考异步接口封装
    if (1 == [[responseJson objectForKey:@"c"] integerValue]) {
        return [responseJson objectForKey:@"r"];
    }
    
    return nil;
}
@end
