//
//  PPDataManager.m
//  LearnWord
//
//  Created by famin on 2019/4/4.
//  Copyright © 2019年 english. All rights reserved.
//

#import "PPDataManager.h"
#import "LTPLearnWordModel.h"
#import <MJExtension.h>

@implementation DataModel
+ (DataModel *)modelWithDictionary:(NSDictionary *)dictionary
{
    DataModel *model = [[DataModel alloc] init];
    model.keywordChina = [dictionary valueForKey:@"ch_name"];
    model.keywordEnglish = [dictionary valueForKey:@"en_name"];
    model.contentChina = [dictionary valueForKey:@"ch_content"];
    model.contentEnglish = [dictionary valueForKey:@"en_content"];
    model.keywordStyle = [dictionary valueForKey:@"style"];
    model.keywordImageName = [dictionary valueForKey:@"image_name"];
    return model ;
}

- (NSDictionary *)dictionaryWithModel:(DataModel *)model
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setValue:model.keywordChina forKey:@"ch_name"];
    [dictionary setValue:model.keywordEnglish forKey:@"en_name"];
    [dictionary setValue:model.contentChina forKey:@"ch_content"];
    [dictionary setValue:model.contentEnglish forKey:@"en_content"];
    [dictionary setValue:model.keywordStyle forKey:@"style"];
    [dictionary setValue:model.keywordImageName forKey:@"image_name"];
    return dictionary ;
}
@end

@interface PPDataManager ()
@property (nonatomic,strong) NSArray *mainData ;
@property (nonatomic,strong) NSArray *alldaanData ;
@end
@implementation PPDataManager
+ (void)load
{
    [self shareManager];
}
+ (PPDataManager *)shareManager
{
    static PPDataManager *instance = nil ;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[PPDataManager alloc] init];
        }
    });
    return instance ;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.mainData = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"EnglishData.plist" ofType:nil]];
        NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"suoyoudaan.plist" ofType:nil]];;
        self.alldaanData = [dic valueForKey:@"Objects"];
    }
    return self ;
}

- (NSMutableDictionary *)ltp_allCollectionData
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    path = [path stringByAppendingPathComponent:@"colectioned.plist"];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    return dict;
}

- (BOOL)ltp_addCollectionModel:(LTPLearnWordModel *)model
{
    NSMutableDictionary *allDatas = [self ltp_allCollectionData];
    if (allDatas == nil) {
        allDatas = [[NSMutableDictionary alloc] init];
    }
    NSMutableDictionary *dict = allDatas[model.style];
    if (dict == nil) {
        dict = [NSMutableDictionary dictionary];
    }
    [dict setObject:[model mj_keyValues] forKey:model.en_name];
    [allDatas setObject:dict forKey:model.style];
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    path = [path stringByAppendingPathComponent:@"colectioned.plist"];
   
    
    BOOL isSuccess = [allDatas writeToFile:path atomically:YES];
    return isSuccess;
}

- (BOOL)ltp_removeCollectionModel:(LTPLearnWordModel *)model
{
    NSMutableDictionary *allDatas = [self ltp_allCollectionData];
    if (allDatas.count == 0) return NO;
    
    if ([self ltp_isContainedModel:model]) {
        NSMutableDictionary *dict = allDatas[model.style];
        [dict removeObjectForKey:model.en_name];
        
        if (dict.count == 0) {
            [allDatas removeObjectForKey:model.style];
        }
        
        // resave
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        path = [path stringByAppendingPathComponent:@"colectioned.plist"];
        BOOL isSuccess = [allDatas writeToFile:path atomically:YES];
        return isSuccess;
    }
    return NO;
}

- (BOOL)ltp_isContainedModel:(LTPLearnWordModel *)model
{
    NSMutableDictionary *allDatas = [self ltp_allCollectionData];
    if ([allDatas.allKeys containsObject:model.style]) {
        NSDictionary *dict = allDatas[model.style];
        if ([dict.allKeys containsObject:model.en_name]) {
            return YES;
        }
    }
    return NO;
}

- (NSArray *)suoyoudaanArr
{
    return [self.alldaanData copy];
}

- (NSArray *)datasource
{
    return [self.mainData copy];
}
@end
