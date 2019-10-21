//
//  PPNetworkHandle.h
//  PictureWords
//
//  Created by zhao on 2019/6/13.
//  Copyright © 2019 english. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^PPHTTPRequestSuccessBlock)(NSURLSessionDataTask *task,id responeData);
typedef void(^PPHttpRequestFailureBlock)(NSURLSessionDataTask *task,NSError *error);

@interface PPNetworkHandle : NSObject

/**
 get请求
 
 @param urlString 路径
 @param parameter 参数
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)ltp_GET:(NSString *)urlString parameters:(NSDictionary *)parameter success:(PPHTTPRequestSuccessBlock)success failure:(PPHttpRequestFailureBlock)failure;

+ (void)ltp_POST:(NSString *)urlString parameters:(NSDictionary *)parameter success:(PPHTTPRequestSuccessBlock)success failure:(PPHttpRequestFailureBlock)failure;

@end

NS_ASSUME_NONNULL_END
