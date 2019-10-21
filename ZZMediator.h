//
//  ZZMediator.h
//  Pods-ZZMediator_Example
//
//  Created by zhao on 2019/9/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZZMediator : NSObject

+ (instancetype)defaultZZMediator;

/// 远程调用
- (id)zz_remotePreformActionWithUrl:(NSURL *)url completion:(void(^)(NSDictionary *))completion;

/// 本地组件调用
- (id)zz_preformTagert:(NSString *)targetName action:(NSString *)actionName params:(NSDictionary *)params shouldCache:(BOOL)shouldCache;

/// 清理 target 缓存
- (void)zz_releaseTargetWithTargetName:(NSString *)targetName;

@end

NS_ASSUME_NONNULL_END
