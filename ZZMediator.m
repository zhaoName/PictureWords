//
//  ZZMediator.m
//  Pods-ZZMediator_Example
//
//  Created by zhao on 2019/9/27.
//

#import "ZZMediator.h"

@interface ZZMediator ()

@property (nonatomic, strong) NSMutableDictionary *cacheTargetDict;/**< */

@end

@implementation ZZMediator

+ (instancetype)defaultZZMediator
{
    static ZZMediator *mediator;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mediator = [[ZZMediator alloc] init];
    });
    return mediator;
}

/*
 scheme://target/action?params
 */
- (id)zz_remotePreformActionWithUrl:(NSURL *)url completion:(void (^)(NSDictionary *))completion
{
    // 拼接参数
    NSMutableDictionary *params = [NSMutableDictionary new];
    for (NSString *param in [[url query] componentsSeparatedByString:@"&"]) {
        NSArray *arr = [param componentsSeparatedByString:@"="];
        if (arr.count < 2) continue;
        
        [param setValue:arr.lastObject forKey:arr.firstObject];
    }
    
    // 获取 action
    NSString *actionName = [url.path stringByReplacingOccurrencesOfString:@"/" withString:@""];
    if (![actionName hasPrefix:@"zz_"]) return @0;
    
    id result = [self zz_preformTagert:url.host action:actionName params:params shouldCache:NO];
    if (completion) {
        if (result) {
            completion(@{@"result":result});
        } else {
            completion(nil);
        }
    }
    return result;
}

// 本地组件
- (id)zz_preformTagert:(NSString *)targetName action:(NSString *)actionName params:(NSDictionary *)params shouldCache:(BOOL)shouldCache
{
    if (targetName.length == 0 || actionName.length == 0) return nil;
    
    NSObject *targetObj = self.cacheTargetDict[targetName];
    if (targetObj == nil) {
        Class targetClass = NSClassFromString(targetName);
        targetObj = [[targetClass alloc] init];
    }
    //
    SEL action = NSSelectorFromString(actionName);
    
    // 缓存
    if (shouldCache) {
        self.cacheTargetDict[targetName] = targetObj;
    }
    
    if ([targetObj respondsToSelector:action]) {
        return [self zz_safePerformObject:targetObj action:action params:params];
    }
    else {
        NSLog(@"%@ 中没有 %@ 方法", targetName, actionName);
    }
    return nil;
}

/// 移除缓存的 target
- (void)zz_releaseTargetWithTargetName:(NSString *)targetName
{
    [self.cacheTargetDict removeObjectForKey:targetName];
}

#pragma mark -- private method

- (id)zz_safePerformObject:(NSObject *)target action:(SEL)action params:(NSDictionary *)params
{
    NSMethodSignature *signature = [target methodSignatureForSelector:action];
    if (signature == nil) return nil;
    
    const char *returnType = signature.methodReturnType;
    if (strcmp(@encode(void), returnType) == 0) {
        NSInvocation *invo = [NSInvocation invocationWithMethodSignature:signature];
        [invo setArgument:&params atIndex:2];
        [invo setTarget:target];
        [invo setSelector:action];
        [invo invoke];
        return nil;
    }
    if (strcmp(@encode(BOOL), returnType) == 0) {
        NSInvocation *invo = [NSInvocation invocationWithMethodSignature:signature];
        [invo setArgument:&params atIndex:2];
        [invo setTarget:target];
        [invo setSelector:action];
        [invo invoke];
        BOOL result = NO;
        [invo getReturnValue:&result];
        return @(result);
    }
    if (strcmp(@encode(int), returnType) == 0) {
        NSInvocation *invo = [NSInvocation invocationWithMethodSignature:signature];
        [invo setArgument:&params atIndex:2];
        [invo setTarget:target];
        [invo setSelector:action];
        [invo invoke];
        int result;
        [invo getReturnValue:&result];
        return @(result);
    }
    if (strcmp(@encode(NSInteger), returnType) == 0) {
        NSInvocation *invo = [NSInvocation invocationWithMethodSignature:signature];
        [invo setArgument:&params atIndex:2];
        [invo setTarget:target];
        [invo setSelector:action];
        [invo invoke];
        NSInteger result;
        [invo getReturnValue:&result];
        return @(result);
    }
    if (strcmp(@encode(NSUInteger), returnType) == 0) {
        NSInvocation *invo = [NSInvocation invocationWithMethodSignature:signature];
        [invo setArgument:&params atIndex:2];
        [invo setTarget:target];
        [invo setSelector:action];
        [invo invoke];
        NSUInteger result;
        [invo getReturnValue:&result];
        return @(result);
    }
    if (strcmp(@encode(CGFloat), returnType) == 0) {
        NSInvocation *invo = [NSInvocation invocationWithMethodSignature:signature];
        [invo setArgument:&params atIndex:2];
        [invo setTarget:target];
        [invo setSelector:action];
        [invo invoke];
        CGFloat result;
        [invo getReturnValue:&result];
        return @(result);
    }
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    return [target performSelector:action withObject:params];
#pragma clang diagnostic pop
}

#pragma mark -- getter

- (NSMutableDictionary *)cacheTargetDict
{
    if (!_cacheTargetDict) {
        _cacheTargetDict = [NSMutableDictionary new];
    }
    return _cacheTargetDict;
}


@end
