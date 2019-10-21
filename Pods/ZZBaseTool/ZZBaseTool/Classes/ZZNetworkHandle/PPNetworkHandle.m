//
//  PPNetworkHandle.m
//  PictureWords
//
//  Created by zhao on 2019/6/13.
//  Copyright © 2019 english. All rights reserved.
//

#import "PPNetworkHandle.h"
#import "AFNetworking.h"

@implementation PPNetworkHandle

/**
 * 初始化共用的afn
 */
+ (AFHTTPSessionManager *)ltp_initAFHTTpManager
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 3.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    // 接受数据类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain", @"text/html", nil];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    return manager;
}

+ (void)ltp_POST:(NSString *)urlString parameters:(NSDictionary *)parameter success:(PPHTTPRequestSuccessBlock)success failure:(PPHttpRequestFailureBlock)failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 3.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    // 接受数据类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain", @"text/html", nil];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    
    [manager POST:urlString parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success) success(task, responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failure) failure(task, error);
    }];
}

// get
+ (void)ltp_GET:(NSString *)urlString parameters:(NSDictionary *)parameter success:(PPHTTPRequestSuccessBlock)success failure:(PPHttpRequestFailureBlock)failure
{
    AFHTTPSessionManager *manager = [self ltp_initAFHTTpManager];
    
    [manager GET:urlString parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success) success(task, responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failure) failure(task, error);
    }];
}

@end
