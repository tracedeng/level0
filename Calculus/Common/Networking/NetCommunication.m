//
//  NetCommunication.m
//  xiaobao
//
//  Created by tracedeng on 14/11/11.
//  Copyright (c) 2014年 zizbi  智彼. All rights reserved.
//

#import "NetCommunication.h"

@implementation NetCommunication

- (id)initWithHttpUrl:(NSString *)url httpMethod:(NSString *)method {
    self = [super init];
    if (self) {
        self.url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//        self.url = [url stringByAddingPercentEncodingWithAllowedCharacters:NSUTF8StringEncoding];
        self.method = method;
    }
    return self;
}

- (void)requestHttpWithData:(NSDictionary *)data {
    NSLog(@"%@", data);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    if ([self.method isEqualToString:@"get"]) {
        [manager GET:self.url parameters:data
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 //call代理get请求成功
                 NSLog(@"http get request success");
                 if ([self.delegate respondsToSelector:@selector(getSuccessResponseWith:responseObject:)]) {
                     [self.delegate getSuccessResponseWith:operation responseObject:responseObject];
                 }
             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 //call代理get请求失败
                 NSLog(@"http get request failed");
                 if ([self.delegate respondsToSelector:@selector(getFailResponseWith:responseError:)]) {
                     [self.delegate getFailResponseWith:operation responseError:error];
                 }
             }];
    }else if ([self.method isEqual: @"post"]){
        //post请求，json格式传输数据
//        manager.requestSerializer = [AFJSONRequestSerializer serializer]; //tornador不支持
        [manager POST:self.url parameters:data success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //call代理post请求成功
            
            NSLog(@"http post request success");
//            NSLog(@"%@", operation.response);
            NSLog(@"%@", responseObject);
            
            if ([self.delegate respondsToSelector:@selector(postSuccessResponseWith:responseObject:)]) {
                [self.delegate postSuccessResponseWith:operation responseObject:responseObject];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            //call代理post请求失败
            
            
            NSLog(@"%@", operation.request);
            NSLog(@"%@", operation.response);
            NSLog(@"http post request failed%@",error);
            if ([self.delegate respondsToSelector:@selector(postFailResponseWith:responseError:)]) {
                [self.delegate postFailResponseWith:operation responseError:error];
            }
        }];
        
    }
}


//多文件上传http请求
- (void)uploadHttpRequest:(NSDictionary *)data nsdatas:(NSMutableArray *)nsdatas {
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:self.url parameters:data constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for (NSDictionary *nsdata in nsdatas) {
            [formData appendPartWithFileData:[nsdata valueForKey:@"nsdata"] name:[nsdata valueForKey:@"name"] fileName:[nsdata valueForKey:@"fileName"] mimeType:[nsdata valueForKey:@"mimeType"]];
        }
        
    } error:nil];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];

    
    ((AFHTTPResponseSerializer <AFURLResponseSerialization> *)manager.responseSerializer).acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSProgress *progress = nil;
    
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:&progress completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
            if ([self.delegate respondsToSelector:@selector(uploadFailResponseWith:responseError:)]) {
                [self.delegate uploadFailResponseWith:response responseError:error];
            }
        } else {
            NSLog(@"http upload request success");
            NSLog(@"%@\n%@", response, responseObject);
            if ([self.delegate respondsToSelector:@selector(uploadSuccessResponseWith:responseObject:)]) {
                [self.delegate uploadSuccessResponseWith:response responseObject:responseObject];
            }
        }
    }];
    
    [uploadTask resume];
}
@end
